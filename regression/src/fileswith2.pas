type ftype =
         record
           c: char;
           i: integer;
         end;
var
  f: file of ftype;
  data1,data2: ftype;
  ch: char;

begin

  writeln('rewrite(f, ''foo.txt'','':w+''), write, reset, reset and print foo.txt');

  rewrite(f, 'foo.txt', ':w+');

  for ch := '0' to '9' do
    begin
    data1.c := ch;
    data1.i := ord(ch);
    data2.c := 'a';
    data2.i := 5;
    write(f, data1, data2);
    end;
  reset(f);
  while not eof(f) do
    begin
    read(f, data1, data2);
    writeln(data1.c, data1.i, data2.c:2, data2.i);
  end;

  writeln('delete foo.txt');

  delete(f);

end.
