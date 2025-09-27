# 8-bit ALU (Verilog)

## Summary
This folder contains a synthesizable 8-bit ALU written in Verilog, a deterministic testbench, a randomized testbench with a checker, and instructions to simulate using Icarus Verilog + GTKWave.

## Files
- `rtl/alu8.v` — ALU RTL (ADD, SUB, AND, OR, XOR, SHL, SHR, PASS)
- `tb/tb_alu8.v` — deterministic testbench (creates `alu8.vcd`)
- `tb/tb_alu8_random.v` — randomized testbench + checker (creates `alu8_random.vcd`)
- `results/alu_waveform.png` — example waveform screenshot (add after sim)
  
## Simulate (Icarus + GTKWave)
```bash
cd "Beginner-level VLSI Projects/1. 8-bit ALU"
make sim          # run deterministic test
gtkwave alu8.vcd  # open waveform viewer

# randomized test:
make sim_random
gtkwave alu8_random.vcd

