%include 'paslib'
{$main}

{ regression testing script will flag any differendes in assembly
  output, which may or may not represent bugs in the generated code.
  So we will do some simple testing of the library here, was well.
}

type
 rec =
   record
     a,b: integer;
   end;
 recptr = ^rec;

var i:integer;
  ch: char;
  a: packed array [1..3] of char;
  s: string[255];
  recp: recptr;

begin
  a := 'xyz';
  s := a;
  write('y', 'z');
  i := 3;
  write('a':i);
  write(100:4);
  writeln('!');
  writeln('abc':1, a:4, s:4);
  writeln(false, true, false:1, true:1, false: 10, true: 10);

  new(recp);
  recp^.a := 10;
  recp^.b := 20;
  writeln(recp^.a, recp^.b);
  dispose(recp);

end.
