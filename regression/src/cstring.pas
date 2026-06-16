{$nocheck}
type

  { For faking out C strings }
  _p_charptr = ^char; 

  { For passing string/packed char array parameters to library functions.
    If compiled with array bounds checking enabled it will still work.
  }

  stringarray = array [1..maxint] of char;
  stringarrayp = ^stringarray;
  shortstring = string[255];

  convert =
    record
      case boolean of
        false: (str: ^shortstring);
        true: (a: stringarrayp);
    end;

function cstring(s: shortstring): _p_charptr;
var c: convert; 
begin
  c.str := ref(s);
  cstring := ref(c.a^[2]);
end;

procedure writecstring(p: _p_charptr);

  var c: convert;
    i: integer;

begin
  c.a := loophole(stringarrayp, p);
  i := 1;
  while c.a^[i] <> chr(0) do
    begin
    write(c.a^[i]);
    i := i + 1;
    end;
end;

procedure printf(p: _p_charptr); nonpascal;

begin
  writecstring(cstring('abc'));
  writeln;
  printf(cstring('xyz'));
  writeln;
end.

