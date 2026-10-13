{$check}

procedure p(j: integer);
var i: 1..10;

begin
    for i := -1 to j do writeln;
end;

procedure p1(j: integer);
var i: 1..10;

begin
    for i := j to 11 do writeln;
end;

begin
  writeln('i: 1..10');
  writeln('for i := -1 to -2 is not an error');
  p(-2);
  writeln('for i := 12 to 11 is not an error');
  p1(12);
  writeln('for i := -1 to -1 is an error!');
  p(-1);
end.
