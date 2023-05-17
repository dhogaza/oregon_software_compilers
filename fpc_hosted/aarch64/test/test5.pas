program foo;
{type rec = record a,b,c,d: ^integer; end;
var r: rec;

procedure p(r1: rec);
begin
  r1.a := nil;
end;
}

function g(i:integer):integer;
begin
  g := 4;
end;

function f(i,j: integer):integer;
begin
  f:=3;
end;

{needs to copy r to the stack then push ptr sigh}
begin
  writeln(f(1,g(2)), 3);
{  p(r);}
end.

