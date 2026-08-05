var
  r: packed record
       k: 0..7;
       b: packed array[0..9] of
            packed record a,b,c,d: boolean end;
     end;
  i: integer;

procedure foo; external;
procedure foo;
begin
  r.b[i].a := false;
  r.b[i].b := true;
  r.b[i].c := true;
  r.b[i].d := false;
end;
begin
  i := 1;
  foo;
  writeln('r.b[i].a expect false ', r.b[i].a);
  writeln('r.b[i].b expect true ', r.b[i].b);
  writeln('r.b[i].c expect true ', r.b[i].c);
  writeln('r.b[i].d expect false ', r.b[i].d);
end.
