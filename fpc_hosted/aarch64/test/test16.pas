program foo;
var i: integer;

procedure p(i,j,k: integer); external;

procedure ppp(i: integer); external;

procedure p1(i, j, k: integer);
begin
  p(i,j,k);
  j := j + 3;
  ppp(j);
  p(i,j,k);
  p(i,j,k+3);
  p(k, j, i);
end;

procedure pp;
begin
{stack params need to be reversed once all works}
 p(1,2,3);
 p(1,i,3);
end;

begin
end.
