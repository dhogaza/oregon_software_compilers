program p;

%include 'testlib'

const max=19999;

type bigarray = array [1..max, 1..max] of integer;

var a: bigarray;

procedure fill(var a: bigarray);

var i, j: integer;

begin
  for i := 1 to max do
    for j := 1 to max do
      a[i,j] := i * (max + 1) + j;
end;

procedure verify(var a: bigarray);

var i, j, fails: integer;

begin
  fails := 0;
  for i := 1 to max do
    for j := 1 to max do
      if a[i,j] <> i * (max + 1) + j then
        begin
        fails := fails + 1;
        putint(i); putchar(' '); putint(j); putchar(' '); putintln(a[i,j]);
        end;
  putstring('fails: '); putintln(fails);
end;

begin
  fill(a);
  verify(a);
end.
