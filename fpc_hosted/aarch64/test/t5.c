struct s {long long  w, x, y, z;} ss;
struct s f()
{
  struct s sss;
  sss.x = 3;
  return sss;
}
 
int main()
{
  ss =  f();
  return ss.w;
}
