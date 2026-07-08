{$nocheck,nomain}

const
  _p_maxstringlen = 255;

type

  { For faking out C strings and passing optional packed array string parameters
    to Pascal library procs.  The latter are passed as nil if they aren't given
    as part of the parameter list.
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
  _p_streamptr = ^int64; {for now}

  { The first three enum valued must be matched in the code generator. The
    others are taken from the MC68000 library and not all will apply to our files.
  }

  _p_filestatusenum = (
    _p_def,     { current data defined (lazy I/O) }
    _p_eof,     { at end of file }
    _p_eoln,    { at end of line }
    _p_text,    { set for text file, clear for binary file }
    _p_read,     { input operations allowed ( reset() ) }
    _p_write,     { output operations allowed ( rewrite() ) }
    _p_newl,    { new input line should be read }
    _p_int,     { interactive device (for lazy I/O }
    _p_perm,    { file can't be closed (input and output) }
    _p_ran,     { seek() allowed }
    _p_noerror, { don't trap on error }
    _p_necho,   { echo is on }
    _p_sngl,    { single character mode }
    _p_cont     { contiguous file });
  _p_filestatustype = set of _p_filestatusenum;

  _p_fileinfoptr = ^_p_fileinfo;
  _p_fileinfo =
    record
      bufferp: _p_charptr;
      status: _p_filestatustype; { see above }
      ch: char; {for text files unless I just read directly to the caller}
      size: integer;
      nextfile: _p_fileinfoptr; { pointer to next file or nil }
      filevar: _p_addressptr; { back pointer to file var }
      err: integer; { available to the caller if _p_noerror is set }
      streamp: _p_addressptr; { pointer to the unix stream }
      filename: _p_string; { for error messages, primarily }
      flags: _p_string; { also for error messages, primarily }
    end;

{$own='_p_paslib'}

var
  _p_filelist: _p_fileinfoptr;

{glibc}

type
  _p_seekwhence = (_p_seek_set, _p_seek_cur, _p_seek_end);

procedure exit(const code: integer); nonpascal;
procedure putchar(const ch: char); nonpascal;
function malloc(const size: integer): _p_charptr; nonpascal;
procedure free(const p: _p_charptr); nonpascal;
function remove(const filename: _p_charptr): integer; nonpascal;
function fopen(const filename, flags: _p_charptr): _p_streamptr; nonpascal;
function fclose(const streamp: _p_addressptr): integer; nonpascal;
function ftell(streamp: _p_addressptr): integer; nonpascal;
function fseek(const streamp: _p_addressptr; pos: integer;
               whence: _p_seekwhence): integer; nonpascal;
function fread(bufferp: _p_charptr; size: integer; count: integer;
               streamp: _p_addressptr): integer; nonpascal;
function fwrite(bufferp: _p_charptr; size: integer; count: integer;
                streamp: _p_addressptr): integer; nonpascal;
function fputc(ch: char; streamp: _p_addressptr): integer; nonpascal;
function fgetc(streamp: _p_addressptr): integer; nonpascal;
function ftruncate(fd: integer; size: integer): integer; nonpascal;
function fileno(streamp: _p_addressptr): integer; nonpascal;
function feof(streamp: _p_addressptr): boolean; nonpascal;
function ferror(streamp: _p_addressptr): integer; nonpascal;

{ pascal-2 lib declarations }

{ errors }
procedure _p_caseerr; external;

{ I/O }
procedure _p_dumpfilelist; external;
procedure _p_close(filevar: _p_addressptr); external;
procedure _p_clsall; external;
procedure _p_clsrng(firstfilevar, lastfilevar: _p_addressptr); external;
procedure _p_reset(filevar: _p_addressptr; const size:integer; const str1ptr, str2ptr:
                   _p_stringptr; errptr: _p_intptr); external;
procedure _p_rewrite(filevar: _p_addressptr; const size:integer; const str1ptr, str2ptr:
                     _p_stringptr; errptr: _p_intptr); external;
procedure _p_seek(filevar: _p_addressptr; const offset: integer); external;
procedure _p_define(filevar: _p_addressptr); external;
procedure _p_get(filevar: _p_addressptr); external;
procedure _p_put(filevar: _p_addressptr); external;
procedure _p_delete(filevar: _p_addressptr); external;
function _p_rdc(filevar: _p_addressptr): char; external;
function _p_rdi(filevar: _p_addressptr): integer; external;
function _p_rdd(filevar: _p_addressptr): double; external;
function _p_rdf(filevar: _p_addressptr): real; external;
procedure _p_rdln(filevar: _p_addressptr); external;
procedure _p_rds(filevar: _p_addressptr); external;
procedure _p_rdxs(filevar: _p_addressptr); external;
function _p_rdc_i: char; external;
function _p_rdi_i: integer; external;
function _p_rdd_i: double; external;
function _p_rdf_i: real; external;
procedure _p_rdln_i; external;
procedure _p_rds_i; external;
procedure _p_rdxs_i; external;
procedure _p_wtc(filevar: _p_addressptr; ch: char; width: integer); external;
procedure _p_wti(filevar: _p_addressptr; i: integer; width: integer); external;
procedure _p_wtb(filevar: _p_addressptr; b: boolean; width: integer); external;
procedure _p_wts(filevar: _p_addressptr; const str: _p_stringarray;
                 length: integer; width: integer); external;
procedure _p_wtln(filevar: _p_addressptr); external;
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
procedure _p_new(var p: _p_charptr; size: integer); external;
procedure _p_dispos(var p: _p_charptr; size: integer); external;

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

procedure _p_liberror(const err: _p_string);

begin
  writeln(err);
  exit(1);
end;

procedure _p_libfileerror(filep: _p_fileinfoptr; const err: _p_string);

begin
  writeln(err, ' on file ', filep^.filename, ':', filep^.flags);
  exit(1);
end;

{ File I/O routines.

  The implementation is lifted from the MC68000 library for both Motorola's
  VERSAdos operating system and our standalone multitasking runtime environment.

  A list of open files is kept which allows us to track if a file operation is
  being executed on an open file or not.  The state of the file is tracked as a
  set of states.

  The Pascal semantics are built on top of streams.

  The code implements "lazy I/O" to read files.  Code is generated to check if
  the buffer value is defined for various operations, and the I/O routines use
  this to decide when to read data from the the stream.

  Pascal semantics are allowed to differentiate between text chars and (binary)
  files of chars.  When reading from a file of char, eoln is not set and nl and cr
  are directly available to the user code.  To deal with text files one generally
  will used the predefined text file type.  Formatted read procedures only work
  with these as does readln.  
}

procedure _p_dumpfilelist;

{ This dumps the list of currently open files.  Very useful for debugging
  purposes.
}

var
  p: _p_fileinfoptr;
  s: _p_filestatusenum;

begin {_p_dumpfilelist}
  writeln('dump file list');
  p := _p_filelist;
  while p <> nil do
    begin
    with p^ do
      begin
      write('address: ', loophole(_p_address, p):1,
            ' bufferp: ', loophole(_p_address, bufferp):1,
            ' status: [');
      for s := _p_def to _p_cont do
        if s in status then
          case s of
            _p_def: write('_p_def,');
            _p_eof: write('_p_eof,');
            _p_eoln: write('_p_eoln,');
            _p_text: write('_p_text,');
            _p_read: write('_p_read,');
            _p_write: write('_p_write,');
            _p_newl: write('_p_newl,');
            _p_int: write('_p_int,');
            _p_perm: write('_p_perm,');
            _p_ran: write('_p_ran,');
            _p_noerror: write('_p_noerror,');
            _p_necho: write('_p_necho,');
            _p_sngl: write('_p_sngl,');
            _p_cont: write('_p_cont,');
          end;
 
      writeln('] nextfile: ', loophole(_p_address, nextfile):1,
              ' filevar: ', loophole(_p_address, filevar):1,
              ' streamp: ', loophole(_p_address, streamp):1,
              ' err: ',err:1,
              ' filename: ',filename);
      p := p^.nextfile;
      end;
  end;
  writeln('end dump file list');
end {_p_dumpfilelist};

function _p_filep(filevar: _p_addressptr): _p_fileinfoptr;

{ check the list of open files to see if this file is already open and
  return a pointer to the file info if it is.  Return nil if not.
}

var
  p: _p_fileinfoptr;

begin {_p_filep}
  p := _p_filelist;
  while (p <> nil) and (p^.filevar <> filevar) do
    p := p^.nextfile;
  _p_filep := p;
end {_p_filep};

function _p_addfile(filevar: _p_addressptr): _p_fileinfoptr;

{ Add a new fileinfo to the list of files.  _p_filelist will point
  to the new entry. Caller must guarantee that it doesn't already exist
  in the list of active files.
}

var
  p: _p_fileinfoptr;

begin {_p_addfile}
  new(p);
  filevar^ := loophole(_p_address, p);
  p^.nextfile := _p_filelist;
  p^.bufferp := nil;
  p^.status := [];
  p^.size := 0;
  p^.filevar := filevar;  
  p^.err := 0;
  p^.streamp := nil;
  _p_filelist := p;
  _p_addfile := p;
end {_p_addfile};

procedure _p_removefile(var filep: _p_fileinfoptr);

{ Remove a file from the list of files.  f is guaranteed by the caller
  to exist.  The caller should close the stream before removing the
  file from the list.
}

var
  curp, prevp: _p_fileinfoptr;

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
  dispose(filep);
end {_p_removefile};

procedure _p_closeonly(filep: _p_fileinfoptr);

{ Close the file and dispose of the buffer but nothing else.  The
  caller is expected to remove it from the list of open files.
}

begin
  if not (_p_perm in filep^.status) then
    begin
    if fclose(filep^.streamp) <> 0 then
      _p_libfileerror(filep, 'fclose failed');
    filep^.filevar^ := loophole(_p_address, nil);
    if (not (_p_text in filep^.status)) and (filep^.bufferp <> nil) then
      dispose(filep^.bufferp);
    end;
end;

procedure _p_close;

{ Close a file and remove it from the file list and set filevar
  to nil.  Since files are automatically closed closed when the scope
  it was opened in exits, this shouldn't really be called by most
  user code.
}

var
  p: _p_fileinfoptr;

begin {_p_close}
  p := _p_filep(filevar);
  if p <> nil then
    begin
    _p_closeonly(p);
    _p_removefile(p);
    end;
end {_p_close};

procedure _p_clsrng;
 
{ When we exit a scope, this procedure will be called with the lower and
  upper bounds of the stack space used in that scope, and file info entries
  with filevar backpointers that lie within that range are closed.

}
var
  curp, prevp, nextp: _p_fileinfoptr;

begin {_p_clsrng}
  prevp := nil;
  curp := _p_filelist;
  while (curp <> nil) do
    begin
    nextp := curp^.nextfile;
    if (loophole(_p_address,firstfilevar) <= loophole(_p_address, curp^.filevar)) and
       (loophole(_p_address, curp^.filevar) <= loophole(_p_address, lastfilevar)) then
      begin
      if prevp = nil then
        _p_filelist := nextp
      else
        prevp^.nextfile := nextp;
      _p_closeonly(curp);
      curp^.filevar^ := loophole(_p_address, nil);
      dispose(curp);
      end
    else
      prevp := curp;
    curp := nextp;
    end;
end {_p_clsrng};

procedure _p_clsall;

{ Called when the main procedure terminates.  It closes all files opened by the
  program that haven't been closed when earlier scoped were exited.  Global files,
  in essence.
}

var
  curp, nextp: _p_fileinfoptr;

begin {_p_clsall}
  curp := _p_filelist;
  while (curp <> nil) do
    begin
    nextp := curp^.nextfile;
    _p_closeonly(curp);
    dispose(curp);
    curp := nextp;
    end;
end {_p_clsall};

{ We will need to deal with passing errors back to the caller when
  asked.  Gotos will be involved.  Currently all errors are fatal.
}

procedure _p_filecommon(filevar: _p_addressptr;
                        const size:integer; {-1 for text, otherwise binary file}
                        const str1ptr, str2ptr: _p_stringptr; {might be nil}
                        errptr: _p_intptr; {might be nil}
                        const defflags:_p_string);

{ The first string parameter points to the base filename.  The second string
  parameter points to an optional file extension and stream flags.

  An example would be "reset('foo', '.ext:r+')". Since the filename does not
  include an extension ".ext" will be appended to it.  "r+" will be passed to
  fopen as the flag string.   The reset and rewrite procedures ensure that flags
  sent to reset are read flags (as in the example) and those sent to rewrite are
  write flags.  In the streams world, "r+" allows both reads and writes but checks
  that the file already exists, while "w+" also allows both but replaces an
  existing file.  Reset defaults to "r" while rewrite defaults to "w".  The code
  automatically adds "b" to the flags if the file is a binary file.

  Not sure what to do about append mode or seek regarding _p_def.
}

var
  filep: _p_fileinfoptr;
  streamp: _p_streamptr;
  filename, str2, ext, flags: _p_string;
  extpos, flagspos: integer;

begin
  if (str1ptr = nil) and (str2ptr <> nil) then
    _p_liberror('Missing file name.');
  filep := _p_filep(filevar);
  if (filep = nil) and (str1ptr = nil) then
    _p_liberror('File name is required to open a new file.');

  { If the file is already open and a file name is provided, close
    it and then do a reset/write with the file name.
  }
  if (filep <> nil) and (str1ptr <> nil) then
    _p_close(filevar);

  { check if the filevar is in the list of open files.
  }

  if _p_filep(filevar) = nil then
    begin
    filename := str1ptr^;
    flags := defflags;
    if str2ptr <> nil then
      begin
      str2 := str2ptr^;
      flagspos := pos(str2, ':');
      if flagspos = 0 then
        ext := str2
      else
        ext := copy(str2, 1, flagspos - 1);
      if pos(filename, '.') = 0 then
        filename := filename + ext;
      if flagspos = length(str2) then
        _p_liberror('empty flags parameter for ' + filename);
      flags := copy(str2, flagspos + 1, length(str2));
      if (defflags[1] <> flags[1]) then
        _p_liberror('flags incompatible with reset or rewrite call for ' + filename);
      end;
    if size > 0 then
      flags := flags + 'b';
    streamp := fopen(cstring(filename), cstring(flags));
    if streamp = nil then
      _p_liberror('Can''t open ' + filename);
    filep := _p_addfile(filevar);
    filep^.streamp := streamp;
    filep^.filename := filename;
    filep^.flags := flags;
    if size > 0 then
      begin
      filep^.bufferp := malloc(size);
      filep^.size := size;
      end
    else
      filep^.bufferp := ref(filep^.ch);
    if pos(flags, '+') <> 0 then
      begin
      filep^.status := [_p_read, _p_write{, _p_ran}];
      if flags[1] = 'w' then
        filep^.status := filep^.status + [_p_def];
      end
    else if flags[1] = 'r' then
      filep^.status := [_p_read]
    else
      filep^.status := [_p_def, _p_write];
    if size < 0 then
      filep^.status := filep^.status + [_p_text];
    end
  else
    begin
      if defflags[1] = 'w' then
        begin
        if ftruncate(fileno(filep^.streamp), 0) <> 0 then
          _p_libfileerror(filep,'failed to truncate file during rewrite');
        filep^.status := filep^.status + [_p_def]
        end
      else if defflags[1] = 'r' then
        filep^.status := filep^.status - [_p_def, _p_eof, _p_eoln];
      if fseek(filep^.streamp, 0, _p_seek_set) <> 0 then
        _p_libfileerror(filep, 'reset/rewrite of open file failed');
    end;
       
end;

{ reset and rewrite are standard pascal procedures, the use of file names,
  optional default extension and flags, and an error variable to return
  error codes is not.

  Pascal was originally implemented on a CDC 6000 family 64 bit computer with
  a batch operating system the assigned files to programs at invocation.  So
  "reset(foo)" would attach the file specified at invocation to "foo".  In
  some vague way not all that different than "helloworld >helloworld.txt" or
  "helloworld >/dev/null" being associated with stdout in unix shells.
}

procedure _p_reset;

begin
  _p_filecommon(filevar, size, str1ptr, str2ptr, errptr, 'r');
end;

procedure _p_rewrite;

begin
  _p_filecommon(filevar, size, str1ptr, str2ptr, errptr, 'w');
end;

function _p_checkio(filevar: _p_addressptr; state: _p_filestatusenum): _p_fileinfoptr;

{ Checks that the filevar points to an open file with either _p_read or _p_write
  in its status.
}

var
  filep: _p_fileinfoptr;

begin
  filep := _p_filep(filevar);
  if filep = nil then
    _p_liberror('file variable not found');
  if not (state in filep^.status) then
    _p_libfileerror(filep, 'Illegal operation');
  _p_checkio := filep;
end;

procedure _p_seek;

var
  filep: _p_fileinfoptr;

begin {_p_seek}
  filep := _p_filep(filevar);
  if fseek(filep^.streamp, offset * filep^.size, _p_seek_set) <> 0 then
    _p_libfileerror(filep, 'seek failed');
    filep^.status := filep^.status - [_p_def, _p_eoln, _p_eof];
end {_p_seek};

{ Input operations on files are implemented using lazy I/O.
}

procedure _p_define;

{ This is called by the generated code if the file's buffer content is currently
  undefined.  The generated code depends on pointer checking to guard against
  trying to use a file that's not open.  This procedure is more robust.

  This is where fread or fgetc is called to read data from the stream.  Data is
  read and _p_def is set, optionally along with _p_eoln or _p_eof.
}

var
  filep: _p_fileinfoptr;
  bytesread: integer;
  ch: integer; {-1 for eof}

begin {_p_define}
  filep := _p_checkio(filevar, _p_read);
  if _p_text in filep^.status then
    begin
    ch := fgetc(filep^.streamp);
    if ch < 0 then
      filep^.status := filep^.status + [_p_eof, _p_eoln]
    else
      begin
      filep^.status := filep^.status - [_p_eof, _p_eoln];
      if ch = 10 then
        filep^.status := filep^.status + [_p_eoln];
      filep^.ch := chr(ch);
      end;
    end
  else
    begin
    bytesread := fread(filep^.bufferp, filep^.size, 1, filep^.streamp);
    if (bytesread < filep^.size) and feof(filep^.streamp) then
      filep^.status := filep^.status + [_p_eof]
    else
      filep^.status := filep^.status - [_p_eof];
    end;
  filep^.status :=filep^.status + [_p_def];
end {_p_define};

procedure _p_get;

{ If the usual paradigm to check for eof() before trying to read data is
  used, the file buffer will already be defined.  In which case we simply set
  it to undefined.  Which will case the next operation on the file to call
  _p_define to read data and set eof if appropriate.
}

var
  filep: _p_fileinfoptr;

begin
  filep := _p_checkio(filevar, _p_read);
  with filep^ do
    if _p_def in status then
      if _p_eof in filep^.status then
        _p_libfileerror(filep, 'attempt to read past end of file')
      else filep^.status := filep^.status - [_p_def]
    else
      _p_define(filevar)
end;

procedure _p_put;

{ This code assumes we're at the end of the file for now.
}

var
  filep: _p_fileinfoptr;
  byteswritten: integer;

begin
  filep := _p_checkio(filevar, _p_write);
  byteswritten := fwrite(filep^.bufferp, filep^.size, 1, filep^.streamp);
  if ferror(filep^.streamp) <> 0 then
    _p_libfileerror(filep, 'write error');
end;
  
procedure _p_delete;

{ Delete a file that is already open.  First we close it to ensure that
  it is removed from _p_filelist.
}

var
  filep: _p_fileinfoptr;
  filename: _p_string;

begin
  filep := _p_filep(filevar);
  if filep = nil then
    _p_liberror('can''t delete a file that is not open');
  filename := filep^.filename;
  _p_close(filevar);
  if remove(cstring(filename)) <> 0 then
    _p_liberror('delete failed for ' + filename);
end;

procedure wrchar(filep: _p_fileinfoptr; ch: char);

begin {wrchar}
  if fputc(ch, filep^.streamp) < 0 then
    _p_libfileerror(filep, 'write error');
end {wrchar};

procedure _p_wtc;

var
  i: integer;
  filep: _p_fileinfoptr;

begin {_p_wtc}
  filep := _p_checkio(filevar, _p_write);
  begin
    for i := 2 to width do wrchar(filep, ' ');
    wrchar(filep, ch);
  end;
end {_p_wtc};

procedure _p_wtb;

var
  i: integer;
  filep: _p_fileinfoptr;
  s: string[5];


begin
  filep := _p_checkio(filevar, _p_write);
  for i := 5 + ord(not b) to width do
    wrchar(filep, ' ');
 if b then
   s := 'true'
 else
   s := 'false';
 for i := 1 to length(s) do
   wrchar(filep, s[i]);
end;

procedure _p_wti;

var
  digits: packed array [0..18] of char;
  j: integer;
  count: integer;
  minus: boolean;
  filep: _p_fileinfoptr;

begin
  filep := _p_checkio(filevar, _p_write);
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
    wrchar(filep, ' ');

  if minus then
    wrchar(filep, '-');

  repeat
    j := j - 1;
    wrchar(filep, digits[j]);
  until j = 0;

end;

procedure _p_wts;

var
  i: integer;
  filep: _p_fileinfoptr;

begin
  filep := _p_checkio(filevar, _p_write);
  for i := 0 to width - length - 1 do
    wrchar(filep, ' ');
  for i := 0 to length - 1 do
    wrchar(filep, str[i]);
end;

procedure _p_wtln;

  var
    filep: _p_fileinfoptr;

begin {_p_wtln}
  filep := _p_checkio(filevar, _p_write);
  wrchar(filep, chr(10));
end {_p_wtln};

{ Write to standard output.  This is going to change drastically soon.
}

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

{ read text files }

function _p_rdc;

{ read one character from the given text file }

var
  filep: _p_fileinfoptr;

begin {_p_rdc}
  filep := _p_checkio(filevar, _p_read);
  if not (_p_def in filep^.status) then
    _p_define(filevar);
  _p_rdc := filep^.ch;
  if not (_p_eoln in filep^.status) then
    filep^.status := filep^.status - [_p_def];
end {_p_rdc};

procedure _p_rdln;

var
  filep: _p_fileinfoptr;

begin {_p_rdln}
  filep := _p_checkio(filevar, _p_read);
  while not (_p_eoln in filep^.status) do
    _p_get(filevar);
  _p_get(filevar);
end {p_rdln};

procedure _p_new;
begin
  p := malloc(size);
end;

procedure _p_dispos;
begin
  free(p);
  p := nil;
end;
