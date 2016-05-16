#include <stdio.h>
#include <stdlib.h>

#define n 4

__device__
void dekomposisi(double A[][n], double D[][n]) {
    int i, j, k, p, q, stop = 0;
    double sum = 0;

    for (p = 0; p < n; p++) {
        for (j = p; j < n; j++) {
            sum = 0;
            for (k = 0; k < p; k++) {
                sum += D[p][k] * D[k][j];
            }
            D[p][j] = A[p][j] - sum;
        }

        q = p;
        for (i = q + 1; i < n; i++) {
            sum = 0;
            for(k = 0; k < q; k++) {
                sum += D[i][k] * D[k][q];
            }
            if (D[q][q] == 0) {
                printf("U[%d][%d] == 0\n Tidak bisa dibagi 0...\n", q, q);
                stop = 1;
            } else {
                D[i][q] = (A[i][q] - sum) / D[q][q];
            }

            if (stop) {
                break;
            }
        }

        if (stop) {
            break;
        }
    }
}

__device__
void sulih(double D[][n], double b[n], double x[n], double *y) {
    int i, j;
    double sum;

    for (i = 0; i < n; i++) {
        sum = 0;
        for (j = 0; j < i; j++) {
            sum += y[j] * D[i][j];
        }
        y[i] = b[i] - sum;
    }

    for (i = n-1; i >= 0; i--) {
        sum = 0;
        for (j = i+1; j < n; j++) {
            sum += x[j] * D[i][j];
        }
        x[i] = (y[i] - sum) / D[i][i];
    }

    free(y);
}

__device__
void print_LU(double D[][n]) {
    int i, j;
    printf("Dekomposisi\n");

    printf("L =\n");
    for (i = 0; i < n; i++) {
        printf("\t");
        for (j = 0; j < i; j++) {
            printf("%8.4f  ", D[i][j]);
        }
        printf("%8d\n", 1);
    }

    printf("U =\n");
    for (i = 0; i < n; i++) {
        printf("\t");
        for (j = 0; j < i; j++) {
            printf("%8s  ", "");
        }
        for (j = i; j < n; j++) {
            printf("%8.4f  ", D[i][j]);
        }
        printf("\n");
    }
}

__device__
void print_x(double x[n]) {
    int i;
    printf("Solusi\n");

    printf("x =\n");
    for (i = 0; i < n; i++) {
        printf("\t%8.4f\n", x[i]);
    }
}

__global__
void crout(double *y) {
    double A[][n] = {
        {0.31, 0.14, 0.30, 0.27},
        {0.26, 0.32, 0.18, 0.24},
        {0.61, 0.22, 0.20, 0.31},
        {0.40, 0.34, 0.36, 0.17},

        // {0.7071, 0,  1,  0,     0.5,  0,  0,  0,       0},
        // {0,      1,  0,  0,       0, -1,  0,  0,       0},
        // {0,      0, -1,  0,       0,  0,  0,  0,       0},
        // {0,      0,  0,  1,       0,  0,  0,  0, -0.7071},
        // {0.7071, 0,  0, -1, -0.8660,  0,  0,  0,       0},
        // {0,      0,  0,  0,       0,  0,  1,  0,  0.7071},
        // {0,      0,  0,  0,    -0.5,  0, -1,  0,       0},
        // {0,      0,  0,  0,  0.8660,  1,  0, -1,       0},
        // {0,      0,  0,  0,       0,  0,  0,  0,  0.7071},

        // { 0.866,  0,   -0.5,  0,  0,  0},
        // {     0,  1,    0.5,  0,  0,  0},
        // {   0.5,  0,  0.866,  0,  0,  0},
        // {-0.866, -1,      0, -1,  0,  0},
        // {  -0.5,  0,      0,  0, -1,  0},
        // {     0,  0, -0.866,  0,  0, -1},
    };
    double b[n] = {
        1.02,
        1.00,
        1.34,
        1.27,

        // -1000,
        // 0,
        // 0,
        // 0,
        // 0,
        // 500,
        // -500,
        // 0,
        // 0,

        // 0,
        // 0,
        // -1000,
        // 0,
        // 0,
        // 0,
    };

    double D[][n] = {
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
    };
    double x[n] = {
        0,
        0,
        0,
        0,
    };

    dekomposisi(A, D);
    print_LU(D);
    sulih(D, b, x, y);
    print_x(x);
}

int main(int argc, char *argv[] ) {
    double *y;
    cudaMalloc(&y, n*sizeof(double));
    crout<<<1, 1>>>(y);
    cudaDeviceSynchronize();
    return 0;
}
