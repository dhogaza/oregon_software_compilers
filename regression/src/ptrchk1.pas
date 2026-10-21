{$check}

type intptr = ^integer;

var p, p1: intptr;

{ check to see if front end properly accounts for a procedure
  which calls a proc param, which we pessimistically assume
  will call dispose.
}

procedure procparam;
begin
  dispose(p);
end;

procedure proc(procedure procparam);
begin
  procparam;
end;

begin
  new(p);
  p^ := 3;
  p1 := p;
  writeln('p^ expect 3: ', p^:3);
  writeln('p1^ expect 3: ', p1^:3);
  proc(procparam);
  if p = NIL then writeln('p correctly set to NIL by dispose(p)');
  writeln('after dispose p, p1^ expect error: ');
  p1^ := 4;
end.
