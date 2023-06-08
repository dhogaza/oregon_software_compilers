{$nomain}
procedure foo(var a:array[i..j: integer] of integer);
begin
  a[i] := j;
  a[j] := i;
end;

procedure bar;
var a:array[2..20] of integer;
begin
foo(a);
end;
