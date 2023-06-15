{ for fpc primarily }

{type atype = array [1..5000] of char;}
type atype = array [1..50] of char;
var a: atype;
  i,j: integer;
  b: boolean;

procedure p(a: atype);
begin a[3] := 'c'; end;

procedure p1;
begin
{  p(a);p(a);}
  if b then
    p(a)
  else p(a);
  if i = 0 then p(a);
  if i = 4 then p(a);
  if i = j then p(a);
  if b and (i = j) then p(a);
end;

begin end.

