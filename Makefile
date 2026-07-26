# Toolchain definition
CC       := iverilog
SIM      := vvp
FLAGS    := -g2012

# Source files
TB_SRC   := RISCV32.srcs/sim_1/new/tb_core.v
RTL_SRCS := $(wildcard RISCV32.srcs/sources_1/new/*.v)
TARGET   := sim.out
VCD      := wave.vcd

.PHONY: all sim clean

# Default target: compile and run simulation
all: sim

# Compile Verilog source files
$(TARGET): $(TB_SRC) $(RTL_SRCS)
	$(CC) $(FLAGS) -o $(TARGET) $(TB_SRC) $(RTL_SRCS)

# Run simulation to generate waveform
sim: $(TARGET)
	$(SIM) $(TARGET)

# Clean build artifacts
clean:
	rm -f $(TARGET) $(VCD)