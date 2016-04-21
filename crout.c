#include <stdio.h>
#include <stdlib.h>

#define n 3

void crout(double A[][n], double D[][n]) {
    int i, j, k, p, q;
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
                printf("U[q][q] == 0\n Tidak bisa dibagi 0...\n");
                exit(EXIT_FAILURE);
            }
            D[i][q] = (A[i][q] - sum) / D[q][q];
        }
    }
}

void sulih(double D[][n], double b[n], double x[n]) {
    int i, j;
    double sum;
    double *y = malloc(n*sizeof(double));

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

void print_x(double x[n]) {
    int i;
    printf("Solusi\n");

    printf("x =\n");
    for (i = 0; i < n; i++) {
        printf("\t%8.4f\n", x[i]);
    }
}

int main(int argc, char *argv[] ) {
    double A[][n] = {{1, 1, -1}, {-1, 1, 1}, {2, 2, 1}};
    double b[n] = {1, 1, 5};

    double D[][n] = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
    double x[n] = {0, 0, 0};

    crout(A, D);
    print_LU(D);
    sulih(D, b, x);
    print_x(x);
}
