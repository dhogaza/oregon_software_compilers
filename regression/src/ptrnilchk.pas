{$check}

type intptr = ^integer;

var p, p1: intptr;

{ NIL pointer check }

begin
  new(p);
  p^ := 3;
  writeln('p^ expect 3: ', p^:3);
  dispose(p);
  if p = NIL then writeln('p correctly set to NIL by dispose(p)');
  writeln('after dispose p, p^ expect error: ');
  p^ := 4;
end.
