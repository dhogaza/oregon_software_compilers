program foo;

var a: array [1..10] of char;

procedure p(i: integer);
begin
  a[i] := 'a';
end;

begin
  p(3);
end.
