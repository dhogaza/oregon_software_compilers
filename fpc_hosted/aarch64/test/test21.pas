{$nomain}

var i:integer;

procedure p(i: integer);
begin
end;

procedure p1;
begin
  p(i);
  i := 1;
end;
