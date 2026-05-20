var a: integer;

procedure bar;

var i,j,k,l: integer;

begin
  i := 65536;
  j := i + 4095;
  k := a + 4095;
  l := k + 4096;
  writeln('i: ', i:1);
  writeln('j: ', j:1);
  writeln('k: ', k:1);
  writeln('l: ', l:1);
  writeln('a: ', a:1);
end;


procedure foo;

var i,j,k,l: integer;

  { defeat constant propagation and print the actual vars }
  procedure foo2;

  begin
    writeln('i: ', i:1);
    writeln('j: ', j:1);
    writeln('k: ', k:1);
    writeln('l: ', l:1);
    writeln('a: ', a:1);
  end;

begin
  i := 65536;
  j := i + 4095;
  k := a + 4095;
  l := k + 4096;
  foo2;
end;

begin
  a := 1;
  bar;
  foo;
 end.
