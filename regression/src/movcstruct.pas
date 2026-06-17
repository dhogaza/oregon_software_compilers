{ Test of one of the most bizarre features of standard Pascal,
  implemented only for completion and probably never used in real
  life even when Pascal was heavily used.
}

var a1, a2: array[1..3] of integer;
procedure p(a,b: array [i..j:integer] of integer);
  var c: integer;
begin
  write('a: ');
  for c := i to j do write(a[c]);
  writeln;
  write('b: ');
  for c := i to j do write(b[c]);
  writeln;
  a := b;
  write('after assignment a: ');
  for c := i to j do write(a[c]);
  writeln;
end;

begin
  a1[1] := 1; a1[2] := 2; a1[3] := 3;
  a2[1] := -1; a2[2] := -2; a2[3] := -3;
  p(a1,a2);
end.

