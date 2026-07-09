var f:text;
  ch: char;
  i,j: integer;
  s: string[255];

begin

  writeln('rewrite foo.txt, write text, reset, read/print char buffer'); writeln;
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

  writeln; writeln('append, reset, read and print using string buffer'); writeln;

  writeln(f, 'append to the end');
  reset(f);
  while not eof(f) do
    begin
    write('"');
    readln(f, s);
    writeln(s,'"');
    end;

  writeln; writeln('rewrite, write integers, read/print'); writeln;

  rewrite(f);
  writeln(f, 123, 456);
  writeln(f);
  writeln(f, 654, 321);

  reset(f);
  while not eof(f) do
    begin
    readln(f, i, j);
    writeln(i,j);
    end;

  writeln; writeln('rewrite, write csv integers, read/print'); writeln;

  rewrite(f);
  writeln(f, 123:1, ',', 456:1);
  writeln(f, 654:1, ',', 321:1);

  reset(f);
  while not eof(f) do
    begin
    read(f, i);
    write(i:1);
    read(f, ch);
    write(ch);
    readln(f, i);
    writeln(i:1);
    end;

end.
