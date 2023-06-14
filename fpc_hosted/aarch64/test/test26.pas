procedure putchar(ch: char); external;

var a,b: packed array [1..10] of char;

procedure print(var a:packed array [l..h: integer] of char);
  var i: integer;
  begin
    for i := l to h do putchar(a[i]);
  end;

procedure println(var a:packed array [l..h: integer] of char);
  var i: integer;
  begin
    for i := l to h do putchar(a[i]);
    putchar(chr(10));
  end;

procedure p1;
  begin
    a := '0123456789';
    b := '9876543210';
    println(b);
    println(a);
  end;

begin p1; end.
