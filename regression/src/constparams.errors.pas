type str=string[255];
  intarray = array [1..10] of integer;

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

procedure p3(const a:array[i..j:integer] of integer);
begin end;
{$nostandard}

procedure p4(var aa:array [i..j:integer] of integer);
begin
end;

procedure p5(const aa:array [i..j:integer] of integer);

  var ptr:^integer;
begin
  aa[2] := 3;
  ptr := ref(aa[1]);
  p4(aa);
end;

begin
end.
