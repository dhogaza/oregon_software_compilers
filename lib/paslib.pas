{$nocheck,nomain}
type

  { For faking out C strings and passing packed array strings to
    Pascal library procs.
  }

  _p_charptr = ^char; 
  _p_stringarray = array [0..maxint] of char;
  _p_stringarrayp = ^_p_stringarray;
  _p_shortstring = string[255];

{glibc}
procedure exit(const code: integer); nonpascal;
procedure putchar(const ch: char); nonpascal;
function malloc(const size: int64): _p_charptr; nonpascal;
procedure free(const p: _p_charptr); nonpascal;

{ pascal-2 lib declarations }

procedure _p_caseerr; external;
function _p_pos(const src, match: _p_shortstring): integer; external;
function _p_trim(const src:_p_shortstring):_p_shortstring; external;
function _p_trimleft(const src: _p_shortstring):_p_shortstring; external;
function _p_trimright(const src: _p_shortstring):_p_shortstring; external;
procedure _p_wtc_o(ch: char; width: integer); external;
procedure _p_wti_o(i: integer; width: integer); external;
procedure _p_wtb_o(b: boolean; width: integer); external;
procedure _p_wts_o(const str: _p_stringarray; length: integer; width: integer); external;
procedure _p_wtln_o; external;
procedure _p_new(var p: _p_charptr; size: int64); external;
procedure _p_dispos(var p: _p_charptr; size: int64); external;

{ pascal-2 library implementations }

{ String library.  The two consversion routines might be replaced
  by compiler-generated code.
}

procedure _p_toshortstring(var s: _p_shortstring; p: _p_charptr);

var
  i: 0 .. 255;
  c: record
      case boolean of
        false: (str: ^_p_shortstring);
        true: (a: _p_stringarrayp);
    end;

begin
  c.a := loophole(_p_stringarrayp, p);
  i := 0;
  while ((i < 255) and (c.a^[i] <> chr(0))) do
    begin
    s[i + 1] := c.a^[i];
    i := i + 1;
    end;
  s[i + 1] := chr(0);
  s[0] := chr(i);
end;
    
function _p_cstring(s: _p_shortstring): _p_charptr;
var
  c: record
      case boolean of
        false: (str: ^_p_shortstring);
        true: (a: _p_stringarrayp);
    end;

begin
  c.str := ref(s);
  _p_cstring := ref(c.a^[1]);
end;

function _p_pos;

var
  i, j, k, srclen, matchlen: integer;
  found: boolean;
 
begin
  i := 0;
  srclen := length(src);
  matchlen := length(match);

  found := false;
  while not found and (i < srclen) do
    begin
    i := i + 1;
    found := src[i] = match[1];
    if found then
      begin
      j := 1;
      k := i;
      while found and (k < srclen) and (j < matchlen) do
        begin
        k := k + 1;
        j := j + 1;
        found := src[k] = match[j];
        end;
      end;
    end;

  if found then _p_pos := i
  else _p_pos := 0
end;

{ These string functions depend on string assignment to append
  the null character to the resulting string.  Naughty but I
  know that the code generator is very protective of the integrity
  of strings.
}

function _p_trim;

var
  ltrim,rtrim,len,i: integer;
  trimmed: _p_shortstring;

begin {_p_trim}
  rtrim := length(src);
  while (rtrim > 0) and (src[rtrim] <= chr(32)) do
    rtrim := rtrim - 1;
  ltrim := 1;
  while (ltrim < rtrim) and (src[ltrim] <= chr(32)) do
    ltrim := ltrim + 1;
  len := rtrim - ltrim + 1;
  for i := 1 to len do
    begin
    trimmed[i] := src[ltrim];
    ltrim := ltrim + 1; 
    end;
  trimmed[0] := chr(len);
  _p_trim := trimmed;
end {_p_trim};

function _p_trimleft;

var
  ltrim,len,i: integer;
  trimmed: _p_shortstring;

begin {_p_trimleft}
  len := length(src);
  ltrim := 1;
  while (ltrim <= len) and (src[ltrim] <= chr(32)) do
    ltrim := ltrim + ltrim;
  len := len - ltrim + 1;
  trimmed[0] := chr(len);
  for i := 1 to len do
    begin
    trimmed[i] := src[ltrim];
    ltrim := ltrim + 1;
    end;
  _p_trimleft := trimmed;
end {_p_trimleft};

function _p_trimright;

var
  rtrim,i: integer;
  trimmed: _p_shortstring;

begin {_p_trimright}
  rtrim := length(src);
  while (rtrim > 0) and (src[rtrim] <= chr(32)) do
    rtrim := rtrim - 1;
  trimmed[0] := chr(rtrim);
  for i := 1 to rtrim do
    trimmed[i] := src[i];
  _p_trimright := trimmed;
end {_p_trimright};
    
procedure _p_caseerr;
  begin
    writeln('case error');
    exit(1);
  end;

procedure _p_wtb_o;

  var i: integer;

  begin
    for i := 5 + ord(not b) to width do
      write(' ');
   if b then
     write('true')
   else
     write('false');
  end;

procedure _p_wtc_o;

  var i: integer;

  begin
    for i := 2 to width do putchar(' ');
    putchar(ch);
  end;

procedure _p_wti_o;

  var
    digits: packed array [0..18] of char;
    j: integer;
    count: integer;
    minus: boolean;

  begin
    count := 0;
    minus := i < 0;
    if minus then
    begin
      i := -i;
      count := count + 1;
    end;

    j := 0;
    repeat
      digits[j] := chr(i mod 10 + ord('0'));
      j := j + 1;
      i := i div 10;
      count := count + 1;
    until i = 0;

    for count := count + 1 to width do
      putchar(' ');

    if minus then
      putchar('-');

    repeat
      j := j - 1;
      putchar(digits[j]);
    until j = 0;

  end;

procedure _p_wts_o;

  var i: integer;

  begin
    for i := 0 to width - length - 1 do
      putchar(' ');
    for i := 0 to length - 1 do
      putchar(str[i]);
  end;

procedure _p_wtln_o;

  begin
    putchar(chr(10));
  end;

procedure _p_new;
begin
  p := malloc(size);
end;

procedure _p_dispos;
begin
  free(p);
  p := nil;
end;
