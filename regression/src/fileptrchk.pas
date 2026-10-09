{$check}

{ It is almost impossible to generate a file variable that doesn't
  point to the heap, so this just verifies that simple dereference
  works when pointer checking is enabled.
}

var f,f1: file of char;
    ch: char;

begin
  writeln('reset file variable f');
  reset(f, 'a.out');
  writeln('dereference file variable f');
  ch := f^;
end.
