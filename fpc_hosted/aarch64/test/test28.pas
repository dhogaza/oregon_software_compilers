program main;

procedure putchar(ch: char); external;

var
  a1:array [0..0] of char;
  a2:array [0..1] of char;
  a3:array [0..2] of char;
  a4:array [0..3] of char;
  a5:array [0..4] of char;
  a6:array [0..5] of char;
  a7:array [0..6] of char;
  a8:array [0..7] of char;
  a9:array [0..8] of char;
  a10:array [0..9] of char;

procedure fill(var a:array [i..j: integer] of char);

var
  k: integer;
  ch: char;

begin
  ch := 'a';
  k := i;
  while k <= j do
    begin
    a[k] := ch;
    ch := chr(ord(ch) + 1);
    k := K + 1;
    end;
end;


procedure p(var a:array [i..j:integer] of char);

  var
    k: integer;

begin
  k := i;
  while k <= j do
    begin
    putchar(a[k]);
    k := K + 1;
    end;
  putchar(chr(10));
end;

procedure p1(a:array [i..j:integer] of char);

  var
    k: integer;

begin
  k := i;
  while k <= j do
    begin
    putchar(a[k]);
    k := K + 1;
    end;
  putchar(chr(10));
end;

begin

  fill(a1);
  p(a1);
  p1(a1);

  fill(a2);
  p(a2);
  p1(a2);

  fill(a3);
  p(a3);
  p1(a3);

  fill(a4);
  p(a4);
  p1(a4);

  fill(a5);
  p(a5);
  p1(a5);

  fill(a6);
  p(a6);
  p1(a6);

  fill(a7);
  p(a7);
  p1(a7);

  fill(a8);
  p(a8);
  p1(a8);

  fill(a9);
  p(a9);
  p1(a9);

  fill(a10);
  p(a10);
  p1(a10);
end.
