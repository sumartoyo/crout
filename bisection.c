#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define err 0.00001

float f(float x)
{
	return exp(x)-5*pow(x,2); // slide
	// return ((x * pow(2.1-0.5*x, 1/2)) / pow((1-x)*(1.1-0.5*x), 1/2)) - 3.69; // 1.a
	// return tan(x) - x + 1; // 1.b
	// return 0.5*exp(x/3) - sin(x); // 1.c
}

int main(int argc,char **argv)
{
	float x0,x1,x2;

	x0 = 0; x1 = 1; // slide
	// x0 = 0; x1 = 1; // 1.a
	// x0 = 0; x1 = 3*M_PI; // 1.b
	// x0 = 0; x1 = 1; // 1.c

	printf("%10s %10s %10s %10s %10s %10s\n",
		"x0", "x1", "f(x0)", "f(x1)", "x2", "f(x2)");
	do
	{
		x2=(x0+x1)/2;
		printf("%10.5f %10.5f %10.5f %10.5f %10.5f %10.5f\n",
			x0,x1,f(x0),f(x1),x2,f(x2));
		if(f(x0)*f(x2)<0) x1=x2;
		else x0=x2;
	}
	while(fabs(x0-x1)>err);

	printf("Hasil = %.5f\n",x2);
	return 0;
}

