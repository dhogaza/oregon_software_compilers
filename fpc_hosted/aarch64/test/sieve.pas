
{       Sieve of Eratosthenes benchmark      }
 
program sieve;
const
  SIZE = 8190;
  ITERMAX = 1;

var
  flags : array [0..SIZE] of boolean;
  i, prime, k, count, iter : integer;
begin
  for iter := 1 to ITERMAX do begin
    count := 0;
    for i := 0 to SIZE do 
       flags[i] := true;
    for i := 0 to SIZE do
      if flags[i] then begin
        prime := i + i + 3;
writeln(prime);
        k := i + prime;
        while k <= SIZE do begin
          flags[k] := false;
          k := k + prime;
        end; { while }
        count := count + 1;
      end; { if } 
  end; { for }
  writeln(count,' iterations.');
end. { sieve }

