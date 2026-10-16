"""Check masking, claim/complete and rejection in the independent MMIO adapter."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(os.name != 'nt' and shutil.which('g++'), 'Compile on the Linux server')
class ReferenceDeviceTests(unittest.TestCase):
    def test_mask_claim_complete_and_bad_access(self):
        code = r'''
#include "reference_devices.h"
#include <cassert>
int main() {
  ReferenceDevices d; uint8_t bytes[8]={1};
  assert(!d.load(0x3c200004,4,bytes));
  d.enabled=true;
  bool rejected=false;try{d.assertInterrupt();}catch(const std::runtime_error&){rejected=true;}
  assert(rejected && !d.interruptPending());
  d.line=d.pending=false;
  bytes[0]=1;assert(d.store(0x3c000004,4,bytes));
  bytes[0]=2;assert(d.store(0x3c002000,4,bytes));
  bytes[0]=1;assert(d.store(0x3c200000,4,bytes));
  assert(!d.interruptPending());
  bytes[0]=0;assert(d.store(0x3c200000,4,bytes));
  d.assertInterrupt();assert(d.interruptPending());
  assert(d.load(0x3c200004,4,bytes) && bytes[0]==1 && !d.interruptPending());
  assert(d.load(0x3c200004,4,bytes) && bytes[0]==0);
  bytes[0]=2;rejected=false;try{d.store(0x3c200004,4,bytes);}catch(const std::runtime_error&){rejected=true;}
  assert(rejected);bytes[0]=1;assert(d.store(0x3c200004,4,bytes));assert(d.interruptPending());
  assert(!d.load(0x3c200004,8,bytes) && !d.store(0x3c002004,4,bytes));
  assert(d.load(0x50000000,8,bytes) && bytes[0]==0x78 && bytes[3]==0x12 && bytes[7]==0);
  bytes[0]=1;bytes[1]=0;bytes[2]=0;bytes[3]=0;
  assert(d.store(0x40600000,4,bytes) && d.signature==1);
}
'''
        with tempfile.TemporaryDirectory() as folder:
            work = Path(folder)
            (work / 'test.cpp').write_text(code)
            executable = work / 'test'
            build = subprocess.run(['g++','-std=c++17','-O2','-Wall','-Wextra',
                                    '-I'+str(ROOT/'verification/xiangshan/programs'),str(work/'test.cpp'),
                                    '-o',str(executable)],capture_output=True,text=True)
            self.assertEqual(build.returncode,0,build.stderr)
            result = subprocess.run([str(executable)],capture_output=True,text=True)
            self.assertEqual(result.returncode,0,result.stderr)
