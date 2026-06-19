
type str=string[255];

procedure p(var i: integer);
begin
end;

procedure p1(const s,s1:str; i:integer; const j:integer);
var k:integer;
  pi: ^integer;
  cp: ^char;
begin
  s[1] := 'a';
  pi := ref(j);
  cp := ref(s[1]);
  j := 3;
  for j := 1 to 10 do;
  writeln(j);
  k := j;
  p(j);
end;

{$standard}
procedure p2(const i: integer);
begin
end;
{$nostandard}

begin
  p1('abc', 'xyz', 3, 4);
end.
