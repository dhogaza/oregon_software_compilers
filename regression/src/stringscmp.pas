var
 a,b: packed array [1..3] of char;
 s1,s2: string[255];

begin
  s1 := 'abc';
  writeln(s1);
  writeln('boolean compares =, <>, <, >, <=, >=');
  writeln('testing ''',s1, ''' vs ''xyz''');
  writeln('expect false ',s1 = 'xyz');
  writeln('expect true ',s1 <> 'xyz');
  writeln('expect true ', s1 < 'xyz');
  writeln('expect false ', s1 > 'xyz');
  writeln('expect true ', s1 <= 'xyz');
  writeln('expect false ', s1 >= 'xyz');
  writeln;

  writeln('testing ''',s1, ''' vs ''abcd''');
  writeln('expect false ', s1 = 'abcd');
  writeln('expect true ', s1 <> 'abcd');
  writeln('expect true ', s1 < 'abcd');
  writeln('expect false ', s1 > 'abcd');
  writeln('expect true ', s1 <= 'abcd');
  writeln('expect false ', s1 >= 'abcd');
  writeln;

  writeln('testing ''',s1, ''' vs ''ab''');
  writeln('expecting false ', s1 = 'ab');
  writeln('expecting true ', s1 <> 'ab');
  writeln('expecting false ', s1 < 'ab');
  writeln('expecting true ', s1 > 'ab');
  writeln('expecting false ',s1 <= 'ab');
  writeln('expecting true ', s1 >= 'ab');
  writeln;

  writeln('testing ''',s1, ''' vs ''abc''');
  writeln('expecting true ', s1 = 'abc');
  writeln('expecting false ', s1 <> 'abc');
  writeln('expecting false ', s1 < 'abc');
  writeln('expecting false ', s1 > 'abc');
  writeln('expecting true ',s1 <= 'abc');
  writeln('expecting true ', s1 >= 'abc');
 
end.
