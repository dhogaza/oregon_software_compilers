{$nomain}
procedure foo(var a:array[i..j: integer; c..d: char] of integer);
begin
  a[i, d] := j;
  a[j, c] := i;
end;

procedure bar;
var a:array[2..20, 'a'..'z'] of integer;
begin
foo(a);
end;
