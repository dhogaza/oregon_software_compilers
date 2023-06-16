%include 'testlib';

procedure p(i: integer);
begin
  putint(i); putln;
end;

begin
  p(65535);
  p(65536);
  p(65537);
  p(65539);
  p(-1);
  p(-65536);
  p(-65537);
  p(-65539);
end.
