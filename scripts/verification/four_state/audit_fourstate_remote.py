"""Read-only SSH payload for F3.1. Sent on stdin; never installed remotely.

Only stdout/stderr pipes are written. No project code, subprocesses, temporary
files, imports from the project, or fallback from O_NOATIME are allowed.
"""
from pathlib import Path as _BootstrapPath
import sys as _bootstrap_sys

if "__file__" in globals():
    _BOOTSTRAP_FILE = _BootstrapPath(__file__).resolve()
    _SCRIPTS_ROOT = next((parent for parent in _BOOTSTRAP_FILE.parents if parent.name == "scripts"), None)
    if _SCRIPTS_ROOT is None:
        raise RuntimeError("categorized script must be under scripts/")
    _PROJECT_ROOT = _SCRIPTS_ROOT.parent
    for _entry in (_SCRIPTS_ROOT, _BOOTSTRAP_FILE.parent):
        if str(_entry) not in _bootstrap_sys.path:
            _bootstrap_sys.path.insert(0, str(_entry))
else:
    _BOOTSTRAP_FILE = None
    _SCRIPTS_ROOT = None
    _PROJECT_ROOT = None

import hashlib
import json
import os
from pathlib import PurePosixPath
import stat
import sys

ROOT = '/data2/home/lvhongqing/cgt/chisel2lean'
RTL = 'runs/20261016-linux-01/rtl-input'
MAX_BYTES = 2 * 1024 ** 3
MAX_METADATA = 20 * 1024 ** 2


def relative(value):
    if not isinstance(value, str) or '\\' in value or '\x00' in value:
        raise ValueError('invalid relative path')
    if value == '':
        return ()
    parts = value.split('/')
    if value.startswith('/') or any(p in ('', '.', '..') for p in parts):
        raise ValueError('path is not a canonical relative path: ' + value)
    if PurePosixPath(value).is_absolute():
        raise ValueError('absolute path refused')
    return tuple(parts)


def signature(s):
    return dict(device=s.st_dev, inode=s.st_ino, bytes=s.st_size,
                mtime_ns=s.st_mtime_ns, ctime_ns=s.st_ctime_ns,
                atime_ns=s.st_atime_ns, mode=s.st_mode, links=s.st_nlink)


class Reader:
    def __init__(self):
        for flag in ('O_NOATIME', 'O_NOFOLLOW', 'O_DIRECTORY', 'O_PATH'):
            if not hasattr(os, flag):
                raise RuntimeError('required flag unavailable: ' + flag)
        # O_PATH traverses only the explicitly named root's ancestors, without
        # reading their contents. Refuse every symlink, including ancestors.
        fd = os.open('/', os.O_PATH | os.O_DIRECTORY | os.O_NOFOLLOW)
        try:
            for part in ROOT.strip('/').split('/'):
                child = os.open(part, os.O_PATH | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=fd)
                os.close(fd)
                fd = child
            self.root = os.open('.', self.dirflags, dir_fd=fd)
        finally:
            os.close(fd)
        self.device = os.fstat(self.root).st_dev

    @property
    def dirflags(self):
        return os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW | os.O_NOATIME

    def directory(self, name):
        fd = os.dup(self.root)
        try:
            for part in relative(name):
                child = os.open(part, self.dirflags, dir_fd=fd)
                os.close(fd)
                fd = child
                if os.fstat(fd).st_dev != self.device:
                    raise ValueError('cross-device directory refused: ' + name)
            return fd
        except BaseException:
            os.close(fd)
            raise

    def file(self, name):
        parts = relative(name)
        if not parts:
            raise ValueError('file path required')
        parent = self.directory('/'.join(parts[:-1]))
        try:
            fd = os.open(parts[-1], os.O_RDONLY | os.O_NOFOLLOW | os.O_NOATIME | os.O_NONBLOCK,
                         dir_fd=parent)
        finally:
            os.close(parent)
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode) or info.st_dev != self.device:
            os.close(fd)
            raise ValueError('regular same-device file required: ' + name)
        return fd

    def listing(self, name):
        fd = self.directory(name)
        try:
            before = signature(os.fstat(fd))
            with os.scandir(fd) as entries:
                rows = []
                for entry in entries:
                    info = entry.stat(follow_symlinks=False)
                    rows.append(dict(name=entry.name, **signature(info)))
                    if len(rows) > 10000:
                        raise ValueError('directory entry budget exceeded')
            after = signature(os.fstat(fd))
            if before != after:
                raise ValueError('directory changed during listing: ' + name)
            return sorted(rows, key=lambda r: r['name'])
        finally:
            os.close(fd)

    def read(self, name, limit):
        fd = self.file(name)
        try:
            before = signature(os.fstat(fd))
            if before['bytes'] > limit:
                raise ValueError('metadata byte budget exceeded: ' + name)
            chunks = []
            while True:
                chunk = os.read(fd, 1024 * 1024)
                if not chunk:
                    break
                chunks.append(chunk)
                if sum(map(len, chunks)) > limit:
                    raise ValueError('growing file exceeds budget')
            if signature(os.fstat(fd)) != before:
                raise ValueError('file changed: ' + name)
            data = b''.join(chunks)
            return dict(path=name, stat=before, sha256=hashlib.sha256(data).hexdigest(),
                        text=data.decode('utf-8', errors='strict'))
        finally:
            os.close(fd)

    def inventory(self):
        files, directories, ignored = [], {}, []

        def walk(name):
            rows = self.listing(name)
            directories[name] = rows
            for row in rows:
                path = name + '/' + row['name']
                mode = row['mode']
                if stat.S_ISLNK(mode) or row['device'] != self.device:
                    raise ValueError('symlink/cross-device entry refused: ' + path)
                if stat.S_ISDIR(mode):
                    # Only traverse the designated RTL input, never obj_dir.
                    if row['name'] in ('obj_dir', 'previous-working-files', '__pycache__', '.git'):
                        ignored.append(path)
                    else:
                        walk(path)
                elif stat.S_ISREG(mode):
                    if PurePosixPath(path).suffix.lower() in ('.sv', '.v', '.svh', '.vh', '.f'):
                        files.append(dict(path=path, **row))
                    else:
                        ignored.append(path)
                else:
                    raise ValueError('special entry refused: ' + path)
        walk(RTL)
        total = sum(r['bytes'] for r in files)
        if total > MAX_BYTES:
            raise ValueError('RTL exceeds 2 GiB hard limit')
        return dict(root=ROOT, rtl=RTL, files=files, directories=directories,
                    ignored=ignored, bytes=total)


