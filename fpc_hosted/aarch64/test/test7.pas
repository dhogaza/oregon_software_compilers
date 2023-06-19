program foo;
var i: integer;
  b: boolean;

function f(i:integer):integer;
begin
  f := i;
end;

function f2(i: integer; b: boolean): boolean;
begin
  f2 := not b;
end;

begin
  i := 3;
  b := f2(i, i < f(4));
end.
