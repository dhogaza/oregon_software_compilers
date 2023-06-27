program foo;
var i,j: integer;
  a: array [0..10] of integer;
procedure foo; external;

function p(k,l: integer): integer;
begin
  i := j + 3;
  i := i + 1;
  p := 3;
end;

procedure p2;
begin
  while j < 3 do
    begin
    foo;
    i:= i + i + p(p(1,2),3);
    end;
  i:=p(3,p(1,2));
end;

procedure p3;
begin
  while j < i do
    begin
    a[j] := i;
      j := j + 1;
      foo;
      i := j;
    end;
end;

procedure p4;
begin
  while j < i do
    begin
    a[j] := i;
      j := j + 1;
      i := j;
    end;
end;

begin end.
