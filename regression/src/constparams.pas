type str=string[255];
  stdstr = packed array[1..3] of char;

procedure p(const s:str);
begin
  writeln(s);
end;

procedure p1(const s:packed array[i..j:integer] of char);
  var ch: char;
begin
  writeln(s[i]);
end;

procedure p2(const i: integer);
begin
  writeln(i);
end;

begin
  p('xyz');
  p1('abc');
  p2(42);
end.
