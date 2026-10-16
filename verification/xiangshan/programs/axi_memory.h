// External byte-addressed memory and AXI4 slave; no CPU or cache state is set.
#pragma once
#include <array>
#include <cstdint>
#include <deque>
#include <fstream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <vector>
#include <algorithm>
#include <sstream>

struct ByteMemory {
    std::unordered_map<uint64_t, uint8_t> bytes;
    uint64_t signature = 0;
    static constexpr uint64_t signatureAddress = 0x40600000;
    void load(const std::string& path, uint64_t address) {
        std::ifstream f(path, std::ios::binary);
        if (!f) throw std::runtime_error("Cannot read program image");
        char c;
        while (f.get(c)) bytes[address++] = static_cast<uint8_t>(c);
    }
    void loadSegments(const std::string& path) {
        std::ifstream manifest(path);
        if (!manifest) throw std::runtime_error("Cannot read ELF image manifest");
        std::string line; std::getline(manifest,line);
        while (std::getline(manifest,line)) {
            std::istringstream row(line); std::string file,address,size,memorySize;
            if (!std::getline(row,file,',') || !std::getline(row,address,',') ||
                !std::getline(row,size,',') || !std::getline(row,memorySize,','))
                throw std::runtime_error("Invalid staged ELF segment");
            uint64_t start=std::stoull(address), length=std::stoull(size), limit=std::stoull(memorySize);
            if (length>limit || !((start>=0x10000000 && start+limit<=0x10001000) ||
                                 (start>=0x80000000 && start+limit<=0x88000000)))
                throw std::runtime_error("ELF segment outside external memory");
            std::ifstream image(file,std::ios::binary|std::ios::ate);
            if (!image || image.tellg()<0 || uint64_t(image.tellg())!=length)
                throw std::runtime_error("Staged ELF segment length mismatch");
            load(file,start);
        }
    }
    uint8_t read(uint64_t address) const {
        auto found = bytes.find(address);
        return found == bytes.end() ? 0 : found->second;
    }
    void write(uint64_t address, uint8_t value) {
        bytes[address] = value;
        if (address >= signatureAddress && address < signatureAddress + 8) {
            unsigned shift = (address - signatureAddress) * 8;
            signature = (signature & ~(uint64_t(255) << shift)) | (uint64_t(value) << shift);
        }
    }
    void dump(const std::string& path) const {
        std::vector<std::pair<uint64_t,uint8_t>> sorted(bytes.begin(), bytes.end());
        std::sort(sorted.begin(), sorted.end());
        std::ofstream f(path); f << "address,data\n";
        for (const auto& item : sorted) f << item.first << ',' << unsigned(item.second) << '\n';
    }
};

struct AxiAddress {
    uint64_t id, address, len, size, burst;
    uint64_t beat = 0, due = 0;
    uint64_t at() const {
        if (burst == 0) return address;
        uint64_t current = (address & ~((uint64_t(1) << size) - 1)) + (beat << size);
        if (beat == 0) return address;
        if (burst == 1) return current;
        uint64_t span = (len + 1) << size;
        return (address & ~(span - 1)) | (current & (span - 1));
    }
};

