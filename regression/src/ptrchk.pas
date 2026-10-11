{$check}

type intptr = ^integer;

var p, p1: intptr;

begin
  new(p);
  p^ := 3;
  p1 := p;
  writeln('p^ expect 3: ', p^:3);
  { note that dereferencing p1 here leads to no error ... }
  dispose(p);
  writeln('after dispose p, p1^ expect error: ');
  { because dispose doesn't kill the ptrchk cse }
  p1^ := 4;
end.
