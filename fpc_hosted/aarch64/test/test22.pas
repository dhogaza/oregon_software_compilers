program main;
var i, j: integer;
  b: boolean;
{
function f(i,j: integer):integer;
begin
  if i < j then f := i
  else f := j;
end;
}

procedure p1(i,j: integer);
  var k: integer;
begin
  if i < j then i := i
  else j := j;
  k := i;
end;

procedure p2(i,j: integer);
  var k: integer;
begin
  if i < j then i := j
  else j := i;
  k := i;
end;
begin end.
