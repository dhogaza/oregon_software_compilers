program test8;

var i, j: integer;

begin
  i := 1;
  while i < 3 do
  begin j := j + i;
  end;
  repeat
    i := i - 1;
  until i = 0;
  i := j + 3 + i;
end.
