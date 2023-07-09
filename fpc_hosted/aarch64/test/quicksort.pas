{*****************************************************************************
 * A Pascal quicksort.
 *****************************************************************************}
program sort(input, output);

  const
    maxelts = 100000; { max array size. }

  type 
    intarrtype = array [1..maxelts] of integer;

  var
    i: integer;
    sorted: boolean;
    arr: intarrtype;

  %include 'testlib';

  procedure initarray(var a: intarrtype);
    var i: integer;

    begin
      for i := 1 to maxelts do
       a[i] := maxelts - i;
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
                  swap(arr[left], arr[right]);
              end;

              { put the pivot between the halves. }
              swap(arr[start], arr[right]);

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
        putstring('sorting ');
        putintln(maxelts);
        initarray(arr);
        quicksort(arr);
        sorted := true;
        i := 2;
        while sorted and (i <= maxelts) do
          begin
            sorted := arr[i] >= arr[i - 1];
            i := i + 1;
          end;
        putstring('result is sorted = ');
        putboolln(sorted);
    end.
