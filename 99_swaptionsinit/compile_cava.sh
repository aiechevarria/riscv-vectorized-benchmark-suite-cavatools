#!/bin/bash

/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/CumNormalInv.o src/CumNormalInv.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/MaxFunction.o src/MaxFunction.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/RanUnif.o src/RanUnif.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/nr_routines.o src/nr_routines.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/icdf.o src/icdf.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/HJM_SimPath_Forward_Blocking.o src/HJM_SimPath_Forward_Blocking.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/HJM.o src/HJM.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/HJM_Swaption_Blocking.o src/HJM_Swaption_Blocking.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -c -o src/HJM_Securities.o src/HJM_Securities.cpp
/opt/riscv-gcc-new/bin/riscv64-unknown-linux-gnu-g++ -march=rv64gv -DUSE_RISCV_VECTOR -g -static -O2 -o bin/swaptionsinit_cava.out src/*.o -lm