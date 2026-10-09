{$check}
procedure rangechecks;

  { lower bound zero and lower and upper bounds equal are
    special cases ...
  }

  var
    v1: 0..10;
    v2: 1..1;
    v3: -256..255;


  procedure pv1(i: integer);
    begin
      writeln(i);
      v1 := i;
    end;

  procedure pv2(i: integer);
    begin
      writeln(i);
      v2 := i;
    end;

  procedure pv3(i: integer);
    begin
      writeln(i);
      v3 := i;
    end;

  begin
    writeln('variable assignments');
    writeln('0..10');
    pv1(0);
    pv1(10);
    writeln;
    writeln('1..1');
    pv2(1);
    writeln;
    writeln('-256..255');
    pv3(-256);
    pv3(255);
  end;

procedure subscriptchecks;

  var
    a1: array [1..10] of boolean;
    a2: array [-10..-1] of boolean;
    a3: array [65536..70000] of boolean;

  procedure pa1(i:integer);
    begin
    writeln(i);
    a1[i] := true;
    end;

  procedure pa2(i:integer);
    begin
    writeln(i);
    a2[i] := true;
    end;

  procedure pa3(i:integer);
    begin
    writeln(i);
    a3[i] := true;
    end;

  procedure c(i:integer; var a: array[lower..upper:integer] of boolean);
    begin
    writeln(i, lower, upper);
    a[i] := true;
    end;

  begin
    writeln('static arrays');
    writeln('1..10');

    pa1(1);
    pa1(10);

    writeln('-10..-1');
    pa2(-10);
    pa2(-1);

    writeln('65536..700000');
    pa3(65536);
    pa3(70000);

    writeln;
    writeln('conformant arrays');

    c(1, a1);
    c(10, a1);

    c(-10, a2);
    c(-1, a2);

    c(65536, a3);
    c(70000, a3);

    writeln('bombing!');
    c(5, a3);
  end;

begin
  rangechecks;
  subscriptchecks;
end.
