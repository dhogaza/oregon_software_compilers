function oddf(i:integer): boolean;

begin
  oddf := odd(i);
end;

function absf(i:integer):integer;

begin
  absf := abs(i);
end;

begin
  writeln('odd(1): ', oddf(1):1);
  writeln('odd(4): ', oddf(4):1);
  writeln('odd(65536): ', oddf(65536):1);
  writeln('odd(1000001): ', oddf(1000001):1);

  writeln('abs(1): ', absf(1):1);
  writeln('abs(65535): ', absf(65535):1);
  writeln('abs(-1): ', absf(-1):1);
  writeln('abs(-100000000): ', absf(100000000):1);
end.
