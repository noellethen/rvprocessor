# RISC-V Processor with Pipelining, Hazard Detection, and Branch Prediction

A 5-stage pipelined RISC-V processor implementation supporting the RV32I instruction set with multiplication/division extensions, comprehensive hazard handling, and 2-bit saturating counter branch predictor.

## Features

### Core Architecture
- **5-Stage Pipeline**: Fetch, Decode, Execute, Memory, Writeback
- **RV32I Base Instruction Set**: Full support for integer operations
- **M Extension**: Hardware multiplication and division (signed/unsigned)
- **32-bit Data Path**: 32 general-purpose registers (x0-x31)

### Advanced Features
- **Hazard Detection and Resolution**
  - Data forwarding (EX-to-EX, MEM-to-EX, WB-to-EX)
  - Write-back to Decode forwarding
  - Load-use hazard detection with stalling
  - Memory-to-memory copy handling
- **Branch Prediction**
  - 2-bit saturating counter prediction
  - Branch History Table (BHT) with configurable size (default: 4096 entries)
  - Branch Target Buffer (BTB) for target address prediction
  - Misprediction recovery with pipeline flushing
- **Multi-Cycle Operations**
  - Booth's algorithm for signed multiplication
  - Unsigned multiplication support
  - Signed/unsigned division with remainder

### Memory-Mapped I/O
- UART (transmit/receive with ready/valid handshaking)
- OLED display controller (96x64 RGB)
- Accelerometer interface (ADXL362)
- LEDs, DIP switches, push buttons
- 7-segment display
- Cycle counter

## Module Descriptions

### Core Pipeline Modules

#### `RV.v`
Top-level processor module integrating all pipeline stages and control logic.

#### `ProgramCounter.v`
Program counter with support for:
- Sequential execution
- Branch/jump target calculation
- Predicted and actual branch target selection

#### `RegFile.v`
32-entry register file with:
- Dual read ports (asynchronous)
- Single write port (synchronous)
- x0 hardwired to zero

### Pipeline Stage Registers

#### `DecodePipelineRegisters.v`
Fetch-to-Decode stage registers storing:
- Instruction and PC
- Branch prediction information (predicted taken, predicted BTA)

#### `ExecutePipelineRegisters.v`
Decode-to-Execute stage registers storing:
- Control signals
- Source operands
- ALU control
- Register addresses
- Prediction information

#### `MemoryPipelineRegisters.v`
Execute-to-Memory stage registers storing:
- Memory access signals
- ALU result
- Write data

#### `WritebackPipelineRegisters.v`
Memory-to-Writeback stage registers storing:
- Write-back control signals
- Data to be written

### Control and Datapath

#### `Decoder.v`
Instruction decoder generating:
- ALU operation control
- Memory access signals
- Register write enable
- Immediate format selection
- Branch/jump control

#### `PC_Logic.v`
Branch condition evaluation based on:
- Instruction type (BEQ, BNE, BLT, BGE, BLTU, BGEU)
- ALU flags (equality, signed/unsigned comparison)

#### `ALU.v`
32-bit ALU supporting:
- Arithmetic operations (ADD, SUB)
- Logical operations (AND, OR, XOR)
- Shifts (SLL, SRL, SRA)
- Comparisons (SLT, SLTU)

#### `Shifter.v`
Barrel shifter for:
- Logical left shift (SLL)
- Logical right shift (SRL)
- Arithmetic right shift (SRA)

#### `Extend.v`
Immediate extension for different instruction formats:
- U-type (LUI, AUIPC)
- I-type (immediate operations, loads)
- S-type (stores)
- B-type (branches)
- J-type (JAL)

### Hazard Handling

#### `HazardUnit.v`
Comprehensive hazard detection and forwarding control:
- **Data Forwarding Paths**:
  - `ForwardAE`, `ForwardBE`: EX stage operand forwarding
  - `Forward1D`, `Forward2D`: WB-to-Decode forwarding
  - `ForwardM`: Memory stage data forwarding
- **Stall Signals**:
  - `StallF`, `StallD`: Pipeline stalling for load-use hazards
- **Flush Signals**:
  - `FlushD`, `FlushE`: Pipeline flushing for control hazards

### Branch Prediction

#### `BranchPredictorUnit.v`
Dynamic branch prediction with:
- **Branch History Table (BHT)**: 2-bit saturating counters
  - 00: Strongly not taken
  - 01: Weakly not taken
  - 10: Weakly taken
  - 11: Strongly taken
- **Branch Target Buffer (BTB)**: Stores predicted target addresses
- **Prediction Logic**:
  - Fetch stage: Provides prediction for PC calculation
  - Execute stage: Updates BHT/BTB based on actual outcome
- **Misprediction Handling**: Flushes incorrect instructions and corrects PC

### Multi-Cycle Operations

#### `MCycle.v`
Hardware multiplier/divider supporting:
- **Multiplication**:
  - Booth's algorithm for signed multiplication
  - Shift-add for unsigned multiplication
- **Division**:
  - Restoring division for signed/unsigned division
- **Busy Signal**: Stalls pipeline during multi-cycle operations

### System Integration

