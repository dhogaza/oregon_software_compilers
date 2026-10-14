{$check}
procedure p(j,k: integer);
var i: 1..10;
  b: boolean;

begin
  b := false;
  for i := j to k do
    begin
    b := true;
    write(i:1, ' ');
    end;
  if b then writeln;
end;

begin
  writeln('Test for statement range checking when start and end are variables');
  writeln('var i: 1..10');
  writeln('for 21 to 11 is not an error, as it never executes');
  p(21,11);
  writeln('for 1 to 10 is not an error');
  p(1,10);
  writeln('for 10 to 1 is not an error');
  p(10,1);
  writeln('for 1 to 11 is a range error');
  p(1, 11);
end.
