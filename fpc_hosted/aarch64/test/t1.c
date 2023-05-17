#include <stdio.h>
int foo();
int bar();

int main()
{
  printf("%d", foo()/bar(), foo() % bar());
}
