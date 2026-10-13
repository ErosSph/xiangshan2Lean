#include "VBitOperations.h"
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
  VBitOperations dut;
  std::ifstream input("trace.csv");
  std::ofstream output("rtl-results.csv");
  output << "cycle,pre:out,pre:left,pre:right,pre:bit,pre:any,pre:all,pre:parity,post:out,post:left,post:right,post:bit,post:any,post:all,post:parity\n";
  std::string line;
  std::getline(input, line);
  size_t cycle = 0;
  while (std::getline(input, line)) {
    std::stringstream row(line);
    std::string token;
    std::array<std::string, 2> values;
    size_t field = 0;
    while (std::getline(row, token, ',')) values.at(field++) = token;
    dut.clock = 0;
    dut.reset = std::stoull(values[0]);
    dut.in = std::stoull(values[1]);
    dut.eval();
    std::array<std::string, 7> pre = {std::to_string(static_cast<uint64_t>(dut.out)), std::to_string(static_cast<uint64_t>(dut.left)), std::to_string(static_cast<uint64_t>(dut.right)), std::to_string(static_cast<uint64_t>(dut.bit_)), std::to_string(static_cast<uint64_t>(dut.any)), std::to_string(static_cast<uint64_t>(dut.all)), std::to_string(static_cast<uint64_t>(dut.parity))};
    dut.clock = 1;
    dut.eval();
    std::array<std::string, 7> post = {std::to_string(static_cast<uint64_t>(dut.out)), std::to_string(static_cast<uint64_t>(dut.left)), std::to_string(static_cast<uint64_t>(dut.right)), std::to_string(static_cast<uint64_t>(dut.bit_)), std::to_string(static_cast<uint64_t>(dut.any)), std::to_string(static_cast<uint64_t>(dut.all)), std::to_string(static_cast<uint64_t>(dut.parity))};
    output << cycle++;
    for (auto value : pre) output << ',' << value;
    for (auto value : post) output << ',' << value;
    output << '\n';
    dut.clock = 0; dut.eval();
  }
  dut.final();
  return 0;
}
