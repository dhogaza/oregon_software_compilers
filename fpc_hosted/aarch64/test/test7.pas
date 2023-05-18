program foo;
var i: integer;
  b: boolean;

function f(i:integer):integer;
begin
  f := i;
end;

begin
  b := i < f(4);
end.
