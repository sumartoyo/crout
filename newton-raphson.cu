#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define err 0.000001

__device__
void f(float x, float *y)
{
    // *y = exp(x)-5*pow(x,2); // slide
    *y = ((70 + 1.463/pow(x, 2)) * (x - 0.0394)) - (0.08314 * 215);
}

__device__
void g(float x, float *y)
{
    // *y = exp(x)-10*x; // slide
    *y = 70 - 1.463 + 2*1.463*0.0394;
}

__global__
void newtraph()
{
    float x,xS,fx,gx,fS,gS;
    x = 1;

    printf("%11s %11s %11s %11s\n",
        "x", "f(x)", "f'(x)", "x");
    do
    {
        xS=x;
        f(x, &fx);
        g(x, &gx);
        f(xS, &fS);
        g(xS, &gS);
        x=x-fx/gx;
        printf("%11.6f %11.6f %11.6f %11.6f\n",
            xS,fS,gS,x);
    }
    while(fabs(x-xS)>err);
    printf("Hasil = %.6f\n",x);
}

int main(int argc,char **argv) {
    newtraph<<<1, 1>>>();
    cudaDeviceSynchronize();
    return 0;
}