#### `Wrapper.v`
Memory and I/O interface providing:
- Instruction ROM (IROM)
- Data memory (DMEM)
- Memory-mapped I/O address decoding
- UART, OLED, accelerometer interfaces

#### `TOP_Nexys.vhd` (VHDL)
Top-level synthesis module for Nexys 4 FPGA:
- Clock divider
- 7-segment display controller
- UART instantiation
- OLED and accelerometer controllers

## Memory Map

| Address Range | Device | Description |
|--------------|---------|-------------|
| `0x00400000 - 0x004001FF` | IROM | Instruction memory (512 bytes default) |
| `0x10010000 - 0x100101FF` | DMEM | Data memory (512 bytes default) |
| `0xFFFF0000 - 0xFFFF00FF` | MMIO | Memory-mapped I/O |

### MMIO Register Offsets

| Offset | Register | Access | Description |
|--------|----------|--------|-------------|
| `0x00` | UART_RX_VALID | RO | UART receive data valid |
| `0x04` | UART_RX | RO | UART receive data |
| `0x08` | UART_TX_READY | RO | UART transmit ready |
| `0x0C` | UART_TX | WO | UART transmit data |
| `0x20-0x2C` | OLED | WO | OLED control registers |
| `0x40-0x44` | ACCEL | RO | Accelerometer data |
| `0x60` | LED | WO | LED output |
| `0x64` | DIP | RO | DIP switch input |
| `0x68` | PB | RO | Push button input |
| `0x80` | SEVENSEG | WO | 7-segment display |
| `0xA0` | CYCLECOUNT | RO | Cycle counter |

## Pipeline Stages

### 1. Fetch (F)
- Fetches instruction from IROM
- Uses branch predictor for PC calculation
- Stores instruction and PC in Decode stage register

### 2. Decode (D)
- Decodes instruction opcode and operands
- Reads register file
- Generates control signals
- Extends immediate values
- Detects hazards with Execute/Memory/Writeback stages

### 3. Execute (E)
- Performs ALU operations
- Evaluates branch conditions
- Calculates memory addresses
- Detects branch mispredictions
- Initiates multi-cycle operations
- Forwards data from later stages

### 4. Memory (M)
- Accesses data memory or MMIO
- Forwards ALU results
- Handles memory-to-memory copies

### 5. Writeback (W)
- Writes results back to register file
- Selects between ALU result and memory data

## Hazard Handling Details

### Data Hazards
1. **EX-to-EX Forwarding**: Forwards ALU result from Memory stage
2. **MEM-to-EX Forwarding**: Forwards data from Writeback stage
3. **WB-to-Decode Forwarding**: Bypasses register file read latency
4. **Load-Use Stall**: Detects and stalls when load result is immediately used

### Control Hazards
1. **Branch Prediction**: Predicts branch outcome to avoid stalls
2. **Misprediction Recovery**: Flushes incorrect instructions and corrects PC
3. **Jump Handling**: Handles JAL and JALR with correct target calculation

## Branch Prediction Strategy

The processor uses a **2-bit saturating counter** scheme:
```
State Transitions:
00 (Strongly NT) → 01 (Weakly NT) → 10 (Weakly T) → 11 (Strongly T)
                ←                  ←               ←

Prediction: Taken if counter >= 10 (2)
```

- **BHT Size**: Configurable (default 4096 entries = 12-bit index)
- **Index**: Uses PC[BHT_SIZE+1:2] (word-aligned PC)
- **Update**: Increments on taken, decrements on not taken
- **BTB**: Stores predicted target addresses

## Sample Program

The included `countdown.asm` demonstrates:
- Basic arithmetic operations
- Data forwarding scenarios
- Load-use hazards
- Memory-to-memory copy
- Loop with branch prediction
- JAL/JALR instructions
- 7-segment countdown display
- MMIO access

## Building and Simulation

### Requirements
- Xilinx Vivado (for synthesis and FPGA deployment)
- RARS (RISC-V Assembler and Runtime Simulator) for assembly
- Target: Nexys 4 DDR (Artix-7 FPGA)

### Assembly Programming
1. Write RISC-V assembly in RARS
2. Assemble and export memory dumps:
   - `AA_IROM.mem` (instruction memory)
   - `AA_DMEM.mem` (data memory)
3. Add `.mem` files to Vivado project as design sources

### Simulation
1. Use the provided testbench (not included in files shown)
2. Verify pipeline behavior, hazard handling, and branch prediction
3. Monitor waveforms for PC, instructions, and control signals

### Synthesis
1. Set `TOP_Nexys.vhd` as top module
2. Configure clock divider: `CLK_DIV_BITS = 0` (100MHz) or `26` (~1Hz)
3. Generate bitstream
4. Program Nexys 4 board

## Performance Characteristics

- **CPI (Cycles Per Instruction)**: ~1 with perfect branch prediction
- **Branch Misprediction Penalty**: 2 cycles 
- **Load-Use Penalty**: 1 cycle stall
- **Multi-Cycle Operations**: 
  - Multiplication: 32 cycles
  - Division: 33 cycles

## Authors

- Developed as part of CG3207 Computer Architecture course
- Based on framework by Rajesh Panicker (NUS)
- Multi-cycle unit by Shahzor Ahmad and Rajesh Panicker
