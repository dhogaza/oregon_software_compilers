{$check}
procedure p1(j: integer);
var i: 1..10;
  b: boolean;

begin
  b := false;
  for i := 1 to j do
    begin
    b := true;
    write(i:1, ' ');
    end;
  if b then writeln;
end;


begin
  writeln('test for check where start is const, end is variable');
  writeln('var i:1..10');
  writeln('for 1 to -1 is not an error, never executes');
  p1(-1);
  writeln('for 1 to 10 is not an error');
  p1(10);
  writeln('for 1 to 11 is a range error');
  p1(11);
end.
