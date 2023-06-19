program foo;
var i: integer;
  b: boolean;

function f(i:integer):integer;
begin
  f := i;
end;

function f2(i: integer; b: boolean): boolean;
begin
  i := not i;
  f2 := not (not b) and (i = 3);
end;

begin
  i := 3;
  b := f2(i, i < f(4));
end.
