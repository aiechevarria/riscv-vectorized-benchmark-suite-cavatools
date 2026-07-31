/*************************************************************************
* Vectorized matrixmul Kernel
*************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>
#include <stdbool.h>

#define ROI_START() asm volatile("li a7, 0x777; ecall" ::: "a7")
#define ROI_END()  asm volatile("li a7, 0x778; ecall" ::: "a7")

#define DATA_TYPE 
typedef double data_t;

#define BLOCK_SIZE 8

#ifdef USE_RISCV_VECTOR
#include <riscv_vector.h>
#include "../../common/vector_defines.h"

/**
 * Matmul kernel.
 * @param a A matrix (m x p)
 * @param b B matrix (p x n)
 * @param c Result matrix (m x n)
 * @param n Number of columns of matrix B and output matrix C
 * @param m Number of rows of matrix A and output matrix C
 * @param p Number of columns of matrix A and rows of matrix B (inner dimension)
 */

void matrixmul_intrinsics(data_t *a, data_t *b, data_t *c, int n, int m, int p) {
    ROI_START();

    // 1. Loop over row blocks of matrix A and C (step by 8 rows)
    for (size_t i0 = 0; i0 < m; i0 += BLOCK_SIZE) {
        size_t i_len = (i0 + BLOCK_SIZE <= m) ? BLOCK_SIZE : (m - i0);

        // 2. Loop over column blocks of matrix B and C (step by 8 columns)
        for (size_t j0 = 0; j0 < n; j0 += BLOCK_SIZE) {
            size_t j_len = (j0 + BLOCK_SIZE <= n) ? BLOCK_SIZE : (n - j0);

            // Strip-mining loop along column dimension j using RVV hardware vector length (gvl)
            size_t j = j0;
            size_t rem_j = j_len;

            while (rem_j > 0) {
                // Set active vector length for remaining double-precision float elements (64-bit, SEW=e64, LMUL=m1)
                size_t gvl = _MMR_VSETVL_E64M1(rem_j);

                // Initialize 8 RVV vector accumulator registers to 0.0 for the 8 rows in the tile
                _MMR_f64 vc0 = _MM_SET_f64(0.0, gvl);
                _MMR_f64 vc1 = _MM_SET_f64(0.0, gvl);
                _MMR_f64 vc2 = _MM_SET_f64(0.0, gvl);
                _MMR_f64 vc3 = _MM_SET_f64(0.0, gvl);
                _MMR_f64 vc4 = _MM_SET_f64(0.0, gvl);
                _MMR_f64 vc5 = _MM_SET_f64(0.0, gvl);
                _MMR_f64 vc6 = _MM_SET_f64(0.0, gvl);
                _MMR_f64 vc7 = _MM_SET_f64(0.0, gvl);

                // 3. Loop over inner dimension k blocks (depth dimension p, step by 8)
                for (size_t k0 = 0; k0 < p; k0 += BLOCK_SIZE) {
                    size_t k_len = (k0 + BLOCK_SIZE <= p) ? BLOCK_SIZE : (p - k0);

                    // Iterate over elements within the depth block k
                    for (size_t k = k0; k < k0 + k_len; k++) {
                        // Load contiguous vector elements from row k of matrix B: B[k, j .. j + gvl - 1]
                        _MMR_f64 vb = _MM_LOAD_f64(&b[k * n + j], gvl);

                        // Multiply scalar element A[i, k] with vector B[k, j..] and accumulate:
                        // vc_r = vc_r + A[i0 + r, k] * vb
                        if (i_len > 0) vc0 = _MM_MACC_VF_f64(vc0, a[(i0 + 0) * p + k], vb, gvl);
                        if (i_len > 1) vc1 = _MM_MACC_VF_f64(vc1, a[(i0 + 1) * p + k], vb, gvl);
                        if (i_len > 2) vc2 = _MM_MACC_VF_f64(vc2, a[(i0 + 2) * p + k], vb, gvl);
                        if (i_len > 3) vc3 = _MM_MACC_VF_f64(vc3, a[(i0 + 3) * p + k], vb, gvl);
                        if (i_len > 4) vc4 = _MM_MACC_VF_f64(vc4, a[(i0 + 4) * p + k], vb, gvl);
                        if (i_len > 5) vc5 = _MM_MACC_VF_f64(vc5, a[(i0 + 5) * p + k], vb, gvl);
                        if (i_len > 6) vc6 = _MM_MACC_VF_f64(vc6, a[(i0 + 6) * p + k], vb, gvl);
                        if (i_len > 7) vc7 = _MM_MACC_VF_f64(vc7, a[(i0 + 7) * p + k], vb, gvl);
                    }
                }

                // 4. Store accumulated RVV vector register results back to matrix C: C[i, j .. j + gvl - 1]
                if (i_len > 0) _MM_STORE_f64(&c[(i0 + 0) * n + j], vc0, gvl);
                if (i_len > 1) _MM_STORE_f64(&c[(i0 + 1) * n + j], vc1, gvl);
                if (i_len > 2) _MM_STORE_f64(&c[(i0 + 2) * n + j], vc2, gvl);
                if (i_len > 3) _MM_STORE_f64(&c[(i0 + 3) * n + j], vc3, gvl);
                if (i_len > 4) _MM_STORE_f64(&c[(i0 + 4) * n + j], vc4, gvl);
                if (i_len > 5) _MM_STORE_f64(&c[(i0 + 5) * n + j], vc5, gvl);
                if (i_len > 6) _MM_STORE_f64(&c[(i0 + 6) * n + j], vc6, gvl);
                if (i_len > 7) _MM_STORE_f64(&c[(i0 + 7) * n + j], vc7, gvl);

                j += gvl;
                rem_j -= gvl;
            }
        }
    }

    ROI_END();
}


