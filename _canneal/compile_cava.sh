#!/bin/bash

/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/annealer_thread.o src/annealer_thread.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/main.o src/main.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/netlist.o src/netlist.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/netlist_elem.o src/netlist_elem.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/rng.o src/rng.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -o bin/canneal_cava.out src/*.o -lm
