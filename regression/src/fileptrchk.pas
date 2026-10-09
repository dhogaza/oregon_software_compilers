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
  writeln('dereference file variable f');
  ch := f^;
  writeln('throw pointer reference error');
  r.ptr := ref(ch);
  r.f1^ := 'a';
end.