#else // !USE_RISCV_VECTOR

/**
 * Serial Blocked (Tiled) Matrix Multiplication Kernel (C = A * B).
 * Uses 8x8 tiling to fit block sub-matrices in CPU data cache.
 * 
 * @param a Pointer to input matrix A of size (m x p)
 * @param b Pointer to input matrix B of size (p x n)
 * @param c Pointer to output matrix C of size (m x n)
 * @param n Number of columns in matrix B and output matrix C
 * @param m Number of rows in matrix A and output matrix C
 * @param p Number of columns in matrix A and rows in matrix B (inner dimension)
 */
void matmul_serial(data_t *a, data_t *b, data_t *c, int n, int m, int p) {
    // Limit row in A
    for (int i0 = 0; i0 < m; i0 += BLOCK_SIZE) {
        // Compute the largest possible row index
        int i_max = (i0 + BLOCK_SIZE < m) ? i0 + BLOCK_SIZE : m;

        // Limit column in B
        for (int j0 = 0; j0 < n; j0 += BLOCK_SIZE) {
            // Compute the largest possible column index
            int j_max = (j0 + BLOCK_SIZE < n) ? j0 + BLOCK_SIZE : n;

            // Limit column in A and row in B 
            for (int k0 = 0; k0 < p; k0 += BLOCK_SIZE) {
                int k_max = (k0 + BLOCK_SIZE < p) ? k0 + BLOCK_SIZE : p;

                // Perform the computation
                for (int i = i0; i < i_max; ++i) {
                    for (int k = k0; k < k_max; ++k) {
                        data_t a_val = a[i * p + k];
                        // Iterate over j (n) first to process an entire column of B with a single A value.  
                        // Then move on to the next A value until the block is finished
                        for (int j = j0; j < j_max; ++j) {
                            c[i * n + j] += a_val * b[k * n + j];
                        }
                    }
                }
            }
        }
    }
}

#endif


bool compare( size_t dm, size_t dn, data_t *a ,data_t *b) {
    bool result = false;
    for (int i = 0; i < dm; i++) {
        for (int j = 0; j < dn; j++) {
            if(a[i*dn+j] != b[i*dn+j]) {
              result = true;
            }
        }
 
    }
    return result;
}
