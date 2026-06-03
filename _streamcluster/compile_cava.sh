#!/bin/bash

# Do not automatically vectorize, instead use the intrinsics
FLAGS="-march=rv64gv \
-DUSE_RISCV_VECTOR \
-g -static -O2 \
-fno-tree-vectorize \
-fno-tree-slp-vectorize"

# Cava requires an old GCC version. Newer ones will cause a segmentation fault 
COMP="/opt/riscv-gcc-13.2.0/bin/riscv64-unknown-linux-gnu-g++"

$COMP $FLAGS -c -o src/streamcluster.o src/streamcluster.cpp
$COMP $FLAGS -o bin/streamcluster_cava.out src/*.o -lm
