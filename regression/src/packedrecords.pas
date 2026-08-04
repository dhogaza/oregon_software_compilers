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
begin
 b := true;
 p;
end.
