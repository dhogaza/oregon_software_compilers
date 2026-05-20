%include 'testlib'

function oddf(i:integer): boolean;

begin
  oddf := odd(i);
end;


function absf(i:integer):integer;

begin
  absf := abs(i);
end;

begin
  putstring('odd(1): '); putboolln(oddf(1));
  putstring('odd(4): '); putboolln(oddf(4));
  putstring('odd(65536): '); putboolln(oddf(65536));
  putstring('odd(1000001): '); putboolln(oddf(1000001));

  putstring('abs(1): '); putintln(absf(1));
  putstring('abs(65535): '); putintln(absf(65535));
  putstring('abs(-1): '); putintln(absf(-1));
  putstring('abs(-100000000): '); putintln(absf(100000000));
end.
