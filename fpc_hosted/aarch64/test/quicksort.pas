{*****************************************************************************
 * A Pascal quicksort.
 *****************************************************************************}
program sort(input, output);
    const
        { max array size. }
        maxelts = 50;
    type 
        { type of the element array. }
        intarrtype = array [1..maxelts] of integer;

    var
        { indexes, exchange temp, array size. }
        i, j, tmp, size: integer;

        { array of ints }
        arr: intarrtype;

    %include 'testlib';

    function rand:integer; external;

    { read in the integers. }
    procedure readarr(var size: integer; var a: intarrtype);
      var i: integer;
        begin
          for i := 1 to size do
            a[i] := rand mod 256;
        end;

    { use quicksort to sort the array of integers. }
    procedure quicksort(size: integer; var arr: intarrtype);
        { this does the actual work of the quicksort.  it takes the
          parameters which define the range of the array to work on,
          and references the array as a global. }
        procedure quicksortrecur(start, stop: integer);
            var
                m: integer;

                { the location separating the high and low parts. }
                splitpt: integer;

            { the quicksort split algorithm.  takes the range, and
              returns the split point. }
            function split(start, stop: integer): integer;
                var
                    left, right: integer;       { scan pointers. }
                    pivot: integer;             { pivot value. }

                { interchange the parameters. }
                procedure swap(var a, b: integer);
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

                    { this is how you return function values in pascal.
                      yeccch. }
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
            quicksortrecur(1, size)
        end;

    begin
        { read }
        readarr(size, arr);

        { sort the contents. }
        quicksort(size, arr);

        { print. }
        for i := 1 to size do
          putintln(arr[i]);
    end.
