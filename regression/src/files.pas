var f: file of char;
  ch: char;

begin

  writeln('write, read, and print foo.txt'); writeln;

  rewrite(f, 'foo.txt', ':w+');

  for ch := 'a' to 'z' do
    begin
    f^ := ch;
    put(f);
    end;
  reset(f);
  while not eof(f) do
    begin
    write(f^);
    get(f);
    end;
  writeln;

  writeln('rewrite, read, and print foo.txt'); writeln;

  rewrite(f);
  for ch := 'z' downto 'a' do
    begin
    f^ := ch;
    put(f);
    end;
  reset(f);
  while not eof(f) do
    begin
    write(f^);
    get(f);
    end;
  writeln;

  writeln('delete foo.txt'); writeln;

  delete(f);

  writeln; writeln('read and print ../env.h'); writeln;

  reset(f, '../env.sh');
  while not eof(f) do
    begin
    write(f^);
    get(f);
    end;

  writeln; writeln('try to do a put on the read-only file ../env.sh'); writeln;
  put(f);

end.
