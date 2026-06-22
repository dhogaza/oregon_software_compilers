type
  p5 = packed array [1..5] of char;
  s255 = string[255];
  s3 = string[3];

var
  s, s1: s255;
  short: s3;
  p5var: p5;
  c: char;

function tests255func(s:s255): s255;
begin
  tests255func := s + 'abc';
end;

procedure testp5(p5param: p5);
begin
  writeln(p5param);
end;

procedure tests255(s255param: s255);

var
  i: integer;

begin
  write(s255param, length(s255param):3, ' ');
  for i := 1 to length(s255param) do
    write(s255param[i]);
  writeln;
end;

{ These two test that detection of modified value params and the
  consequent pushing of a copy of the param value works properly
  in terms of semantics.  One actually has to look at the generated
  code to verify that the copy is being made.
}

procedure testp5mod(p5param: p5);
begin
  writeln(p5param);
  p5param[3] := '3';
end;

procedure tests255mod(s255param: s255);

var
  i: integer;

begin
  write(s255param, length(s255param):3, ' ');
  for i := 1 to length(s255param) do
    write(s255param[i]);
  writeln;
  s255param[2] := '2';
end;

begin
  writeln('test packed arrays of char and conversion to string');
  writeln;
  write('expected ''abcde'': ');
  testp5('abcde');
  p5var := 'vwxyz';
  write('expected ''vwxyz'': ');
  testp5(p5var);

  write('expected ''vwxyz'': ');
  testp5mod(p5var);
  write('expected ''vwxyz'': ');
  writeln(p5var);
  
  write('expected ''vwxyz 5 vwxyz'': ');
  tests255(p5var);
  writeln;

  writeln('test char conversion to string');
  writeln;
  c := 'b';
  write('expected ''0 1 0'': ');
  tests255('0');
  write('expected ''b 1 b'': ');
  tests255(c);
  writeln;
  writeln('test strings directly');
  writeln;
  short := 'abcdefxyz';
  write('expected ''abc 3 abc'': ');
  tests255(short);
  s := '0123456789abcdef';
  writeln('expected ''0123456789abcdef'': ', s);
  write('expected ''0123456789abcdef 16 0123456789abcdef'': ');
  tests255(s);
  s1 := s + short;
  write('expected ''0123456789abcdefabc 19 0123456789abcdefabc'': ');
  tests255(s1);

  write('expected ''0123456789abcdefabc 19 0123456789abcdefabc'': ');
  tests255mod(s1);
  write('expected ''0123456789abcdefabc'': ');
  writeln(s1);

  writeln;
  writeln('comparisons between Pascal standard packed array strings');
  writeln;

  p5var := '11234';

  writeln('11234 vs 01234');
  writeln('expect false: ', p5var =  '01234');
  writeln('expect true: ', p5var <>  '01234');
  writeln('expect false: ', p5var <=  '01234');
  writeln('expect false: ', p5var <  '01234');
  writeln('expect true: ', p5var >=  '01234');
  writeln('expect true: ', p5var >  '01234');
  writeln;

  writeln('11234 vs 11234');
  writeln('expect true: ', p5var =  '11234');
  writeln('expect false: ', p5var <>  '11234');
  writeln('expect true: ', p5var <=  '11234');
  writeln('expect false: ', p5var <  '11234');
  writeln('expect true: ', p5var >=  '11234');
  writeln('expect false: ', p5var >  '11234');
  writeln;

  writeln('11234 vs 11235');
  writeln('expect false: ', p5var =  '11235');
  writeln('expect true: ', p5var <>  '11235');
  writeln('expect true: ', p5var <=  '11235');
  writeln('expect true: ', p5var <  '11235');
  writeln('expect false: ', p5var >=  '11235');
  writeln('expect false: ', p5var >  '11235');

  writeln;
  writeln('comparisons between extended short strings');
  writeln;

  s1 := '11234';

  writeln('11234 vs 01234');
  writeln('expect false: ', s1 =  '01234');
  writeln('expect true: ', s1 <>  '01234');
  writeln('expect false: ', s1 <=  '01234');
  writeln('expect false: ', s1 <  '01234');
  writeln('expect true: ', s1 >=  '01234');
  writeln('expect true: ', s1 >  '01234');
  writeln;

  writeln('11234 vs 11234');
  writeln('expect true: ', s1 =  '11234');
  writeln('expect false: ', s1 <>  '11234');
  writeln('expect true: ', s1 <=  '11234');
  writeln('expect false: ', s1 <  '11234');
  writeln('expect true: ', s1 >=  '11234');
  writeln('expect false: ', s1 >  '11234');
  writeln;

  writeln('11234 vs 11235');
  writeln('expect false: ', s1 =  '11235');
  writeln('expect true: ', s1 <>  '11235');
  writeln('expect true: ', s1 <=  '11235');
  writeln('expect true: ', s1 <  '11235');
  writeln('expect false: ', s1 >=  '11235');
  writeln('expect false: ', s1 >  '11235');

  writeln('expect ''xyzabc'': ', tests255func('xyz'));

end.
