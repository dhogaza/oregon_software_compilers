type ar = array [1..10, 1..10] of integer;
var a: ar;
    i,j: 1..10;
    k: integer;

procedure phooey;
 var j:integer;
 procedure p1;

   procedure p2;
   begin j := 0; j := k; p1; phooey; end;

 begin p2; phooey; end;

begin
  p1;
  i := i * 4;
  i := i div 8;
  i := i mod 8;
end;

begin
  a[1, 1] := 3;
  phooey;
end.
