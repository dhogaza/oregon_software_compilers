var f: file of char;
  ch: char;

begin

  writeln('rewrite(f, ''foo.txt'', '':w+''), put, get and print foo.txt');

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

  writeln('rewrite(f), put, get and print foo.txt');

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

  writeln('seek(f,2), put, get and print foo.txt');

  seek(f, 2);
  f^ := '!';
  put(f);
  reset(f);
  while not eof(f) do
    begin
    write(f^);
    get(f);
    end;

  writeln('seek(f,4), get and print foo.txt');

  seek(f,4);
  while not eof(f) do
    begin
    write(f^);
    get(f);
    end;

  writeln('seek(f,4), read and print foo.txt');

  reset(f);
  while not eof(f) do
    begin
    read(f, ch);
    write(ch);
  end;

  writeln('delete foo.txt');

  delete(f);

  writeln('read and print ../env.h');

  reset(f, '../env.sh');
  while not eof(f) do
    begin
    write(f^);
    get(f);
    end;

  writeln('try to do a put on the read-only file ../env.sh');
  put(f);

end.
