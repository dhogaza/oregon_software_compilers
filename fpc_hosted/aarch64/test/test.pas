program test;
type ar = array[1..5] of integer;
const arc = ar(16#10203040,16#22334455,3,4,5);
var a: ar;
    i,j: 1..10;
    k: integer;
    l: set of char;

procedure phooey;
 var j:integer;
 procedure p1;

   procedure p2;
   begin j := 0; p1  end;

 begin p2; end;

begin p1; end;

begin
a := arc;
l := ['a','z','0'];
writeln('ab');
end.
