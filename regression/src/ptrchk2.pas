{$check}

type intptr = ^integer;

var p, p1: intptr;

{ check to see if front end properly accounts for a procedure
  which disposes a pointer.
}

procedure proc;
begin
  dispose(p);
end;

begin
  new(p);
  p^ := 3;
  p1 := p;
  writeln('p^ expect 3: ', p^:3);
  writeln('p1^ expect 3: ', p1^:3);
  proc;
  if p = NIL then writeln('p correctly set to NIL by dispose(p)');
  writeln('after dispose p, p1^ expect error: ');
  p1^ := 4;
end.
