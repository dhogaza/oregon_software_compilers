<<<<<<< HEAD
{$case}
program foo;
var a: integer;
  b: array [1..10] of integer;

procedure P(i:integer); nonpascal;
procedure pp(j, k:integer; var l:integer);
  var i: integer;
  procedure ppp;
    begin
      j:= 3;
    end;

begin
  if a = 3 then
    begin
    l := k;
    k := k + 1;
    a := a + 1;
    a := k * 3;
    P(l);
    a := k + 1;
    P(k + 1);
    k := k + 1;
    a := k + 1;
    i := 7;
    end
  else
    begin
    l := k;
    k := k + 1;
    a := a + 1;
    a := k * 3;
    P(l);
    a := k + 1;
    P(k + 1);
    k := k + 1;
    a := k + 1;
    i := 7;
    end;
  l := k;
  k := k + 1;
end;

begin pp(a, a, a); end.
