type nums = (one, two, three, four, five, six, seven, eight);
  numset = set of nums;
  alpha = (a,b,c,d,e,f,g,h,i,j,k);
  alphaset = set of alpha;
var s1, s2: numset;
  b1, b2: nums;
  a1,a2: alpha;
  sa1,sa2: alphaset;

function func(p: nums):nums;
begin
  func := p;
end;

procedure initsets;
begin
  sa1 := [b, e, a1];
  sa2 := [a2..j];
  s1 := [one, b1, b2, func(four)];
  s2 := [eight, b1 .. b2];
end;

procedure putnumset(s: numset);
  var n:nums;
begin
  for n := one to eight do
    write(n in s, ' ');
  writeln;
end;

procedure putalphaset(s: alphaset);
  var n:alpha;
begin
  for n := a to k do
    write(n in s, ' ');
  writeln;
end;

begin
  a1 := k;
  a2 := c;
  b1 := two;
  b2 := five;
  initsets;
  write('s1:[one, two, five, func(four)] '); putnumset(s1);
  write('s2:[eight, two..five] '); putnumset(s2);
  writeln('b2:five in s2: ', b2 in s2);
  writeln('succ(b2):six in s2: ', succ(b2) in s2);
  writeln('five in s2: ', five in s2);
  writeln('six in s2: ', six in s2);
  write('s1 + s2 '); putnumset(s1 + s2);
  write('s1 * s2 '); putnumset(s1 * s2);
  write('s1 - s2 '); putnumset(s1 - s2);
  write('sa1:[b, e, k] '); putalphaset(sa1);
  write('sa2:[c..j] '); putalphaset(sa2);
  writeln('sa1 = sa2 ', sa1 = sa2);
  writeln('sa1 <> sa2 ', sa1 = sa2);
  writeln('sa1:[b, e, k] <= [b, e] ',sa1 <= [b, e]);
  writeln('sa1:[b, e, k] >= [b, e] ',sa1 >= [b, e]);
  writeln('a2:c in sa2:[c..j] ', a2 in sa2);
  writeln('j in sa2:[c..j] ', j in sa2);
  writeln('a in sa2:[c..j] ', a in sa2);
end.

