program foo;

%include 'testlib';

procedure p(ch: char);

begin
  case ch of
    '1': putchar('1');
    'a': putchar('a');
    'b': putchar('b');
    'c': putchar('c');
    'd': putchar('d');
    'e': putchar('e');
    'f': putchar('f');
    'g': putchar('g');
    'h': putchar('h');
    'i': putchar('i');
    'j': putchar('j');
    'k': putchar('k');
    'l': putchar('l');
    'm': putchar('m');
    'n': putchar('n');
    'o': putchar('o');
    'p': putchar('p');
    'q': putchar('q');
    'r': putchar('r');
    's': putchar('s');
    't': putchar('t');
    'u': putchar('u');
    'v': putchar('v');
    'w': putchar('w');
    'x': putchar('x');
    'y': putchar('y');
    'z': putchar('z');
  end;
  putchar(chr(10));
end;

procedure p1(ch: char);

begin
  case ch of
    '1': putchar('1');
    '8': putchar('8');
    'a': putchar('a');
    'b': putchar('b');
    'd': putchar('d');
    'e': putchar('e');
    'f': putchar('f');
    'g': putchar('g');
    'h': putchar('h');
    'i': putchar('i');
    'j': putchar('j');
    'k': putchar('k');
    'l': putchar('l');
    'm': putchar('m');
    'n': putchar('n');
    'o': putchar('o');
    'p': putchar('p');
    'q': putchar('q');
    'r': putchar('r');
    's': putchar('s');
    't': putchar('t');
    'u': putchar('u');
    'v': putchar('v');
    'w': putchar('w');
    'x': putchar('x');
    'y': putchar('y');
    'z': putchar('z');
     otherwise
       begin
       putchar('?');
       putchar(ch);
       end;
  end;
  putchar(chr(10));
end;

begin

  putstringln('test integer const generation and putint');

  putstring('0? ');
  putintln(0);

  putstring('1234? ');
  putintln(1234);

  putstring('65535? ');
  putintln(65535);

  putstring('65536? ');
  putintln(65536);

  putstring('65537? ');
  putintln(65537);

  putstring('655359 ');
  putintln(65539);

  putstring('-1? ');
  putintln(-1);

  putstring('-65536? ');
  putintln(-65536);

  putstring('-65537? ');
  putintln(-65537);

  putstring('-65539? ');
  putintln(-65539);

  putstring('2004318071? ');
  putintln(16#77777777);

  putstringln('end of integer const generation and putint tests');
  putln;

  putstringln('testing with otherwise');
  p1('a');
  p1('q');
  p1('e');
  p1('d');
  p1('z');
  p1('c'); {otherwise}
  p1('0'); {otherwise}
  p1('1');
  p1('8');

  putstringln('can''t compile with checking enabled yet');
  putstringln('testing without otherwise, should throw case error');
  p('a');
  p('q');
  p('e');
  p('d');
  p('z');
end.