def emit(value):
    sys.stdout.buffer.write(json.dumps(value, ensure_ascii=True).encode('utf-8') + b'\n')
    sys.stdout.buffer.flush()


def main():
    # REQUEST is inserted by the local launcher, never loaded from a server file.
    request = globals().get('REQUEST', {})
    reader = Reader()
    mode = sys.argv[1]
    if mode == 'preflight':
        result = dict(root=ROOT, root_stat=signature(os.fstat(reader.root)),
                      interpreter=sys.version, flags='O_RDONLY|O_NOFOLLOW|O_NOATIME', listings={})
        for name in ('', 'runs/20261016-linux-01', 'runs/20261016-linux-01/model'):
            result['listings'][name] = reader.listing(name)
        # Actually open the two fixed inputs with O_NOATIME before any content read.
        for name in ('runs/20261016-linux-01/model/manifest.json', RTL + '/XSTop.sv'):
            fd = reader.file(name)
            os.close(fd)
        emit(result)
    elif mode == 'metadata':
        result, total = dict(files=[], listings={}, missing=[]), 0
        for name in request.get('directories', []):
            try:
                result['listings'][name] = reader.listing(name)
            except FileNotFoundError:
                result['missing'].append(name)
        for name in request.get('files', []):
            try:
                item = reader.read(name, min(5 * 1024 ** 2, MAX_METADATA - total))
                total += item['stat']['bytes']
                result['files'].append(item)
            except FileNotFoundError:
                result['missing'].append(name)
        emit(result)
    elif mode == 'inventory':
        emit(reader.inventory())
    elif mode == 'stream':
        expected = request['inventory']
        current = reader.inventory()
        if current != expected:
            raise ValueError('inventory changed before stream')
        hashes = []
        for entry in expected['files']:
            name = entry['path']
            fd = reader.file(name)
            try:
                before = signature(os.fstat(fd))
                if any(before[k] != entry[k] for k in before):
                    raise ValueError('file changed before stream: ' + name)
                emit(dict(type='file', path=name, bytes=before['bytes']))
                checksum, count = hashlib.sha256(), 0
                while True:
                    chunk = os.read(fd, 1024 * 1024)
                    if not chunk:
                        break
                    count += len(chunk)
                    if count > before['bytes']:
                        raise ValueError('file grew during stream')
                    checksum.update(chunk)
                    sys.stdout.buffer.write(chunk)
                if count != before['bytes'] or signature(os.fstat(fd)) != before:
                    raise ValueError('file changed during stream: ' + name)
                record = dict(path=name, bytes=count, sha256=checksum.hexdigest(), stat=before)
                hashes.append(record)
                emit(dict(type='digest', **record))
            finally:
                os.close(fd)
        if reader.inventory() != expected:
            raise ValueError('inventory changed after stream')
        emit(dict(type='complete', files=len(hashes), bytes=sum(r['bytes'] for r in hashes)))
    else:
        raise ValueError('unknown mode')


if __name__ == '__main__':
    main()
