type ftype =
         record
           c: char;
           i: integer;
         end;
var
  f: file of ftype;
  data: ftype;
  ch: char;

begin

  writeln('rewrite(f, ''foo.txt'','':w+''), put, get and print foo.txt');

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

  writeln('rewrite, put, reset, get and print');

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

  writeln('seek(f,2), put, reset, get and print');

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

  writeln('seek(f,4), get and print');

  seek(f,4);
  while not eof(f) do
    begin
    with f^ do
      writeln(c, i);
    get(f);
    end;

  writeln('rewrite, write, reset, read and print');

  rewrite(f);
  for ch := '0' to '9' do
    begin
    data.c := ch;
    data.i := ord(ch);
    write(f, data);
    end;
  reset(f);
  while not eof(f) do
    begin
    read(f, data);
    writeln(data.c, data.i);
  end;

  writeln('delete foo.txt');

  delete(f);

end.
