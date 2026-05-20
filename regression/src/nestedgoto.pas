var i: integer;

procedure outer;

label 1, 2;

procedure p1;

  procedure p2;

  begin
    goto 2;
  end; 

begin
  p2;
end; 

procedure p;

  begin
    goto 1;
  end;

begin
  i := 1234;
  writeln('before nested label 1');
  writeln(i:1);
  p;
  goto 1;
  writeln('error');
  1:
  writeln('after nested label 1');
  writeln(i:1);

  i := 4321;
  writeln('before nested label 2');
  writeln(i:1);
  p1;
  goto 2;
  writeln('error');
  2:
  writeln('after nested label 2');
  writeln(i:1);
end;

begin
  outer;
end.
