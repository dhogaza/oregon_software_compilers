const foo = 'abc';

var b: boolean;
  i,j,k,l: integer;

function eq(i,j: integer): boolean;

begin
  eq := (i = j);
end;

function ne(i,j: integer): boolean;

begin
  ne := (i <> j);
end;

function lt(i,j: integer): boolean;

begin
  lt := (i < j);
end;

function gt(i,j: integer): boolean;

begin
  gt := (i > j);
end;

function le(i,j: integer): boolean;

begin
  le := (i <= j);
end;

function ge(i,j: integer): boolean;

begin
  ge := (i >= j);
end;

begin
  writeln('three pairs: 1,2 2,2 3,2');
  writeln;
  writeln('less than');
  writeln(lt(1,2):1);
  writeln(lt(2,2):1);
  writeln(lt(3,2):1);
  writeln;

  writeln('greater than');
  writeln(gt(1,2):1);
  writeln(gt(2,2):1);
  writeln(gt(3,2):1);
  writeln;

  writeln('less or equal than');
  writeln(le(1,2):1);
  writeln(le(2,2):1);
  writeln(le(3,2):1);
  writeln;

  writeln('greater or equal than');
  writeln(ge(1,2):1);
  writeln(ge(2,2):1);
  writeln(ge(3,2):1);
  writeln;

  writeln('equal to');
  writeln(eq(1,2):1);
  writeln(eq(2,2):1);
  writeln(eq(3,2):1);
  writeln;

  writeln('not equal to');
  writeln(ne(1,2):1);
  writeln(ne(2,2):1);
  writeln(ne(3,2):1);
  writeln;

end.
