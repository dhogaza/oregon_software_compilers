{$case}
program foo;
var a: integer;
  b: array [1..10] of integer;

procedure P(i:integer); nonpascal;

procedure pp(i,k:integer; var l:integer);
begin
  l := k;
  k := k + 1;
  a := a + 1;
  a := k * 3;
  P(l);
  a := k + 1;
  P(k + 1);
  a := k + 1;
  i := 7;
end;

begin pp(a, a, a); end.
