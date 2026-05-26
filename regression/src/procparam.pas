procedure ext(i: integer); external;

function f(i: integer):boolean;
begin
  f := odd(i);
end;

procedure ext;

begin
  writeln('ext! ',i);
end;

procedure funcparam(function param(i:integer): boolean);
  var b: boolean;
begin
  writeln('in funcparam ');
  writeln(param(1));
end;

procedure procparam(i: integer; procedure param(i:integer); j: integer);
begin
  writeln(i);
  param(1);
  writeln(j);
end;

procedure p0;

  procedure p1;
    var j: integer;

     procedure upref(i: integer);
     begin
       writeln('local! ', i, ' up one level! ', j);
     end;

   begin
     j := 5;
     funcparam(f);
     procparam(1, upref, 2);
   end;

begin
  p1;
end;

begin
  p0;
  procparam(3, ext, 4);
  funcparam(f);
end.

