%include 'testlib'
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
    begin
    putbool(n in s);
    putchar(' ');
    end;
  putln;
end;

procedure putalphaset(s: alphaset);
  var n:alpha;
begin
  for n := a to k do
    begin
    putbool(n in s);
    putchar(' ');
    end;
  putln;
end;

begin
  a1 := k;
  a2 := c;
  b1 := two;
  b2 := five;
  initsets;
  putstring('s1:[one, two, five, func(four)] '); putnumset(s1);
  putstring('s2:[eight, two..five] '); putnumset(s2);
  putstring('s1 + s2 '); putnumset(s1 + s2);
  putstring('s1 * s2 '); putnumset(s1 * s2);
  putstring('s1 - s2 '); putnumset(s1 - s2);
  putstring('sa1:[b, e, k] '); putalphaset(sa1);
  putstring('sa2:[c..j] '); putalphaset(sa2);
end.
  
