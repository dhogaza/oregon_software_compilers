program foo;

procedure putchar(ch: char); external;

procedure bar(a, b: char);
  var ch: char;
begin
  for ch := a to b do putchar(ch);
  putchar(chr(10));
  for ch := b downto a do putchar(ch);
  putchar(chr(10));
end;

procedure foo;
  var
    ch: char;

begin
  for ch := 'a' to 'z' do putchar(ch);
  putchar(chr(10));
  for ch := 'z' downto 'a' do putchar(ch);
  putchar(chr(10));
end; 

procedure bar1(a, b: integer);
  var i: integer;

begin
  for i := a to b do putchar(chr(i + ord('0')));
  putchar(chr(10));
  for i := b downto a do putchar(chr(i + ord('0')));
  putchar(chr(10));
end;

procedure foo1;
  var i: integer;

begin
  for i := 2 to 9 do putchar(chr(i + ord('0')));
  putchar(chr(10));
  for i := 9 downto 2 do putchar(chr(i + ord('0')));
  putchar(chr(10));
end;

begin
  bar('a', 'f');
  putchar('-'); putchar(chr(10));
  foo;

  bar1(0, 8);
  putchar('-'); putchar(chr(10));
  foo1;
end.
