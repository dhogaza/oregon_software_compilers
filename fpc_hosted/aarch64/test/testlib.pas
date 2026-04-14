{glibc}
procedure exit(code: integer); external;
procedure putchar(ch: char); external;

type lib_unsigned = 0..16#FFFFFFFF;

{defined here}
procedure putstring(a:packed array [l..h: integer] of char); external;
procedure putstringln(a:packed array [l..h: integer] of char); external;
procedure putint(i: integer); external;
procedure putintln(i: integer); external;
procedure puthex(i: lib_unsigned); external;
procedure puthexln(i: lib_unsigned); external;
procedure putbool(b: boolean); external;
procedure putboolln(b: boolean); external;
procedure putcharln(ch: char); external;
procedure putln; external;
procedure _p_caseerr; external;

procedure putln;

  begin
    putchar(chr(10));
  end;

procedure putstring;
  var i: integer;
  begin
    for i := l to h do putchar(a[i]);
  end;

procedure putstringln;
  var i: integer;
  begin
    for i := l to h do putchar(a[i]);
    putln;
  end;

procedure puthex;

  var
    digits: packed array [0..16] of char;
    j: integer;

  begin

    j := 0;
    repeat
      if i mod 16 > 9 then
        digits[j] := chr(i mod 16 - 10 + ord('A'))
      else
        digits[j] := chr(i mod 16 + ord('0'));
      j := j + 1;
      i := i div 16;
    until i = 0;

    repeat
      j := j - 1;
      putchar(digits[j]);
    until j = 0;

  end;

procedure puthexln;

  begin
    puthex(i);
    putln;
  end;


procedure putint;

  var
    digits: packed array [0..18] of char;
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
      j := j + 1;
      i := i div 10;
    until i = 0;

    repeat
      j := j - 1;
      putchar(digits[j]);
    until j = 0;

  end;

procedure putintln;

  begin
    putint(i);
    putln;
  end;

procedure putbool;

  begin
    if b then putstring('true')
    else putstring('false');
  end;

procedure putboolln;

begin
  putbool(b);
  putchar(chr(10));
end;
    
procedure putcharln;

  begin
    putchar(ch);
    putln;
  end;

procedure _p_caseerr;
  begin
    putstringln('case error');
    exit(1);
  end;

