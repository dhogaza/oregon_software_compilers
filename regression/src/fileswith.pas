var f: file of
         record
           c: char;
           i: integer;
         end;
  ch: char;

begin

  writeln('write, read, and print foo.txt'); writeln;

  rewrite(f, 'foo.txt', ':w+');

  for ch := 'a' to 'z' do
    begin
      with f^ do
        begin
        c := ch;
        i := ord(ch);
        end;
    put(f);
    end;
  reset(f);
  while not eof(f) do
    begin
    with f^ do
      writeln(c, i);
    get(f);
    end;
  writeln;

  writeln('rewrite, read, and print foo.txt'); writeln;

  rewrite(f);
  for ch := 'z' downto 'a' do
    begin
    with f^ do
      begin
      c:= ch;
      i := ord(ch);
      end;
    put(f);
    end;
  reset(f);
  while not eof(f) do
    begin
    with f^ do
      writeln(c, i);
    get(f);
    end;
  writeln;

  seek(f, 2);
  with f^ do
    begin
    c := '!';
    i := ord(c);
    end;
  put(f);
  reset(f);
  while not eof(f) do
    begin
    with f^ do
      writeln(c, i);
    get(f);
    end;
  writeln;

  seek(f,4);
  while not eof(f) do
    begin
    with f^ do
      writeln(c, i);
    get(f);
    end;
  writeln;

  writeln('delete foo.txt'); writeln;

  delete(f);

end.
