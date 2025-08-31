# Design-Your-Own-MIPS-CPU-and-OS

CSE332 Project : A Verilog-based 32-bit single-cycle MIPS CPU with custom assembler support. Implements and tests instructions including JAL and JR, along with subroutine programs for MIN, MAX, and MEAN. Includes debugging notes, testbench files, and memory output verification.

- A working **CPU datapath and control unit**
- A custom **assembler** to convert `.s` files to binary
- **Instruction & data memory modules**
- Programs for calculating **MIN**, **MAX**, and **MEAN**
- Simulation using **ModelSim**

---

## CPU Features

- **Instruction Types**:
  - R-Type: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`
  - I-Type: `LW`, `SW`, `ADDI`, `BEQ`, `BNE`
  - J-Type: `J`, `JAL`, `JR`
- **Registers**: 8 general-purpose (R0–R7), plus `$ra` for return addresses
- **Memory**:
  - `rom.v`: Instruction Memory (loaded from `memfile.txt`)
  - `ram.v`: Data Memory (loaded/stored via `dmem.txt`)
- **Control Flow Support**: Subroutines using `JAL` and `JR`

---

## 🛠️ Assembler

- **Language**: C++
- **Function**: Translates `.s` MIPS assembly files into machine code
- **Outputs**: `no_address.text.bin`, `no_address.data.bin`
- **Issue**: Branch instruction misalignment causes incorrect result for division (AVG). To be fixed.

---

## Benchmark Programs

### MIN, MAX, MEAN (OS-like Subroutine Program)

Assembly file: `insttest2.s`

- Loads 10 values into registers
- Computes:
  - MIN → `$s0`
  - MAX → `$s1`
  - SUM → `$s2`
  - AVG (via custom divide routine) → `$s3`

### ➕ JAL & JR Subroutine Test

- Adds `$a0 + $a1` and stores result in `$v0`
- Demonstrates return address management via `$ra`

---

## Outputs (Simulation Results)

Register values after execution:

| Register | Purpose | Value                 | Status                              |
| -------- | ------- | --------------------- | ----------------------------------- |
| `$s0`    | MIN     | `1`                   | ✅                                  |
| `$s1`    | MAX     | `10`                  | ✅                                  |
| `$s2`    | SUM     | `55`                  | ✅                                  |
| `$s3`    | AVG     | `0 / 1 / 10` (varies) | ❌ _Incorrect due to assembler bug_ |

---

## Simulation & Testing

- **Tool**: ModelSim
- **Testbenches**:
  - `MIPS_SCP_tb.v` for general tests
  - `mips_scp.vcd` and `mips_scp_jal.vcd` for waveform visualization
- **Files**:
  - `memfile.txt`: Instruction memory
  - `dmem.txt`: Data memory
  - `finalassembler.cpp`: Assembler source
  - `insttest2.s`: Assembly test file

---

## Known Issues

- **Assembler Branch Bug**: Causes wrong control flow in `division_sub` routine → Incorrect AVG.
- **AVG Result**: Shows as `0`, `1`, or `10` inconsistently. Other outputs are accurate.

---

## Acknowledgments

- **Instructor**: Dr. Mohammad Abdul Qayum – for his guidance and support.
- **Tools Used**:
  - [ModelSim](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html)
  - [ChatGPT](https://chat.openai.com), [DeepSeek](https://www.deepseek.com) – for debugging assistance
  - [UpgradedMIPS32Assembler GitHub](https://github.com/RoySRC/UpgradedMIPS32Assembler.git)

---

## Final Notes

This project has successfully demonstrated:

- Custom CPU design from ISA to hardware
- Integration of software tools like assemblers and simulators
- Implementation and testing of subroutines, branching, and memory operations

Work is ongoing to fix the assembler bug and improve subroutine branching support.
