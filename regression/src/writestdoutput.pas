{ test simple write to standard output}

%include 'testlib'

var i:integer;
  ch: char;
  a: packed array [1..3] of char;

begin
  a := 'xyz';
  write('y', 'z');
  i := 3;
  write('a':i);
  write(100:4);
  writeln('!');
  writeln('abc':1, a:4);
  writeln(false, true, false:1, true:1, false: 10, true: 10);
end.
