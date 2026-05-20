label 1, 2;
var i: integer;

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
  writeln('before global label 1');
  writeln(i:1);
  p;
  goto 1;
  writeln('error');
  1:
  writeln('after global label 1');
  writeln(i:1);

  i := 4321;
  writeln('before global label 2');
  writeln(i:1);
  p1;
  goto 2;
  writeln('error');
  2:
  writeln('after global label 2');
  writeln(i:1);
end.
