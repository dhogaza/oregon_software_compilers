program main;

var i, j, k:integer;

procedure pext; external;
procedure p;

begin
  if (i < j) and (j > k) then
    begin
    pext;
     k := i
    end
  else k := j;
end;

begin
end.
