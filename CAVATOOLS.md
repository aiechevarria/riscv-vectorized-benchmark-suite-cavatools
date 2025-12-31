# Cavatools
## Requirements
Complation has been tested as of late December 2025 with the latest GCC from the [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain/) (commit bd828e247419e665ea6c4f8c1bb7afa101afa427). 

Install the latest RISC-V GNU Toolchain version avaiable from https://github.com/riscv-collab/riscv-gnu-toolchain. Configure it with LLVM by running **./configure --prefix=/opt/riscv-gcc-new --enable-llvm --enable-linux make** and follow the rest of the README.md file in the toolchain's repository.

## Compilation
Each benchmark has a compile_cava.sh script that will execute each compilation automatically. The following flags are required at all times: 
```
-march=rv64gv -DUSE_RISCV_VECTOR -static
```