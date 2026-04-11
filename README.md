# CPU32 – Simple RISC‑V CPU (Verilog)

## Overview
CPU32 is a simple single‑cycle RISC‑V style processor implemented in Verilog.
The processor supports core arithmetic, logic, shift, and branch instructions and is designed to run and be simulated using ModelSim.

This project demonstrates how a processor datapath, control unit, ALU, register file, and memory interact to execute instructions.

---

## CPU Architecture

Main components:

- Program Counter (PC)
- Instruction Memory
- Control Unit
- Register File
- ALU
- Immediate Generator
- Data Memory
- Branch Unit

---

## Supported Instructions

Arithmetic / Logic
- ADD
- ADDI
- SUB
- AND
- OR
- XOR
- SLT

Shift Instructions
- SLL / SLLI
- SRL / SRLI
- SRA / SRAI

Branch
- BNE

---

## Test Programs

1. ALU + Logic Test
2. Shift + Signed Number Test
3. Data Dependency Chain Test
4. Branch Loop Test

Example program:

x1 = 3
x2 = 0

loop:
x2 = x2 + x1
x1 = x1 - 1
BNE x1, x0, loop

Expected result:

x2 = 6

---

## Running the Simulation

vlog ../rtl/*.v
vlog cpu32_tb.v
vsim cpu32_tb
do run_cpu.do

Increase simulation runtime if necessary in run_cpu.do:

run 200ns

---

## Debugging Tips

Useful waveform signals:

pc_value
instruction
reg_data1
reg_data2
alu_result
writeback_data

To monitor registers directly:

add wave -radix decimal /cpu32_tb/uut/cpu_datapath/registers/regs[1]
add wave -radix decimal /cpu32_tb/uut/cpu_datapath/registers/regs[2]

---

## Future Improvements

- Full RV32I instruction support
- Pipeline implementation
- Hazard detection / forwarding
- Support for additional branch instructions
- FPGA deployment

---

## License
Educational project for computer architecture / FPGA coursework.
