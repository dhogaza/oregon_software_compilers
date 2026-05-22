var z: integer;

procedure foo(a,b,c,d,e,f,g,h,i,j,k,l:integer);
begin
writeln('foo: ', b, h, k);
end;

procedure bar(a,b,c,d,e,f,g,h,i,j,k,l:integer);

begin
writeln('bar: ', a, i, l);
end;

begin

  z := 3;

  foo(1,2,3,4,5,6,7,8,9,10,11,12);
  bar(1,2,3,4,5,6,7,8,9,10,11,12);

  if z = 3 then
    foo(1,2,3,4,5,6,7,8,9,10,11,12)
  else 
    bar(1,2,3,4,5,6,7,8,9,10,11,12);

  foo(1,2,3,4,5,6,7,8,9,10,11,12);

end.
