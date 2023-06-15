{glibc}
procedure exit(code: integer); external;
procedure putchar(ch: char); external;

{defined here}
procedure putstringln(a:packed array [l..h: integer] of char); external;
procedure putstring(a:packed array [l..h: integer] of char); external;
procedure putint(i: integer); external;
procedure putln; external;
procedure _p_caseerr; external;

procedure putstring;
  var i: integer;
  begin
    for i := l to h do putchar(a[i]);
  end;

procedure putstringln;
  var i: integer;
  begin
    for i := l to h do putchar(a[i]);
    putchar(chr(10));
  end;


procedure putln;

  begin
    putchar(chr(10));
  end;

procedure putint;

  var
    digits: packed array [0..25] of char;
    j: integer;

  begin
    if i < 0 then
    begin
      putchar('-');
      i := -i;
    end;

    j := 0;
    repeat
      digits[j] := chr(i mod 10 + ord('0'));
      i := i div 10;
      j := j + 1;
    until i = 0;

    repeat
      j := j - 1;
      putchar(digits[j]);
    until j = 0;

  end;
    
procedure _p_caseerr;
  begin
    putstringln('case error');
    exit(1);
  end;

