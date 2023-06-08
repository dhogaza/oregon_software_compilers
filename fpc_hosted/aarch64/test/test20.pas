program main;
var i, j: integer;
  b: boolean;

function f(i,j: integer):integer;
begin
  if i < j then f := i
  else f := j;
end;
begin end.
