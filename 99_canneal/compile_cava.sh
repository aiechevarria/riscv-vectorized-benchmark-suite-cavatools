#!/bin/bash

# Do not automatically vectorize, instead use the intrinsics
FLAGS="-march=rv64gv \
-DUSE_RISCV_VECTOR \
-g -static -O0 \
-fno-tree-vectorize \
-fno-tree-slp-vectorize"

# Cava requires an old GCC version. Newer ones will cause a segmentation fault 
COMP="/opt/riscv-gcc-13.2.0/bin/riscv64-unknown-linux-gnu-g++"
# COMP="/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++"

$COMP $FLAGS -c -o src/annealer_thread.o src/annealer_thread.cpp
$COMP $FLAGS -c -o src/main.o src/main.cpp
$COMP $FLAGS -c -o src/netlist.o src/netlist.cpp
$COMP $FLAGS -c -o src/netlist_elem.o src/netlist_elem.cpp
$COMP $FLAGS -c -o src/rng.o src/rng.cpp
$COMP $FLAGS -o bin/canneal_cava.out src/*.o -lm