template <size_t Bytes> struct AxiSlave {
    struct WriteBeat { std::array<uint8_t, Bytes> data; uint64_t strobe; bool last; };
    struct Sample {
        bool ar = false, aw = false, w = false, r = false, b = false;
        AxiAddress readAddress{}, writeAddress{};
        WriteBeat writeData{};
    };
    ByteMemory& memory;
    std::deque<AxiAddress> reads, writes;
    std::deque<WriteBeat> writeData;
    std::deque<std::pair<uint64_t,uint64_t>> responses;
    bool rvalid = false, bvalid = false;
    std::array<uint8_t,Bytes> rdata{};
    uint64_t rid = 0, bid = 0;
    bool rlast = false;
    uint64_t readRequests = 0, writeRequests = 0, readBeats = 0, writeBeats = 0;
    uint64_t cycle = 0, latency = 2;
    // Optional test-device delay, applied once when AR is accepted.
    uint64_t delayedReadAddress = 0, extraReadLatency = 0;
    explicit AxiSlave(ByteMemory& mem) : memory(mem) {}
    void validate(const AxiAddress& a) const {
        if (a.size >= 64 || (uint64_t(1) << a.size) > Bytes || a.burst > 2 || a.len > 255)
            throw std::runtime_error("Unsupported AXI burst or beat size");
        if (a.burst == 2 && ((a.len+1) < 2 || (a.len+1) > 16 || ((a.len+1) & a.len)))
            throw std::runtime_error("Invalid AXI wrapping burst");
        uint64_t last = (a.address & ~((uint64_t(1) << a.size) - 1)) + ((a.len + 1) << a.size) - 1;
        if (a.burst == 1 && (a.address >> 12) != (last >> 12))
            throw std::runtime_error("AXI burst crosses 4 KiB boundary");
    }
    bool arready() const { return reads.size() < 32; }
    bool awready() const { return writes.size() < 32 && responses.size() < 32; }
    bool wready() const { return writeData.size() < 256; }
    void drive(uint64_t now) {
        cycle = now;
        if (!rvalid && !reads.empty() && reads.front().due <= now) {
            auto& a = reads.front();
            uint64_t base = a.at() & ~(uint64_t(Bytes) - 1);
            for (size_t i = 0; i < Bytes; ++i) rdata[i] = memory.read(base + i);
            rid = a.id; rlast = a.beat == a.len; rvalid = true;
        }
        bvalid = !responses.empty() && responses.front().second <= now;
        if (bvalid) bid = responses.front().first;
    }
    void edge(const Sample& s, std::ostream& log, const char* name) {
        if (s.r) {
            if (!rvalid || reads.empty()) throw std::runtime_error("Unexpected R handshake");
            ++readBeats;
            auto& a = reads.front();
            log << cycle << ',' << name << ",R," << a.id << ',' << a.at() << ',' << a.beat << ',' << rlast << '\n';
            if (rlast) reads.pop_front(); else ++a.beat;
            rvalid = false;
        }
        if (s.b) {
            if (!bvalid) throw std::runtime_error("Unexpected B handshake");
            responses.pop_front(); bvalid = false;
        }
        if (s.ar) {
            validate(s.readAddress); auto a = s.readAddress; a.due = cycle + latency;
            if (extraReadLatency && a.address == delayedReadAddress) a.due += extraReadLatency;
            reads.push_back(a); ++readRequests;
            log << cycle << ',' << name << ",AR," << a.id << ',' << a.address << ',' << a.len << ',' << a.size << '\n';
        }
        if (s.aw) {
            validate(s.writeAddress); writes.push_back(s.writeAddress); ++writeRequests;
            log << cycle << ',' << name << ",AW," << s.writeAddress.id << ',' << s.writeAddress.address << ',' << s.writeAddress.len << ',' << s.writeAddress.size << '\n';
        }
        if (s.w) writeData.push_back(s.writeData);
        if (!writes.empty() && !writeData.empty()) {
            auto& a = writes.front(); auto beat = writeData.front(); writeData.pop_front();
            bool last = a.beat == a.len;
            if (beat.last != last) throw std::runtime_error("WLAST does not match AWLEN");
            uint64_t address = a.at(), base = address & ~(uint64_t(Bytes) - 1);
            uint64_t upper = (address & ~((uint64_t(1) << a.size) - 1)) + (uint64_t(1) << a.size);
            for (size_t i = 0; i < Bytes; ++i) if ((beat.strobe >> i) & 1) {
                if (base + i < address || base + i >= upper)
                    throw std::runtime_error("WSTRB writes outside the transfer");
                memory.write(base + i, beat.data[i]);
            }
            ++writeBeats;
            log << cycle << ',' << name << ",W," << a.id << ',' << address << ',' << beat.strobe << ',' << last << '\n';
            if (last) { responses.emplace_back(a.id, cycle + latency); writes.pop_front(); }
            else ++a.beat;
        }
    }
};
