#!/bin/bash

/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -static -O2 -c -o src/axpy.o src/axpy.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -static -c -o src/main.o src/main.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -static -O2 -c -o src/utils.o src/utils.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -static -O2 -o bin/axpy_cava.out src/*.o -lm