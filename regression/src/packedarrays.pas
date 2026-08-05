var
  r: packed record
       k: 0..7;
       b: packed array[0..9] of
            packed record a,b,c,d: boolean end;
     end;
  i: integer;
  a: packed array [0..9] of boolean;
  a1: packed array [0..9] of 0..15;

procedure foo; external;
procedure foo;
begin
  r.b[i].a := false;
  r.b[i].b := true;
  r.b[i].c := true;
  r.b[i].d := false;
  a[i] := true; a[i + 1] := false;
  a1[i] := 0; a1[i + 1] := 7; a1[i + 2] := 15;
end;
begin
  i := 1;
  foo;
  writeln('r.b[i].a expect false ', r.b[i].a);
  writeln('r.b[i].b expect true ', r.b[i].b);
  writeln('r.b[i].c expect true ', r.b[i].c);
  writeln('r.b[i].d expect false ', r.b[i].d);
  writeln('a[i] expect true ', a[i]);
  writeln('a[i + 1] expect false ', a[i + 1]);
  writeln('a1[i] expect 0' , a1[i]);
  writeln('a1[i + 1] expect 7', a1[i + 1]);
  writeln('a1[i + 2] expect 15', a1[i + 2]);
end.
