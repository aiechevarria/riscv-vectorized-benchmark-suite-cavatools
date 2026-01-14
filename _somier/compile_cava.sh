#!/bin/bash

/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o utils.o utils.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o somier.o omp/somier.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o forces_prevec_lmul1.o intrinsics/forces_prevec_lmul1.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o somier_intr_lmul1.o intrinsics/somier_intr_lmul1.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o main.o main.c
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-gcc -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -o bin/somier_cava.out *.o -lm
