{*****************************************************************************
 * A Pascal quicksort.
 *****************************************************************************}
program sort(input, output);

  const
    maxelts = 10; { max array size. }

  type 
    intarrtype = array [1..maxelts] of integer;

  var
    i, j, tmp, size: integer;
    arr: intarrtype;

  %include 'testlib';

  function rand:integer; external;

  procedure initarray(var a: intarrtype);
    var i: integer;

    begin
      for i := 1 to maxelts do
        a[i] := rand mod 256;
    end;

    procedure quicksort(var arr: intarrtype);

      procedure quicksortrecur(start, stop: integer);

      { this does the actual work of the quicksort.  it takes the
        parameters which define the range of the array to work on,
        and references the array as a global.
      }
        var
          m: integer;
          splitpt: integer; { the location separating the high and low parts. }

          function split(start, stop: integer): integer;

          { the quicksort split algorithm.  takes the range, and
            returns the split point.
          }
            var
              left, right: integer;       { scan pointers. }
              pivot: integer;             { pivot value. }
t: integer;
            procedure swap(var a, b: integer);

            { interchange the parameters. }

              var
                t: integer;
              begin
                t := a;
                a := b;
                b := t
              end;

            begin { split }
              { set up the pointers for the hight and low sections, and
                get the pivot value. }
              pivot := arr[start];
              left := start + 1;
              right := stop;

              { look for pairs out of place and swap 'em. }
              while left <= right do begin
                while (left <= stop) and (arr[left] < pivot) do
                  left := left + 1;
                while (right > start) and (arr[right] >= pivot) do
                  right := right - 1;
                if left < right then 
begin
t := arr[left];
arr[left] := arr[right];
arr[right] := t;
end;
{
                  swap(arr[left], arr[right]);
}
              end;

              { put the pivot between the halves. }
t := arr[start];
arr[start] := arr[right];
arr[right] := t;
{
              swap(arr[start], arr[right]);
}

              split := right
            end;

        begin { quicksortrecur }
          { if there's anything to do... }
          if start < stop then begin
            splitpt := split(start, stop);
            quicksortrecur(start, splitpt-1);
            quicksortrecur(splitpt+1, stop);
          end
        end;
                    
      begin { quicksort }
        quicksortrecur(1, maxelts)
      end;

    begin
putstringln('init');
        initarray(arr);
putstringln('sort');
        quicksort(arr);
{
putstringln('print');
}
        for i := 1 to maxelts do
          putintln(arr[i]);
    end.
