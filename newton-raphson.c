#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define err 0.000001

float f(float x)
{
	return exp(x)-5*pow(x,2); // slide
}

float g(float x)
{
	return exp(x)-10*x; // slide
}

int main(int argc,char **argv)
{
	float x,xS;
	x = 1;

	printf("%11s %11s %11s %11s\n",
		"x", "f(x)", "f'(x)", "x");
	do
	{
		xS=x;
		x=x-f(x)/g(x);
		printf("%11.6f %11.6f %11.6f %11.6f\n",
			xS,f(xS),g(xS),x);
	}
	while(fabs(x-xS)>err);
	printf("Hasil = %.6f\n",x);

	return 0;
}
