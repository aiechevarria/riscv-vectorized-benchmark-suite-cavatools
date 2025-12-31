#!/bin/bash

/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/particlefilter.o src/particlefilter.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -o bin/particlefilter_cava.out src/*.o -lm
