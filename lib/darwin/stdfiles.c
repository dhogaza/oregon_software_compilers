#include <stdio.h>

FILE *_p_inputstream() {
  return __stdinp;
}

FILE *_p_outputstream() {
  return __stdoutp;
}


FILE *_p_errorstream() {
  return __stderrp;
}

