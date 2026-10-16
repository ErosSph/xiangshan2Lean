// Independent, deliberately small test devices for the Spike simif adapter.
// Only source 1 / M context 0 is implemented; other MMIO accesses fault.
#pragma once
#include <cstdint>
#include <cstddef>
#include <stdexcept>

struct ReferenceDevices {
  bool enabled = false, line = false, pending = false, claimed = false;
  uint32_t priority = 0, enables = 0, threshold = 0;
  uint64_t signature = 0;
  bool interruptPending() const {
    return enabled && pending && (enables & 2) && priority > threshold;
  }
  void assertInterrupt() {
    if (!enabled || line) throw std::runtime_error("Unexpected test interrupt event");
    line = pending = true;
    if (!interruptPending()) throw std::runtime_error("Reference PLIC source is masked/unconfigured");
  }
  bool load(uint64_t address, size_t length, uint8_t* data) {
    uint64_t value = 0;
    if (address >= 0x40600000 && address < 0x40600008 && length <= 0x40600008-address) {
      value = signature >> (8*(address-0x40600000));
    } else if (enabled && address == 0x50000000 && length == 8) {
      value = 0x12345678;
    } else if (enabled && length == 4) {
      if (address == 0x3c000004) value = priority;
      else if (address == 0x3c002000) value = enables;
      else if (address == 0x3c200000) value = threshold;
      else if (address == 0x3c200004) {
        if (interruptPending()) { value=1; pending=false; claimed=true; }
      } else return false;
    } else return false;
    for (size_t i=0;i<length;++i) data[i]=value>>(8*i);
    return true;
  }
  bool store(uint64_t address, size_t length, const uint8_t* data) {
    if (length > 8) return false;
    uint64_t value=0;
    for (size_t i=0;i<length;++i) value |= uint64_t(data[i])<<(8*i);
    if (address >= 0x40600000 && address < 0x40600008 && length <= 0x40600008-address) {
      for (size_t i=0;i<length;++i) {
        unsigned shift=8*(address-0x40600000+i);
        signature=(signature & ~(uint64_t(255)<<shift)) | (uint64_t(data[i])<<shift);
      }
      return true;
    }
    if (!enabled || length != 4) return false;
    if (address == 0x3c000004) priority=value & 7;
    else if (address == 0x3c002000) enables=value & 2;
    else if (address == 0x3c200000) threshold=value & 7;
    else if (address == 0x3c200004) {
      if (value != 1 || !claimed) throw std::runtime_error("Invalid reference PLIC completion");
      claimed=false; pending=line;
    } else return false;
    return true;
  }
};
