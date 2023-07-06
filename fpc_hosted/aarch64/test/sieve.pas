{$noindexcheck,norangecheck,nopointercheck,nostackcheck}
{$nowalkback}

{       Sieve of Eratosthenes benchmark      }
 
program sieve;
const
  SIZE = 1000;
  ITERMAX = 1000000;

var
  flags : array [0..SIZE] of boolean;
 
%include 'testlib';

procedure foo; external;

procedure p;
var
  i, prime, k, count, iter : integer;
begin
  for iter := 1 to ITERMAX do begin
    count := 0;
    for i := 0 to SIZE do 
       flags[i] := true;
    for i := 0 to SIZE do
      if flags[i] then begin
        prime := i + i + 3;
        k := i + prime;
        while k <= SIZE do begin
          flags[k] := false;
          k := k + prime;
        end;
        count := count + 1;
      end;
  end;
  putintln(count);
end;

begin
  p;
end. { sieve }

