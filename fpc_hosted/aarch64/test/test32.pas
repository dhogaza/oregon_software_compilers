const foo = 'abc';
%include 'testlib';

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
  putstringln('less than');
  putboolln(lt(1,2));
  putboolln(lt(2,2));
  putboolln(lt(3,2));
  putln;

  putstringln('greater than');
  putboolln(gt(1,2));
  putboolln(gt(2,2));
  putboolln(gt(3,2));
  putln;

  putstringln('less or equal than');
  putboolln(le(1,2));
  putboolln(le(2,2));
  putboolln(le(3,2));
  putln;

  putstringln('greater or equal than');
  putboolln(ge(1,2));
  putboolln(ge(2,2));
  putboolln(ge(3,2));
  putln;

  putstringln('equal to');
  putboolln(eq(1,2));
  putboolln(eq(2,2));
  putboolln(eq(3,2));
  putln;

  putstringln('not equal to');
  putboolln(ne(1,2));
  putboolln(ne(2,2));
  putboolln(ne(3,2));
  putln;

end.
