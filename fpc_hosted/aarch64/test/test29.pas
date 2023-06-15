{ for fpc primarily }

type atype = array [1..5000] of char;
var a: atype;
  b: boolean;

procedure p(a: atype);
begin a[3] := 'c'; end;

procedure p1;
begin p(a);p(a); end;

begin end.

