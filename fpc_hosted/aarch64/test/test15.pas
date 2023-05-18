program foo;

procedure p; external;

procedure pp(procedure ppp);
begin
end;

begin
  pp(p);
end.
