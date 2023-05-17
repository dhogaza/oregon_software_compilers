{$case}
program foo;
var a: integer;
  b: array [1..10] of integer;

procedure P(i:integer); nonpascal;
procedure pp(k:integer; var l:integer);
begin
  l := k;
  k := k + 1;
  a := a + 1;
  a := k * 3;
  P(k);
  a := k + 2;
end;

begin pp(a, a); end.

