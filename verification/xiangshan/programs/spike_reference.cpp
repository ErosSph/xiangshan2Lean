// A memory/interface adapter around the official Spike processor, not an ISA
// interpreter. Start at the agreed program entry without Spike's boot ROM.
#include "config.h"
#include "riscv/processor.h"
#include "riscv/simif.h"
#include "riscv/csrs.h"
#include "riscv/encoding.h"
#include "reference_devices.h"
#include <algorithm>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <vector>
#include <set>

struct Memory final : simif_t {
  std::vector<char> rom = std::vector<char>(4096, 0);
  std::vector<char> ram = std::vector<char>(128 * 1024 * 1024, 0);
  std::set<uint64_t> initializedRam;
  ReferenceDevices devices;
  char* addr_to_mem(reg_t address) override {
    if (address >= 0x10000000 && address < 0x10000000 + rom.size())
      return rom.data() + address - 0x10000000;
    if (address >= 0x80000000 && address < 0x80000000 + ram.size())
      return ram.data() + address - 0x80000000;
    return nullptr;
  }
  bool mmio_load(reg_t address, size_t length, uint8_t* data) override {
    return devices.load(address,length,data);
  }
  bool mmio_store(reg_t address, size_t length, const uint8_t* data) override {
    return devices.store(address,length,data);
  }
  void proc_reset(unsigned) override {}
  const char* get_symbol(uint64_t) override { return nullptr; }
  void load(const std::string& path) {
    if (path.size()>=4 && path.substr(path.size()-4)==".csv") {
      std::ifstream manifest(path); std::string line;
      if (!manifest) throw std::runtime_error("Cannot read staged ELF manifest");
      std::getline(manifest,line);
      while (std::getline(manifest,line)) {
        std::istringstream row(line); std::string file,address,size,memorySize;
        if (!std::getline(row,file,',') || !std::getline(row,address,',') ||
            !std::getline(row,size,',') || !std::getline(row,memorySize,','))
          throw std::runtime_error("Invalid staged ELF segment");
        uint64_t start=std::stoull(address), length=std::stoull(size), limit=std::stoull(memorySize);
        if (length>limit || !((start>=0x10000000 && start+limit<=0x10001000) ||
                             (start>=0x80000000 && start+limit<=0x88000000)))
          throw std::runtime_error("ELF segment outside reference memory");
        std::ifstream image(file,std::ios::binary|std::ios::ate);
        if (!image || image.tellg()<0 || uint64_t(image.tellg())!=length)
          throw std::runtime_error("Staged ELF segment length mismatch");
        image.seekg(0);
        if (!image.read(addr_to_mem(start), length)) throw std::runtime_error("Short ELF segment read");
        if (start>=0x80000000)
          for (uint64_t i=0;i<length;++i) initializedRam.insert(start+i);
      }
    } else {
      std::ifstream program(path,std::ios::binary|std::ios::ate);
      if (!program || program.tellg()<0 || size_t(program.tellg())>rom.size())
        throw std::runtime_error("Program does not fit the configured ROM");
      size_t length=size_t(program.tellg());program.seekg(0);
      if (!program.read(rom.data(),length)) throw std::runtime_error("Short program read");
    }
  }
};

int main(int argc, char** argv) { try {
  if (argc < 2 || argc > 4) throw std::runtime_error("usage: spike-reference image [retired-count [interrupts.csv]]");
  uint64_t targetCommits = argc>=3 ? std::stoull(argv[2]) : 0;
  uint64_t interruptAt=0, interruptPc=0; bool interruptInjected=false;
  Memory memory;
  if (argc==4) {
    std::ifstream events(argv[3]);std::string line,ordinal,pc;
    if (!events || !std::getline(events,line) || line!="committed,mepc" || !std::getline(events,line))
      throw std::runtime_error("Missing reference interrupt boundary");
    std::istringstream row(line);
    if (!std::getline(row,ordinal,',') || !std::getline(row,pc,',') || std::getline(events,line))
      throw std::runtime_error("Expected exactly one test interrupt boundary");
    interruptAt=std::stoull(ordinal);interruptPc=std::stoull(pc);
    if (interruptAt>=targetCommits) throw std::runtime_error("Interrupt outside the retirement trace");
    memory.devices.enabled=true;
  }
  memory.load(argv[1]);
  FILE* log = fopen("spike-commits.log", "w");
  if (!log) throw std::runtime_error("cannot create commit log");
  std::ostringstream diagnostics;
  processor_t cpu("RV64GC", "MSU", "vlen:128,elen:64", &memory, 0, false, log, diagnostics);
  cpu.get_state()->pc = 0x10000000;
  cpu.enable_log_commits();
  std::ofstream registers("registers.csv");
  std::set<uint64_t> storedBytes = memory.initializedRam;
  uint64_t committed = 0;
  registers << "commit";
  for (unsigned r=0; r<32; ++r) registers << ",x" << r;
  registers << '\n';
  for (unsigned r=0; r<32; ++r)
    if (cpu.get_state()->XPR[r] != 0) throw std::runtime_error("Spike reset GPR is not zero");
  for (uint64_t step=0; step<100000; ++step) {
    if (memory.devices.enabled && !interruptInjected && committed==interruptAt) {
      if (cpu.get_state()->pc != interruptPc) throw std::runtime_error("Reference PC differs at interrupt boundary");
      memory.devices.assertInterrupt();interruptInjected=true;
    }
    cpu.get_state()->mip->backdoor_write_with_mask(MIP_MEIP, memory.devices.interruptPending() ? MIP_MEIP : 0);
    fflush(log); long before = ftell(log);
    cpu.step(1);
    fflush(log); long after = ftell(log);
    if (before < 0 || after < before) throw std::runtime_error("cannot track official commit log");
    if (after != before) {
      registers << committed++;
      for (unsigned r=0; r<32; ++r) registers << ',' << uint64_t(cpu.get_state()->XPR[r]);
      registers << '\n';
      for (const auto& store : cpu.get_state()->log_mem_write) {
        uint64_t address = std::get<0>(store), length = std::get<2>(store);
        for (uint64_t i=0; i<length; ++i)
          if (address+i >= 0x80000000 && address+i < 0x80000000 + memory.ram.size())
            storedBytes.insert(address+i);
      }
    }
    if ((targetCommits && committed >= targetCommits) || (!targetCommits && memory.devices.signature) || memory.devices.signature>1) {
      if (memory.devices.enabled && !interruptInjected) throw std::runtime_error("Reference interrupt not injected");
      std::cout << "{\"status\":\"" << (memory.devices.signature==1 ? "SPIKE_PROGRAM_COMPLETED" : "PROGRAM_FAILED")
                << "\",\"signature\":" << memory.devices.signature << ",\"steps\":" << step+1
                << ",\"committed\":" << committed
                << ",\"initial_pc\":268435456,\"initial_gprs\":\"all zero\"}\n";
      std::ofstream bytes("reference-memory.csv"); bytes << "address,data\n";
      for (uint64_t address : storedBytes) bytes << address << ',' << unsigned(uint8_t(*memory.addr_to_mem(address))) << '\n';
      fclose(log); return memory.devices.signature==1 ? 0 : 9;
    }
  }
  fclose(log); throw std::runtime_error("Spike program did not finish");
} catch (const std::exception& error) { std::cerr << error.what() << '\n'; return 2; } }
