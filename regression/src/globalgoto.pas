%include 'testlib'

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
  putstringln('before global label 1');
  putintln(i);
  p;
  goto 1;
  putstringln('error');
  1:
  putstringln('after global label 1');
  putintln(i);

  i := 4321;
  putstringln('before global label 2');
  putintln(i);
  p1;
  goto 2;
  putstringln('error');
  2:
  putstringln('after global label 2');
  putintln(i);
end.
