%include 'testlib'

label 1;

begin
  putstringln('before global label 1');
  goto 1;
  putstringln('error');
  1:
  putstringln('after global label 1');
end.
