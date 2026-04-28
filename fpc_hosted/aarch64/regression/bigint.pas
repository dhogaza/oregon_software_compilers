%include 'testlib'

var a: integer;

procedure bar;

var i,j,k,l: integer;

begin
  i := 65536;
  j := i + 4095;
  k := a + 4095;
  l := k + 4096;
  putstring('i: '); putintln(i);
  putstring('j: '); putintln(j);
  putstring('k: '); putintln(k);
  putstring('l: '); putintln(l);
  putstring('a: '); putintln(a);
end;


procedure foo;

var i,j,k,l: integer;

  { defeat constant propagation and print the actual vars }
  procedure foo2;

  begin
    putstring('i: '); putintln(i);
    putstring('j: '); putintln(j);
    putstring('k: '); putintln(k);
    putstring('l: '); putintln(l);
    putstring('a: '); putintln(a);
  end;

begin
  i := 65536;
  j := i + 4095;
  k := a + 4095;
  l := k + 4096;
  foo2;
end;

begin
  a := 1;
  bar;
  foo;
 end.
