{$nocheck,nomain}
type

  { For faking out C strings }
  _p_charptr = ^char; 

  { For passing string/packed char array parameters to library functions.
    If compiled with array bounds checking enabled it will still work.
  }
  _p_stringarray = packed array [1..maxint] of char;

{glibc}
procedure exit(code: integer); nonpascal;
procedure putchar(ch: char); nonpascal;
function malloc(size: int64): _p_charptr; nonpascal;
procedure free(p: _p_charptr); nonpascal;

{ pascal-2 lib declarations }

procedure _p_caseerr; external;
procedure _p_wtc_o(ch: char; width: integer); external;
procedure _p_wti_o(i: integer; width: integer); external;
procedure _p_wtb_o(b: boolean; width: integer); external;
procedure _p_wts_o(var str: _p_stringarray; length: integer; width: integer); external;
procedure _p_wtln_o; external;
procedure _p_new(var p: _p_charptr; size: int64); external;
procedure _p_dispos(var p: _p_charptr; size: int64); external;

{ pascal-2 library implementations }

procedure _p_caseerr;
  begin
    writeln('case error');
    exit(1);
  end;

procedure _p_wtb_o;

  var i: integer;

  begin
    for i := 5 + ord(not b) to width do
      write(' ');
   if b then
     write('true')
   else
     write('false');
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
