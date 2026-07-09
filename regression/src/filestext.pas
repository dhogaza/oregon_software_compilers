var f:text;
  ch: char;
  s: string[255];

begin
  rewrite(f, 'foo.txt',':w+');
  writeln(f, 'abc','a':3, 42);
  writeln(f, 'how about that?');

  reset(f);
  while not eof(f) do
    begin
    write('"');
    while not eoln(f) do
      begin 
      read(f, ch);
      write(ch);
      end;
    readln(f);
    writeln('"');
    end;

  writeln(f, 'append to the end');

  reset(f);
  while not eof(f) do
    begin
    write('"');
    readln(f, s);
    writeln(s,'"');
    end;

end.
