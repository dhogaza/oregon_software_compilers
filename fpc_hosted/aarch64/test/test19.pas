{$case}
program foo;
var a: integer;
  b: array [1..10] of integer;

procedure P(i:integer); nonpascal;
procedure pp(j, k:integer; var l:integer);
  var i: integer;

begin
  if a = 3 then
    begin
    k := k + 1;
    a := a + 1;
    a := k * 3;
    P(0);
    end;
  i := k;
end;

begin pp(a, a, a); end.

