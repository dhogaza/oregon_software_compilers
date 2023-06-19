{$nomain}
{glibc}
procedure exit(code: integer); external;
procedure putchar(ch: char); external;

{defined here}
procedure putint(i: integer); external;

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

