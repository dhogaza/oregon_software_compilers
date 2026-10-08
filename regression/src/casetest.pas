procedure caseotherwise(i:integer);

begin
  case i of
    3: writeln('three');
    20,21,22,23,24,25,26,27,28,29,30: writeln('20..30');
    40,42,44,46,48,50,52:writeln('jump table');
    otherwise writeln('otherwise ', i:1);
  end;
end;

procedure caseerror(i:integer);

begin
  case i of
    3: writeln('three');
    20,21,22,23,24,25,26,27,28,29,30: writeln('20..30');
    40,42,44,46,48,50,52:writeln('jump table');
  end;
end;

begin

  writeln('test single label compare, label range compare, jump table');

  writeln; writeln('otherwise...'); writeln;
  write('single label compare: '); caseotherwise(3);
  write('range of labels compare: '); caseotherwise(25);
  write('jump table: '); caseotherwise(50);
  write('trigger otherwise: '); caseotherwise(41);

  writeln; writeln('error...'); writeln;
  write('single label compare: '); caseerror(3);
  write('range of labels compare: '); caseerror(25);
  write('jump table: '); caseerror(50);
  write('trigger error: '); caseerror(41);

end.
