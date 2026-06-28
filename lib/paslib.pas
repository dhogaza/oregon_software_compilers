{$nocheck,nomain}

const
  _p_maxstringlen = 255;

type

  { For faking out C strings and passing packed array strings to
    Pascal library procs.
  }

  _p_charptr = ^char; 
  _p_intptr = ^integer;
  _p_stringarray = array [0..maxint] of char;
  _p_stringarrayp = ^_p_stringarray;
  _p_string = string[_p_maxstringlen];
  _p_stringptr = ^_p_string;
  _p_stringrange = 0.._p_maxstringlen;
  _p_address = int64; {for now}
  _p_addressptr = ^_p_address; {for now}
  _p_streamptr = ^integer; {for now}

  { The first three must be matched in the code generator. These
    are taken from the MC68000 library and not all will apply
    to our files.
  }
  _p_filestatusenum = (
    _p_def,     { current data defined (lazy I/O) }
    _p_eof,     { at end of file }
    _p_eoln,    { at end of line }
    _p_text,    { set for text file, clear for binary file }
    _p_inp,     { input operations allowed ( reset() ) }
    _p_out,     { output operations allowed ( rewrite() ) }
    _p_newl,    { new input line should be read }
    _p_int,     { interactive device (for lazy I/O }
    _p_perm,    { file can't be closed (input and output) }
    _p_ran,     { seek() allowed }
    _p_noerror, { don't trap on error }
    _p_necho,   { echo is on }
    _p_sngl,    { single character mode }
    _p_cont     { contiguous file });
  _p_filestatustype = set of _p_filestatusenum;

  _p_filerecordptr = ^_p_filerecord;
  _p_filerecord =
    record
      currentp: _p_charptr; { get byte, get a byte, get a byte byte byte }
      status: _p_filestatustype; { see above }
      nextfile: _p_filerecordptr; { pointer to next file or nil (for closerange()) }
      filevar: _p_addressptr; { back pointer to file var not sure how to do this yet }
      err: integer; { available to the caller if _p_noerror is set }
      streamp: _p_addressptr; { pointer to the unix stream }
    end;

{$own='_p_paslib'}

var
  _p_filelist: _p_filerecordptr;

{glibc}
procedure exit(const code: integer); nonpascal;
procedure putchar(const ch: char); nonpascal;
function malloc(const size: int64): _p_charptr; nonpascal;
procedure free(const p: _p_charptr); nonpascal;

{ pascal-2 lib declarations }

{ errors }
procedure _p_caseerr; external;

{ I/O }
procedure _p_dumpfilelist; external;
procedure _p_close(filevar: _p_addressptr); external;
procedure _p_reset(filevar: _p_addressptr; const size:integer; const str1ptr, str2ptr:
                   _p_stringptr; errptr: _p_intptr); external;
procedure _p_rewrite(filevar: _p_addressptr; const size:integer; const str1ptr, str2ptr:
                     _p_stringptr; errptr: _p_intptr); external;
procedure _p_wtc_o(ch: char; width: integer); external;
procedure _p_wti_o(i: integer; width: integer); external;
procedure _p_wtb_o(b: boolean; width: integer); external;
procedure _p_wts_o(const str: _p_stringarray; length: integer; width: integer); external;
procedure _p_wtln_o; external;

{ strings }
function _p_pos(const src, match: _p_string): integer; external;
function _p_copy(const src:_p_string; pos, count: integer): _p_string; external;
function _p_trim(const src:_p_string):_p_string; external;
function _p_trimleft(const src: _p_string):_p_string; external;
function _p_trimright(const src: _p_string):_p_string; external;

{ dynamic memory }
procedure _p_new(var p: _p_charptr; size: int64); external;
procedure _p_dispos(var p: _p_charptr; size: int64); external;

{ pascal-2 library implementations }

{ String library.
}

procedure _p_arraytostring(var dst: _p_string; const src: _p_stringarrayp;
                           len: _p_stringrange);

{ The front end passes filenames as a dataptr, length pair rather than a string
  for historical reasons related to pascal "strings" being packed arrays of
  chars..
}

var
  i: 0 .. 255;

begin
  { Remember Delphi short strings truncate rather than throw error }
  if len > _p_maxstringlen then
    len := _p_maxstringlen;
  i := 0;
  while i < len do
    begin
    dst[i + 1] := src^[i];
    i := i + 1;
    end;
  dst[i + 1] := chr(0);
  dst[0] := chr(len);
end;

procedure _p_cstringtostring(var dst: _p_string; src: _p_charptr);

{ Will probably return cstrings into packed arrays of chars making this
  unused.  This will truncate overly long C strings.
}

var
  i: 0 .. 255;
  c: record
      case boolean of
        false: (str: ^_p_string);
        true: (a: _p_stringarrayp);
    end;

begin
  c.a := loophole(_p_stringarrayp, src);
  i := 0;
  while ((i < 255) and (c.a^[i] <> chr(0))) do
    begin
    dst[i + 1] := c.a^[i];
    i := i + 1;
    end;
  dst[i + 1] := chr(0);
  dst[0] := chr(i);
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

function _p_copy;

var
  len, copypos: integer;
  copied: _p_string;

begin {_p_copy}
  len := length(src);
  if pos + count - 1 > len then
    count := len - pos + 1;
  if (count < 0) or (pos < 1) then
    count := 0;
  copied[0] := chr(count);
  copypos := 1;
  while count > 0 do
    begin
    copied[copypos] := src[pos];
    pos := pos + 1;
    copypos := copypos + 1;
    count := count - 1;
    end;
  _p_copy := copied;
end {_p_copy};

function _p_trim;

var
  ltrim,rtrim,len,i: integer;
  trimmed: _p_string;

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
  trimmed: _p_string;

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
  trimmed: _p_string;

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

{I/O}

type seekwhence = (SEEK_SET, SEEK_CUR, SEEK_END);

procedure _p_dumpfilelist;

var
  p: _p_filerecordptr;

begin {_p_dumpfilelist}
  writeln('dump file list');
  p := _p_filelist;
  while p <> nil do
    begin
    with p^ do
      writeln('address: ', loophole(_p_address, p):1,
              ' currentp: ', loophole(_p_address, currentp):1,
              ' status: ', loophole(_p_address, status):1,
              ' nextfile: ', loophole(_p_address, nextfile):1,
              ' filevar: ', loophole(_p_address, filevar):1,
              ' streamp: ', loophole(_p_address, streamp):1,
              ' err: ',err:1);
      p := p^.nextfile;
      end;
  writeln('end dump file list');
end {_p_dumpfilelist};

function _p_filep(filevar: _p_addressptr): _p_filerecordptr;

{ check the list of open files to see if this file is already open.
}

var
  p: _p_filerecordptr;

begin {_p_filep}
  p := _p_filelist;
  while (p <> nil) and (p^.filevar <> filevar) do
    p := p^.nextfile;
  _p_filep := p;
end {_p_filep};

procedure _p_addfile(filevar: _p_addressptr);

{ Add a new filerecord to the list of files.  _p_filelist will point
  to the new entry. Caller guarantees that it doesn't already exist
  in the list of active files.
}

var
  p: _p_filerecordptr;

begin {_p_addfile}
  new(p);
  filevar^ := loophole(_p_address, p);
  p^.nextfile := _p_filelist;
  p^.currentp := nil;
  p^.status := [];
  p^.filevar := filevar;  
  p^.err := 0;
  p^.streamp := nil;
  _p_filelist := p;
end {_p_addfile};

procedure _p_removefile(var filep: _p_filerecordptr);

{ Remove a file from the list of files.  f is guaranteed by the caller
  to exist.
}

var
  curp, prevp: _p_filerecordptr;

begin {_p_removefile}
  prevp := nil;
  curp := _p_filelist;
  while curp <> filep do
    begin
    prevp := curp;
    curp := curp^.nextfile;
    end;
    curp := curp^.nextfile;
  if prevp = nil then
    _p_filelist := filep^.nextfile
  else
    prevp^.nextfile := filep^.nextfile;
  filep^.filevar^ := loophole(_p_address, nil);
  dispose(filep);
end {_p_removefile};

procedure _p_close;

{ Close a file and remove it from the file list and set filevar
  to nil.
}

var
  p: _p_filerecordptr;

begin {_p_close}
  p := _p_filep(filevar);
  if p <> nil then
    begin
    { close the file, of course}
    _p_removefile(p);
    end;
end {_p_close};

procedure _p_open(reset: boolean; filevar: _p_addressptr; size:integer; str1ptr, str2ptr:
                   _p_stringptr; errptr: _p_intptr);

var p: _p_filerecordptr;

begin
  if _p_filep(filevar) = nil then
    begin
    _p_addfile(filevar);
    p := _p_filep(filevar);
    end;
end;

procedure _p_reset;

begin
  _p_open(true, filevar, size, str1ptr, str2ptr, errptr);
end;

procedure _p_rewrite;

begin
  _p_open(false, filevar, size, str1ptr, str2ptr, errptr);
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
