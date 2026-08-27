{Simple tests of for loops with a variable starting value and
 a constant termination value.  This causes the code generator
 to generate a variety of 16 and 32 bit constant values, and
 both cmp and cmn instructions to control the loop.
}

procedure down3(start: integer);
var i: integer;

begin
  writeln('test ', start:1, ' downto 3');
  for i := start downto 3 do write(i:3);
  writeln;
end;

procedure downminus1(start: integer);
var i: integer;

begin
  writeln('test ', start:1, ' downto -1');
  for i := start downto -1 do write(i:3);
  writeln;
end;

procedure downminus100000(start: integer);
var i: integer;

begin
  writeln('test ', start:1, ' downto -100000');
  for i := start downto -100000 do write(i:8);
  writeln;
end;

procedure down100000(start: integer);
var i: integer;

begin
  writeln('test ', start:1, ' downto 100000');
  for i := start downto 100000 do write(i:7);
  writeln;
end;

procedure up10(start: integer);
var i: integer;

begin
  writeln('test ', start:1, ' to 10');
  for i := start to 10 do write(i:3);
  writeln;
end;

procedure upminus3(start: integer);
var i: integer;

begin
  writeln('test ', start:1, ' to -3');
  for i := start to -3 do write(i:3);
  writeln;
end;

procedure up100000(start: integer);
var i: integer;

begin
  writeln('test ', start:1, ' to 100000');
  for i := start to 100000 do write(i:7);
  writeln;
end;

procedure upminus100000(start: integer);
var i: integer;

begin
  writeln('test ', start:1, ' to -100000');
  for i := start to -100000 do write(i:8);
  writeln;
end;

begin
  down3(10);
  down3(2);
  down3(-1);
  downminus1(10);
  downminus1(-1);
  downminus1(-2);
  down100000(100001);
  down100000(1);
  down100000(-100001);
  downminus100000(-99999);
  up10(1);
  up10(11);
  up10(-1);
  upminus3(-10);
  upminus3(-2);
  upminus3(1);
  up100000(99999);
  up100000(100001);
  upminus100000(-100005);
  upminus100000(-99999);
end.
