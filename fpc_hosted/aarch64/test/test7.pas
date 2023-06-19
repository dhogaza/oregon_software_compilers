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

function f3: boolean;
begin
  f3 := true;
end;

begin
  b := f2(f(3), 8 < f(4));
{
  b := f2(1, f3);
  b := f2(f(3), true);
}
end.
