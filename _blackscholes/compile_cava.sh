#!/bin/bash

/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/blackscholes.o src/blackscholes.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -o bin/blackscholes_cava.out src/*.o -lm
