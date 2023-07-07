program test;

%include 'testlib';

procedure phooey(i: integer);
 var j:integer;

 procedure p11;
 begin
   putstringln('p11');
   putintln(j);
   putintln(i);
 end;

 procedure p1;

   procedure p2;
   begin
     putstringln('p2');
     putintln(j);
     putintln(i);
     p11;
    end;

 begin p2; end;

begin
  j := 3;
  p1;
  putstringln('phooey');
  putintln(j);
end;

begin
  phooey(10);
end.
