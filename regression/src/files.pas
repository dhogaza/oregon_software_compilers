var f: file of char;
  ch: char;

begin

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

  delete(f);

end.
