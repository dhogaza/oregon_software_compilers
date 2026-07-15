var f:text;
  ch: char;
  i,j: integer;
  s: string[255];
  s1: string[5];
  a: packed array [1..50] of char;
  a1: packed array [1..5] of char;

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

  writeln; writeln('reset, get, and print using f^'); writeln;

  reset(f);
  while not eof(f) do
    begin
      while not eoln(f) do
      begin
      write(f^);
      get(f);
      end;
    writeln;
    get(f);
    end;
  
  writeln;
  writeln('reset, read and print using multiple small string buffer reads');
  writeln;

  reset(f);
  while not eof(f) do
    begin
    write('"');
    while not eoln(f) do
      begin
      read(f, s1);
      write(s1);
      end;
    readln(f);
    writeln('"');
    end;


  writeln; writeln('reset, read and print using packed array buffer'); writeln;

  reset(f);
  while not eof(f) do
    begin
    write('"');
    readln(f, a);
    writeln(a,'"');
    end;

  writeln; writeln('reset, read and print using short packed array buffer'); writeln;

  reset(f);
  while not eof(f) do
    begin
    write('"');
    readln(f, a1);
    writeln(a1,'"');
    end;

  writeln;
  writeln('reset, read and print using multiple short packed array buffer');
  writeln;

  reset(f);
  while not eof(f) do
    begin
    write('"');
    while not eoln(f) do
      begin
      read(f, a1);
      write(a1);
      end;
    readln(f);
    writeln('"');
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

  reset(f, 'filestext.s.good');
  rename(f, 'filestext.s.foo');
  close(f);
  reset(f, 'filestext.s.foo');
  writeln('copying filestext.s.foo');
  while not eof(f) do
    begin
    readln(f,s);
    writeln(s);
    end;
  rename(f, 'filestext.s.good');

  reset(f, 'absolute garbage',,i);
  writeln('reset fails: ', i:1);
  reset(f, 'filestext.s',,i);
  writeln('reset succeeds:', i:1);

end.
