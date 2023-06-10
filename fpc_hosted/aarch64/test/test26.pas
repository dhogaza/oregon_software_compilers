var a,b: packed array [1..10] of char;

procedure p;
  begin
    a := b;
  end;

procedure p2;
  var
    s: string[10];

  begin
    s := 'abcdef';
  end;

procedure p1;
  begin
    a := '0123456789';
  end;

begin end.
