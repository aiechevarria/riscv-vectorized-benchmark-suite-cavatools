#!/bin/bash

/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/streamcluster.o src/streamcluster.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -o bin/streamclusterinit_cava.out src/*.o -lm
