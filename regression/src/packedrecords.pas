var
  r1: packed record
       a,b: boolean;
       ch: char;
       r: packed record
            c,d: boolean;
          end;
       i: -4 ..3;
       j: integer;
     end;
  b: boolean;
  i: integer;

procedure p;
begin
  r1.a := false;
  r1.b := true;
  r1.ch := 'a';
  r1.i := -3;
  r1.j := 4;
  r1.r.d := b;
  r1.r.c := false;
  writeln('r1.a expect false ', r1.a);
  write('if r1.b expect true ');
  if r1.b then writeln('true') else writeln('false');
  writeln('r1.b expect true ', r1.b);
  writeln('r1.ch expect a ', r1.ch);
  writeln('r1.i expect -3 ', r1.i);
  writeln('r1.j expect 4 ', r1.j);
  writeln('r1.r.d expect ', b, ' ', r1.r.d);
  writeln('r1.r.c expect false ', r1.r.c);
  with r1.r do
    begin
    writeln('with r1.r');
    writeln('c expect false ', c);
    writeln('d expect ', b, ' ', d);
    end;
  writeln('r1.i + r1.i + r1.j expect -2 ', r1.i + r1.i + r1.j);
end;

procedure p1;

var a: packed array[0..511] of packed record r:0..511 end;
  i: 0..511;
  b: boolean;

begin
  for i := 0 to 511 do a[i].r := i;
  b := true;
  i := 0;
  while b and (i < 511) do
    begin
    b := b and (a[i].r + 1 = a[i + 1].r);
    i := i + 1;
    end;
  writeln('expect b: true i: 511  b: ', b:1, ' i: ', i:1);
  write('expect a[i].r <= 511 true: ');
  if a[i].r <= 511 then writeln('true') else writeln('false');
  writeln('test optimized tests against 0');
  write('expect a[i].r < 0 false: ');
  if a[i].r < 0 then writeln('true') else writeln('false');
  write('expect a[i].r >= 0 true: ');
  if a[i].r >= 0 then writeln('true') else writeln('false');
end;

{$index}
procedure p2;

var a: packed array[0..511] of packed record r:0..511 end;
  i: 0..511;
  b: boolean;

begin
  for i := 0 to 511 do a[i].r := i;
  b := true;
  i := 0;
  while b and (i < 511) do
    begin
    b := b and (a[i].r + 1 = a[i + 1].r);
    i := i + 1;
    end;
  writeln('expect b: true i: 511  b: ', b:1, ' i: ', i:1);
  write('expect a[i].r <= 511 true: ');
  if a[i].r <= 511 then writeln('true') else writeln('false');
  writeln('test optimized tests against 0');
  write('expect a[i].r < 0 false: ');
  if a[i].r < 0 then writeln('true') else writeln('false');
  write('expect a[i].r >= 0 true: ');
  if a[i].r >= 0 then writeln('true') else writeln('false');
end;

procedure p3;

var a: packed array[0..511] of packed record r:0..511 end;
  i: 0..511;
  b: boolean;

begin
  for i := 0 to 511 do a[i].r := i;
  b := true;
  i := 0;
  while b and (i <= 511) do
    begin
    b := b and (a[i].r + 1 = a[i + 1].r);
    i := i + 1;
    end;
end;

begin
 b := true;
 p;
 writeln('Checking disabled should pass');
 p1;
 writeln('Checking enabled should pass');
 p2;
 writeln('attempting to access a[512] should trigger a subscript error');
 p3;
end.
