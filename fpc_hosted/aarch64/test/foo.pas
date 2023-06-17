{$nomain}
var j: integer;
procedure p(i: integer);
begin
  i := i + 3;
  i := i + 4095;
  i := i + (4096 * 4095);
  i := i + (4096 * 4096);
  i := i + 100000;
  i := i and 255;
end;

