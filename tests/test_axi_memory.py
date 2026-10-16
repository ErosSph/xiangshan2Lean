"""Check protocol behavior of the program driver's external AXI memory."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(os.name != 'nt' and shutil.which('g++'), 'Compile the AXI regression on the Linux server')
class AxiMemoryTests(unittest.TestCase):
    def test_queue_order_masks_bursts_and_stalled_responses(self):
        code = r'''
#include "axi_memory.h"
#include <cassert>
#include <sstream>
int main() {
  ByteMemory memory; std::ostringstream log;
  AxiSlave<8> a(memory);
  AxiSlave<8>::Sample s;
  s.w=true; s.writeData.last=true; s.writeData.strobe=0xf0;
  for(unsigned i=4;i<8;++i) s.writeData.data[i]=i+10;
  a.drive(0); a.edge(s,log,"p");
  assert(a.writeBeats==0 && memory.read(0x80000004)==0);
  s={}; s.aw=true; s.writeAddress={7,0x80000004,0,2,1};
  a.drive(1); a.edge(s,log,"p");
  assert(a.writeBeats==1 && memory.read(0x80000003)==0 && memory.read(0x80000004)==14);
  a.drive(2); assert(!a.bvalid); a.drive(3); assert(a.bvalid && a.bid==7);
  a.drive(4); assert(a.bvalid && a.bid==7);
  s={}; s.b=true; s.ar=true; s.readAddress={3,0x80000000,1,3,1}; a.edge(s,log,"p");
  a.drive(6); assert(a.rvalid && !a.rlast && a.rid==3 && a.rdata[4]==14);
  memory.write(0x80000004,99); a.drive(7); assert(a.rdata[4]==14);
  s={}; s.r=true; a.edge(s,log,"p"); a.drive(8);
  assert(a.rvalid && a.rlast && a.rdata[0]==0);
  a.edge(s,log,"p"); a.drive(9); assert(!a.rvalid && a.readBeats==2 && a.reads.empty());
  AxiSlave<32> b(memory); AxiSlave<32>::Sample w;
  w.aw=w.w=true; w.writeAddress={19,0x80000020,0,5,1};w.writeData.last=true;w.writeData.strobe=0x80000001;
  w.writeData.data[0]=41; w.writeData.data[31]=42;
  b.drive(0); b.edge(w,log,"d");
  assert(memory.read(0x80000020)==41 && memory.read(0x8000003f)==42 && memory.read(0x80000021)==0);
  AxiAddress wrap{1,0x38,3,3,2}; assert(wrap.at()==0x38);wrap.beat=1;assert(wrap.at()==0x20);
  wrap.beat=3;assert(wrap.at()==0x30);
  a.validate({0,4095,0,3,1});
  bool rejected=false;try {a.validate({0,4092,1,3,1});}catch(const std::runtime_error&){rejected=true;}assert(rejected);
  rejected=false;try {a.validate({0,0,0,64,1});}catch(const std::runtime_error&){rejected=true;}assert(rejected);
  rejected=false;try {a.validate({0,0,2,3,2});}catch(const std::runtime_error&){rejected=true;}assert(rejected);
  AxiSlave<8> bad(memory); AxiSlave<8>::Sample x; x.aw=x.w=true;x.writeAddress={0,0,1,3,1};x.writeData.last=true;
  rejected=false;try {bad.edge(x,log,"bad");}catch(const std::runtime_error&){rejected=true;}assert(rejected);
  { std::ofstream image("segment-0.bin",std::ios::binary);image.put(char(0x12));image.put(char(0x34)); }
  { std::ofstream manifest("segments.csv");manifest << "file,address,file_size,memory_size\nsegment-0.bin,2147483648,2,16\n"; }
  ByteMemory loaded; loaded.loadSegments("segments.csv");
  assert(loaded.read(0x80000000)==0x12 && loaded.read(0x80000001)==0x34 && loaded.read(0x80000002)==0);
  { std::ofstream manifest("segments.csv");manifest << "file,address,file_size,memory_size\nsegment-0.bin,2147483648,3,16\n"; }
  rejected=false;try {loaded.loadSegments("segments.csv");}catch(const std::runtime_error&){rejected=true;}assert(rejected);
  AxiSlave<8> delayed(memory); delayed.delayedReadAddress=0x50000000; delayed.extraReadLatency=500;
  s={};s.ar=true;s.readAddress={4,0x50000000,0,3,1};delayed.drive(10);delayed.edge(s,log,"io");
  delayed.drive(511);assert(!delayed.rvalid && delayed.reads.front().due==512);
  delayed.drive(512);assert(delayed.rvalid && delayed.rid==4);
  delayed.drive(600);assert(delayed.rvalid && delayed.rid==4);
  s={};s.r=true;delayed.edge(s,log,"io");assert(delayed.reads.empty());
}
'''
        with tempfile.TemporaryDirectory() as folder:
            work = Path(folder)
            (work / 'test.cpp').write_text(code)
            executable = work / 'test'
            build = subprocess.run(['g++', '-std=c++17', '-O2', '-Wall', '-Wextra',
                                    '-I'+str(ROOT/'verification/xiangshan/programs'), str(work/'test.cpp'),
                                    '-o', str(executable)], capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            result = subprocess.run([str(executable)], cwd=work, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == '__main__':
    unittest.main()
