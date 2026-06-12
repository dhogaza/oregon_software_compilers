type
  p5 = packed array [1..5] of char;
  s255 = string[255];
  s3 = string[3];

var
  s, s1: s255;
  short: s3;
  p5var: p5;
  c: char;

procedure testp5(p5param: p5);
begin
  writeln(p5param);
end;

procedure tests255(s255param: s255);

begin
  writeln(s255param, length(s255param):3);
end;

begin
  writeln('test packed arrays of char and conversion to string');
  writeln;
  write('expected abcde: ');
  testp5('abcde');
  p5var := 'vwxyz';
  write('expected vwxyz: ');
  testp5(p5var);
  write('expected vwxyz: 5 ');
  tests255(p5var);
  writeln;
  writeln('test char conversion to string');
  writeln;
  c := 'b';
  write('expected 0 1: ');
  tests255('0');
  write('expected b 1: ');
  tests255(c);
  writeln;
  writeln('test strings directly');
  writeln;
  short := 'abcdefxyz';
  write('expected abc 3: ');
  tests255(short);
  s := '0123456789abcdef';
  writeln('expected 0123456789abcdef: ', s);
  write('expected 0123456789abcdef 16: ');
  tests255(s);
  s1 := s + short;
  write('expected 0123456789abcdefabc 19: ');
  tests255(s1);
end.
