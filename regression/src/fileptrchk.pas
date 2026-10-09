{$check}

type charptr = ^char;

var f: file of char;
    ch: char;
    r: record
         case boolean of
         false:(f1: text);
         true:(ptr: charptr);
       end;

begin
  writeln('reset file variable f');
  reset(f, 'a.out');
  writeln('Reference file variable f''s value');
  ch := f^;
  writeln('Set file variable f''s value');
  f^ := 'a';
  writeln('Throw reference error setting file variable r.f1''s value');
  r.ptr := ref(ch);
  r.f1^ := 'a';
end.
