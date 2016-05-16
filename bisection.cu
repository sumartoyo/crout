#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define err 0.00001

__device__
void f(float x, float *y)
{
    // *y = exp(x)-5*pow(x,2); // slide
    *y = (pow(x, 2)*(2.1-0.5*x)/(pow(1-x, 2)*(1.1-0.5*x)))-13.616; // 1.a
    // *y = tan(x) - x + 1; // 1.b
    // *y = 0.5*exp(x/3) - sin(x); // 1.c
}

__global__
void bisection()
{
    float x0,x1,x2,y0,y1,y2;

    // x0 = 0; x1 = 1; // slide
    x0 = -0.1; x1 = 1.1; // 1.a
    // x0 = 0; x1 = 3*M_PI; // 1.b
    // x0 = 0; x1 = 1; // 1.c

    printf("%10s %10s %10s %10s %10s %10s\n",
        "x0", "x1", "f(x0)", "f(x1)", "x2", "f(x2)");
    do
    {
        x2=(x0+x1)/2;
        f(x0, &y0);
        f(x1, &y1);
        f(x2, &y2);
        printf("%10.5f %10.5f %10.5f %10.5f %10.5f %10.5f\n",
            x0,x1,y0,y1,x2,y2);
        if(y0*y2<0) x1=x2;
        else x0=x2;
    }
    while(fabs(x0-x1)>err);

    printf("Hasil = %.5f\n",x2);
}

int main(int argc,char **argv) {
    bisection<<<1, 1>>>();
    cudaDeviceSynchronize();
    return 0;
}

