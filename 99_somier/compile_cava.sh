#!/bin/bash

# Do not automatically vectorize, instead use the intrinsics
FLAGS="-march=rv64gv \
-DUSE_RISCV_VECTOR \
-g -static -O2 \
-fno-tree-vectorize \
-fno-tree-slp-vectorize"

# Cava requires an old GCC version. Newer ones will cause a segmentation fault 
COMP="/opt/riscv-gcc-13.2.0/bin/riscv64-unknown-linux-gnu-g++"

$COMP $FLAGS -c -o utils.o utils.c
$COMP $FLAGS -c -o somier.o omp/somier.c
$COMP $FLAGS -c -o forces_prevec_lmul1.o intrinsics/forces_prevec_lmul1.c
$COMP $FLAGS -c -o somier_intr_lmul1.o intrinsics/somier_intr_lmul1.c
$COMP $FLAGS -c -o main.o main.c
$COMP $FLAGS -o bin/somier_cava.out *.o -lm
