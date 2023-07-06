#include <stdio.h>

#define  SIZE 1000000
#define  ITERMAX 1000

int flags[SIZE + 1];

int i, prime, k, count, iter;

int main() {

  for (iter = 0; iter < ITERMAX; iter++) {
    count = 0;
    for (i = 0; i <= SIZE; i++) { 
       flags[i] = 1;
    }
    for (i = 0;  i <= SIZE; i++) {
      if (flags[i]) {
        prime = i + i + 3;
        k = i + prime;
        while (k <= SIZE) {
          flags[k] = 0;
          k = k + prime;
        }
        count = count + 1;
      }
    }
  }
  printf("count: %d\n", count);
  return 0;
}

