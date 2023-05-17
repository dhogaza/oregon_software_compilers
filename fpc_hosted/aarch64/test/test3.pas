program foo;
type intptr = ^integer;
var
  i,j : integer;
  p,p1 : intptr;
  c,c1: char;
  s,s1: -32000..32000;
  u,u1: 0..65535;
  int,int1: integer;

procedure extend;
begin
  p := loophole(intptr, c1);
  s := ord(c);
  int := loophole(integer, c);
end;

procedure shorts;
begin
  i := s1;
end;

procedure shortus;
begin
  j := u1;
end;


procedure chars;
begin
  c := c1;
end;

procedure fubar;
begin
  p := p1;
end;

procedure bar;
begin
  i := j;
end;

begin
 end.
