type
  _p_charptr = ^char; 

{glibc}
procedure exit(code: integer); external;
procedure putchar(ch: char); external;
function malloc(size: int64): _p_charptr; external;
procedure free(p: _p_charptr); external;


type
  lib_unsigned = 0..16#FFFFFFFF;

  {For passing string/packed char array parameters to library functions.
   If compiled with array bounds checking enabled it will still work.
  }
  stringarray = packed array [1..maxint] of char;

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

{pascal-2 lib routines defined here}

procedure _p_caseerr; external;
procedure _p_wtc_o(ch: char; width: integer); external;
procedure _p_wti_o(i: integer; width: integer); external;
procedure _p_wtb_o(b: boolean; width: integer); external;
procedure _p_wts_o(var str: stringarray; length: integer; width: integer); external;
procedure _p_wtln_o; external;
procedure _p_new(var p: _p_charptr; size: int64); external;
procedure _p_dispos(var p: _p_charptr; size: int64); external;

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

{pascal-2 library procedures and functions}

procedure _p_caseerr;
  begin
    putstringln('case error');
    exit(1);
  end;

procedure _p_wtb_o;

  var i: integer;

  begin
    for i := 5 + ord(not b) to width do
      putchar(' ');
    putbool(b);
  end;

procedure _p_wtc_o;

  var i: integer;

  begin
    for i := 2 to width do putchar(' ');
    putchar(ch);
  end;

procedure _p_wti_o;

  var
    digits: packed array [0..18] of char;
    j: integer;
    count: integer;

  begin
    count := 0;
    if i < 0 then
    begin
      putchar('-');
      i := -i;
      count := count + 1;
    end;

    j := 0;
    repeat
      digits[j] := chr(i mod 10 + ord('0'));
      j := j + 1;
      i := i div 10;
      count := count + 1;
    until i = 0;

    for count := count + 1 to width do
      putchar(' ');

    repeat
      j := j - 1;
      putchar(digits[j]);
    until j = 0;

  end;

procedure _p_wts_o;

  var i: integer;

  begin
    for i := 1 to width - length do
      putchar(' ');
    for i := 1 to length do
      putchar(str[i]);
  end;

procedure _p_wtln_o;

  begin
    putchar(chr(10));
  end;

procedure _p_new;
begin
  p := malloc(size);
end;

procedure _p_dispos;
begin
  free(p);
  p := loophole(_p_charptr, 1);
end;
