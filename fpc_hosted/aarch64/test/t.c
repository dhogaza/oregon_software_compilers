#include<stdio.h>

struct foo {int i,j; } bar = {10,20};
int d;

char g(int i0, int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8);

float r(float f0)
{
  d = d & 0xFFF;
  return f0 + 1.0;
}

int f(int i0,int i1,int i2,int i3,int i4,int i5,int i6,int i7,int i8,int i9,int i10)
{
}

int main()
{
//  printf("%d", f(t0, t1,t2,t3,t4,t5,t6,t7,t8,t9,t10));
//  printf("%d", f(0,1,2,3,4,5,g(10,20,30,40,50,60,70,80,90),7,8, 9, 10));
printf("%f", r(3.14159));
}
