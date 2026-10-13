#include "VVectorReset.h"
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
  VVectorReset dut;
  std::ifstream input("trace.csv");
  std::ofstream output("rtl-results.csv");
  output << "cycle,pre:out.0,pre:out.1,pre:out.2,pre:out.3,pre:out.4,post:out.0,post:out.1,post:out.2,post:out.3,post:out.4\n";
  std::string line;
  std::getline(input, line);
  size_t cycle = 0;
  while (std::getline(input, line)) {
    std::stringstream row(line);
    std::string token;
    std::array<std::string, 7> values;
    size_t field = 0;
    while (std::getline(row, token, ',')) values.at(field++) = token;
    dut.clock = 0;
    dut.reset = std::stoull(values[0]);
    dut.in_0 = std::stoull(values[1]);
    dut.in_1 = std::stoull(values[2]);
    dut.in_2 = std::stoull(values[3]);
    dut.in_3 = std::stoull(values[4]);
    dut.in_4 = std::stoull(values[5]);
    dut.en = std::stoull(values[6]);
    dut.eval();
    std::array<std::string, 5> pre = {std::to_string(static_cast<uint64_t>(dut.out_0)), std::to_string(static_cast<uint64_t>(dut.out_1)), std::to_string(static_cast<uint64_t>(dut.out_2)), std::to_string(static_cast<uint64_t>(dut.out_3)), std::to_string(static_cast<uint64_t>(dut.out_4))};
    dut.clock = 1;
    dut.eval();
    std::array<std::string, 5> post = {std::to_string(static_cast<uint64_t>(dut.out_0)), std::to_string(static_cast<uint64_t>(dut.out_1)), std::to_string(static_cast<uint64_t>(dut.out_2)), std::to_string(static_cast<uint64_t>(dut.out_3)), std::to_string(static_cast<uint64_t>(dut.out_4))};
    output << cycle++;
    for (auto value : pre) output << ',' << value;
    for (auto value : post) output << ',' << value;
    output << '\n';
    dut.clock = 0; dut.eval();
  }
  dut.final();
  return 0;
}
