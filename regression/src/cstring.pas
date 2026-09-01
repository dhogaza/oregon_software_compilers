{$nocheck}
type

  { For faking out C strings }
  _p_charptr = ^char; 

  { For passing string/packed char array parameters to library functions.
    If compiled with array bounds checking enabled it will still work.
  }

  stringarray = array [0..32767] of char;
  stringarrayp = ^stringarray;
  shortstring = string[255];

  convert =
    record
      case boolean of
        false: (str: ^shortstring);
        true: (a: stringarrayp);
    end;

var s: shortstring;

procedure toshortstring(var s: shortstring; p: _p_charptr);

var
  i: 0 .. 255;
  c: convert;

begin
  c.a := loophole(stringarrayp, p);
  i := 0;
  while ((i < 255) and (c.a^[i] <> chr(0))) do
    begin
    s[i + 1] := c.a^[i];
    i := i + 1;
    end;
  s[i + 1] := chr(0);
  s[0] := chr(i);
end;
    
function cstring(s: shortstring): _p_charptr;
var c: convert; 
begin
  c.str := ref(s);
  cstring := ref(c.a^[1]);
end;

procedure writecstring(p: _p_charptr);

  var c: convert;
    i: integer;

begin
  c.a := loophole(stringarrayp, p);
  i := 0;
  while c.a^[i] <> chr(0) do
    begin
    write(c.a^[i]);
    i := i + 1;
    end;
end;

procedure printf(const p: _p_charptr); nonpascal;

begin
  writecstring(cstring('abc'));
  writeln;
  printf(cstring('xyz'));
  writeln;
  toshortstring(s, cstring('abcdef'));
  writeln(s);
end.

