var
  ch: char;
{$own='packed'}
  dummyp: array [1..4088] of char;
  ap: packed array [char] of boolean;

procedure foo;
begin
  writeln(ap[chr(64)], ap[chr(65)]:7);
end;

begin
  for ch := chr(0) to chr(255) do ap[ch] := false;
  write('expect false false: ');
  foo;
  dummyp[1] := chr(255);
  write('expect false false: ');
  foo;
  dummyp[1] := chr(0);
  write('expect false false: ');
  foo;
end.
