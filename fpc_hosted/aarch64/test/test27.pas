{$nomain}
{ value conformant array, test pushing of copy on stack
  with the paramter pointing to it.
}

var a:array[2..20] of integer;

procedure foo(a:array[i..j: integer] of integer);
begin
{
  a[i] := j;
  a[j] := i;
}
end;

procedure bar;
begin
foo(a);
end;
