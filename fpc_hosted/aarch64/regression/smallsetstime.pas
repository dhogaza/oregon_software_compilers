type nums = (one, two, three, four, five, six, seven, eight);
  numset = set of nums;
  alpha = (a,b,c,d,e,f,g,h,i,j,k);
  alphaset = set of alpha;

const
  count = 650;

var s1, s2: numset;
  b1, b2: nums;
  a1,a2: alpha;
  sa1,sa2: alphaset;
  i1,i2, i3: integer;

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
    na: array[nums] of boolean;
begin
  for n := one to eight do
   na[n] := n in s;
end;

procedure putalphaset(s: alphaset);
  var n:alpha;
    na: array[alpha] of boolean;
begin
  for n := a to k do
    na[n] := n in s;
end;

begin
  for i1 := 1 to count do
    for i2 := 1 to count do
      for i3 := 1 to count do
        begin
        a1 := k;
        a2 := c;
        b1 := two;
        b2 := five;
        initsets;
        putnumset(s1);
        putalphaset(sa1);
        end;
end.
  
