{ test simple write to standard output}

var i:integer;
  ch: char;
  a: packed array [1..3] of char;
  s: string[255];

begin
  a := 'xyz';
  write('y', 'z');
  i := 3;
  s := a;
  write('a':i);
  write(100:4);
  writeln('!');
  writeln('abc':1, a:4, s:4);
  writeln(false, true, false:1, true:1, false: 10, true: 10);
end.
