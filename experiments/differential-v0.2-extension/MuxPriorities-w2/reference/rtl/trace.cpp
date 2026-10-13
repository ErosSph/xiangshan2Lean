#include "VMuxPriorities.h"
#include "verilated.h"
#include <array>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>
#include <vector>
void readWide(const std::string& decimal, WData* words, size_t count) {
  for (size_t i = 0; i < count; ++i) words[i] = 0;
  for (char digit : decimal) {
    uint64_t carry = static_cast<unsigned>(digit - '0');
    for (size_t i = 0; i < count; ++i) {
      uint64_t value = uint64_t(words[i]) * 10 + carry;
      words[i] = static_cast<WData>(value);
      carry = value >> 32;
    }
  }
}
std::string wideHex(const WData* words, size_t count) {
  std::ostringstream result;
  result << "0x" << std::hex << std::setfill('0');
  for (size_t i = count; i > 0; --i) result << std::setw(8) << words[i - 1];
  return result.str();
}
int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  VMuxPriorities dut;
  std::ifstream input("trace.csv");
  std::ofstream output("rtl-results.csv");
  output << "cycle,pre:lookup,pre:muxcase,pre:priority,pre:widthCheck,post:lookup,post:muxcase,post:priority,post:widthCheck\n";
  std::string line;
  std::getline(input, line);
  size_t cycle = 0;
  while (std::getline(input, line)) {
    std::stringstream row(line);
    std::string token;
    std::array<std::string, 7> values;
    size_t field = 0;
    while (std::getline(row, token, ',')) values.at(field++) = token;
    
    
    dut.a = std::stoull(values[1]);
    dut.b = std::stoull(values[2]);
    dut.c = std::stoull(values[3]);
    dut.sel = std::stoull(values[4]);
    dut.x = std::stoull(values[5]);
    dut.y = std::stoull(values[6]);
    dut.eval();
    std::array<std::string, 4> pre = {std::to_string(static_cast<uint64_t>(dut.lookup)), std::to_string(static_cast<uint64_t>(dut.muxcase)), std::to_string(static_cast<uint64_t>(dut.priority_)), std::to_string(static_cast<uint64_t>(dut.widthCheck))};
    
    dut.eval();
    std::array<std::string, 4> post = {std::to_string(static_cast<uint64_t>(dut.lookup)), std::to_string(static_cast<uint64_t>(dut.muxcase)), std::to_string(static_cast<uint64_t>(dut.priority_)), std::to_string(static_cast<uint64_t>(dut.widthCheck))};
    output << cycle++;
    for (auto value : pre) output << ',' << value;
    for (auto value : post) output << ',' << value;
    output << '\n';
    
  }
  dut.final();
  return 0;
}
