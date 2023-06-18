{$nomain}
var j,k: integer;
procedure p(i: integer);
begin
  i := i + 4095;
  i := i + (4096 * 4095);
  i := i + (4096 * 4096);
  i := i + 100000;
  if j < k then i := 4;
  if j > k then i := 3;
  if j < 3 then i := 4;
  if j > -1 then i := 3;
  if j < 4096 then i := 10;
  if j < 4097 then i := 20;
end;

