# Synchronous FIFO

## Overview

This project implements a synchronous FIFO (First-In, First-Out) buffer in SystemVerilog. It stores data in the order it is written and returns the oldest data first.

## Features

- 4 entries, 8 bits each
- Synchronous clocked operation
- Active-low read (`RD`) and write (`WR`) controls
- Read and write pointers
- Count-based `empty` and `full` flags
- Synchronous reset

## FIFO Specifications

| Item | Value |
| --- | --- |
| Data width | 8 bits |
| FIFO depth | 4 entries |
| Storage | 4 x 8-bit memory |
| Reset | Synchronous, active-high |
| Read control | Active-low `RD` |
| Write control | Active-low `WR` |

## Signals

| Signal | Direction | Description |
| --- | --- | --- |
| `clk` | Input | Clock signal |
| `rst` | Input | Synchronous reset |
| `RD` | Input | Active-low read enable |
| `WR` | Input | Active-low write enable |
| `data_in[7:0]` | Input | Data written into the FIFO |
| `data_out[7:0]` | Output | Data read from the FIFO |
| `empty` | Output | High when no data is stored |
| `full` | Output | High when all four entries are stored |

## How It Works

When `WR` is low and the FIFO is not full, `data_in` is stored at the write pointer and the write pointer advances.

When `RD` is low and the FIFO is not empty, the data at the read pointer is assigned to `data_out` and the read pointer advances.

The `count` register tracks the number of stored entries. It increments for a write, decrements for a read, and stays unchanged when a read and write occur together.

## Files

- `design.sv` - FIFO design module
- `testbench.sv` - Testbench for reset, write, read, full, empty, and simultaneous read/write behavior

## Simulation

Compile and run the design with the testbench using your preferred SystemVerilog simulator. The testbench generates a VCD waveform file named `fifo_tb.vcd`.

Example with Icarus Verilog:

```bash
iverilog -g2012 -o fifo_sim design.sv testbench.sv
vvp fifo_sim
gtkwave fifo_tb.vcd
```

## Waveform

<img width="1654" height="779" alt="Screenshot 2026-09-30 at 4 03 25 PM" src="https://github.com/user-attachments/assets/4ccc9bb1-9ffa-4b11-a80d-d1cb57a4bba9" />

## Notes

- `RD` and `WR` are active low: use `0` to request a read or write.
- A write is ignored when the FIFO is full.
- A read is ignored when the FIFO is empty.
- Data is read in the same order in which it was written.
