#include <stdlib.h>

void *_p_malloc(size_t size) {
  void **p, **p1;
  p = (void **) malloc(size + sizeof(p));
  p1 = p + 1;
  *p = p1;  
  return p1;
}

void _p_free(void *p) {
  void **p1;
  p1 = (void **) p - 1;
  *p1 = NULL;
  free((void *) p1);
}
