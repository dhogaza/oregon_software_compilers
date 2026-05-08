
  function alignmentof(i, j: integer): alignmentrange;

  var a, a1: alignmentrange;

  begin
    a := 1;
    a1 := (i or j) mod 16;
    while (a1 and 1) = 0  do
      begin
      a := a * 2;
      a1 := a1 div 2;
      end;
    alignmentof := a;
  end;

