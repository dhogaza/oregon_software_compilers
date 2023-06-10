struct {
  long a;
} a, b;

struct {
  long a, b, c, d;
} c, d;

struct {
  long a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
} e, f;

struct {
  char a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
  char q, r, s, t, u, v, w, x, y, z;
} g, h;

struct {
  long a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
  long q, r, s, t, u, v, w, x, y, z;
  long aa, ab, ac, ad, ae, af, ag, ah, ai, aj, ak, al, am, an, ao, ap;
} i, k;

void foo() {
  a = b;
  c = d;
  e = f;
  g = h;
  i = k;
}
