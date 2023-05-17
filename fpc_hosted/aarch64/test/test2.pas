program foo;

var i, j: integer;

{ gotta set instmarks (rename firstinst?) }
procedure bar;
var k: integer;
begin
  k :=  i + j;
  k := i - j;
  k := i * j;
  j := i div k;
  j := i mod k;
  k := i + j;
  j := 3;
end;

begin
end.
