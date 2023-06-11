program foo;

procedure bar(a, b, i: integer);
  var j, k: integer;
begin
  for j := 1 to 2 do k := j + i;
  for k := a to b do j := k;
end;

begin
  bar(1,2,3);
end.
