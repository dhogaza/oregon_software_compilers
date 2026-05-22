program p;

const max=99;

type smallarray = array [1..max, 1..max] of integer;

var a: smallarray;


procedure fill(var a: smallarray);

var i, j: integer;

begin
  for i := 1 to max do
    for j := 1 to max do
      a[i,j] := i * (max + 1) + j;
end;

procedure verify(var a: smallarray);

var i, j, fails: integer;

begin
  fails := 0;
  for i := 1 to max do
    for j := 1 to max do
      if a[i,j] <> i * (max + 1) + j then
        begin
        fails := fails + 1;
        writeln(i:1,' ',j:1,' ',a[i,j]:1);
        end;
  writeln('fails: ',fails:1);
end;

begin
  fill(a);
  verify(a);
end.
