program main;

procedure f;
var i,j: integer;

  procedure ff;
  begin i := 3; end;

begin
  j := 3;
  i := i * j;
  ff;
  i := i * j;
end;

begin end.

  
