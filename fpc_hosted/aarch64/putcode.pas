unit putcode;

interface

uses config, product, hdr, hdrc, t_c, utils, sysutils;

procedure putcode;

procedure initmac;

procedure openc;

procedure closec;

implementation

var

reg_prefix: array[boolean] of char;
signed_prefix: array[boolean] of char;
reg_extends_text: array[reg_extends] of packed array [1..3] of char;
reg_shifts_text: array[reg_shifts] of packed array [1..3] of char;
reg_offset_shifts: array [boolean] of 2..3;


{ Since this doesn't have to run on a tiny 'ole computer like the
  PDP-11 this is an artifact of the old disk-caching implementation
  with the caching stripped out.
}

procedure seekstringfile(n: integer {byte to access});

{ Do the equivalent of a "seek" on the string file.  This sets the
  file and "nextstringfile" to access byte "n" of the stringfile.
}

  var
    newblock: 1..maxstringblks; { block to which seeking }


  begin {seekstringfile}
    newblock := n div (diskbufsize + 1) + 1;
    if newblock <> curstringblock then
      begin
      curstringblock := newblock;
      stringblkptr := stringblkptrtbl[newblock];
      if stringblkptr = nil then
        begin
        write('unexpected end of stringtable ');
        compilerabort(inconsistent);
        end;
      end;
    nextstringfile := n mod (diskbufsize + 1);
  end {seekstringfile} ;


function getstringfile: hostfilebyte;

{ move stringfile buffer pointer to next entry.  'get' is called
  to fill buffer if pointer is at the end.
}

  begin
    if nextstringfile > diskbufsize then
      begin
      nextstringfile := 0;
      curstringblock := curstringblock + 1;
      stringblkptr := stringblkptrtbl[curstringblock];
      if stringblkptr = nil then
        begin
        write('unexpected end of stringtable ');
        compilerabort(inconsistent);
        end;
      end;

    getstringfile := stringblkptr^[nextstringfile];

    nextstringfile := nextstringfile + 1;
  end {getstringfile} ;


procedure writeprocname(procn: proctableindex {number of procedure to copy});

{ Copy the procedure name for procedure "procn" from the string file
  to the macro file.
}

  var
    i: integer; {induction var for copy}

  begin

    curstringblock := (stringfilecount + proctable[procn].charindex - 1) div
       (diskbufsize + 1) + 1;
    stringblkptr := stringblkptrtbl[curstringblock];
    nextstringfile := (stringfilecount + proctable[procn].charindex - 1) mod
                        (diskbufsize + 1);

    for i := 1 to proctable[procn].charlen do
      if language = pascal then write(macfile, uppercase(chr(getstringfile)))
      else write(macfile, chr(getstringfile));
  end {writeprocname} ;

procedure writeproclabel(procn: proctableindex);
  begin {writeproclabel}

    { banner }
    writeln(macfile, '#');
    write(macfile, '#', chr(9));
    writeprocname(procn);
    if blockref = 0 then writeln(macfile, ' (main)')
    else writeln(macfile);
    writeln(macfile, '#');
    writeln(macfile, chr(9), '.text');
    writeln(macfile, chr(9), '.align 2');

    if proctable[blockref].externallinkage
       or ((proctable[blockref].calllinkage = implementationbody)
	   and (level = 1)) then
      { a linux kludge that the front end doesn't manage.  ld could be told that
        the program starts at the program name global but it is easier to just
        declare "main".
      }
      if blockref = 0 then
        begin
        writeln(macfile, chr(9), '.global main');
        writeln(macfile, 'main:');
        end
      else
        begin write(macfile, chr(9), '.global ');
        writeprocname(blockref);
        writeln(macfile);
        writeprocname(blockref);
        writeln(macfile, ':');
        end
    else
      writeln(macfile, '.P', procn, ':');

  end {writeproclabel};

procedure write_reg(r: regindex; sf: boolean);
begin
  if r = sp then write(macfile, 'sp')
  else if r = noreg then write(macfile, 'NOREG')
  else write(macfile, reg_prefix[sf], r);
end {write_reg};

procedure write_inst(i: insttype);
begin
  case i.inst of
    add: write(macfile, 'add');
    adrp: write(macfile, 'adrp');
    ldr: write(macfile, 'ldr');
    ldrb: write(macfile, 'ldrb');
    ldrh: write(macfile, 'ldrh');
    ldrw: write(macfile, 'ldrw');
    ldrsb: write(macfile, 'ldrsb');
    ldrsh: write(macfile, 'ldrsh');
    ldrsw: write(macfile, 'ldrsw');
    ldp: write(macfile, 'ldp');
    mov: write(macfile, 'mov');
    movz: write(macfile, 'movz');
    ret: write(macfile, 'ret');
    stp: write(macfile, 'stp');
    str: write(macfile, 'str');
    strb: write(macfile, 'strb');
    strh: write(macfile, 'strh');
    sub: write(macfile, 'sub');
    otherwise write(macfile, 'bad inst');
  end;
  if (i.inst in [first_a .. last_a]) and i.s then
    write(macfile, 's');
end;

procedure write_oprnd(o: oprndtype; sf: boolean);
begin
  case o.mode of
    shift_reg:
    begin
      write_reg(o.reg, sf);
      if o.shift_amount <> 0 then
        write(macfile, ', ', reg_shifts_text[o.reg_shift], ' ', o.shift_amount);
    end;
    extend_reg:
    begin
      write_reg(o.reg, sf);
      write(macfile, ', ', signed_prefix[o.extend_signed], reg_extends_text[o.reg_extend],
            ' ', o.extend_amount);
    end;
    immediate:
    begin
      write(macfile, o.value);
      if o.imm_shift <> 0 then
        write(macfile, ', lsl ', o.imm_shift);
    end;
    register: write_reg(o.reg, sf);
    pre_index:
      begin
      write(macfile, '[');
      write_reg(o.reg, true);
      write(macfile, ', ', o.index, ']!');
      end;
    post_index:
      begin
      write(macfile, '[');
      write_reg(o.reg, true);
      write(macfile, '], ', o.index);
      end;
    signed_offset, unsigned_offset:
      begin
      write(macfile, '[');
      write_reg(o.reg, true);
      if o.index <> 0 then
        write(macfile, ', ', o.index);
      write(macfile, ']');
      end;
    reg_offset:
      begin
      write(macfile, '[');
      write_reg(o.reg, true);
      write(macfile, ', ');
      write_reg(o.reg2, o.extend = xtx);
      if (o.extend = xtx) and not o.signed and o.shift then
        write(macfile, ', ', reg_shifts_text[lsl], ' ', reg_offset_shifts[sf])
      else if o.signed or (o.extend <> xtx) then
        begin
        write(macfile, ', ', signed_prefix[o.signed],
              reg_extends_text[o.extend]);
        if o.shift then
          write(macfile, ' ', reg_offset_shifts[sf]);
        end;
      write(macfile, ']');
      end;
    literal: write(macfile, o.literal);
    labeltarget:
      begin
        if o.lowbits then write(macfile, ':lo12:');
          case o.mode of
          labeltarget: write(macfile, '.L', o.labelno);
          usercall: write(macfile, '.P', o.labelno);
          syscall: write(macfile, '_P_', o.labelno);
          end;
      end;
  end;
end {write_oprnd};

procedure write_node(p: nodeptr);

var
  i: oprnd_range;
  sep: char;

begin {write_node}
  case p^.kind of
  proclabelnode: writeproclabel(p^.proclabel);
  instnode:
    begin
    write(macfile, chr(9));
    write_inst(p^.inst);
    sep := chr(9);
    for i := 1 to p^.oprnd_cnt do
      begin
      write(macfile, sep);
      sep := ',';
      write_oprnd(p^.oprnds[i], p^.inst.sf);
      end;
    writeln(macfile);
    end;
  stmtnode:
    begin
    i := p^.stmtno;
    if i <> 0 then i := i - firststmt + 1;
    writeln(macfile, '# Line: ', p^.sourceline - lineoffset: 1,
                        ', Stmt: ', i: 1);
    end;
  bssnode:
    begin
    writeln(macfile, chr(9), '.bss');
    writeln(macfile, chr(9), '.align 3');
    writeln(macfile, '.L', bsslabel, ':');
    writeln(macfile, chr(9), '.space ', p^.bsssize);
    end;
  otherwise write('bad node');
  end;
end {write_node};

procedure initmac;

begin
  reg_offset_shifts[false] := 2; reg_offset_shifts[true] := 3;
  reg_prefix[false] := 'w'; reg_prefix[true] := 'x';
  signed_prefix[false] := 'u'; signed_prefix[true] := 's';

  reg_shifts_text[lsl] := 'lsl';
  reg_shifts_text[lsr] := 'lsr';
  reg_shifts_text[asr] := 'asr';
  
  reg_extends_text[xtb] := 'xtb';
  reg_extends_text[xth] := 'xth';
  reg_extends_text[xtw] := 'xtw';
  reg_extends_text[xtx] := 'xtx';
end;

procedure putcode;
  var p: nodeptr;
begin
  p := firstnode;
  while p <> nil do
  begin
    write_node(p);
    p := p^.nextnode;
  end;
end;

procedure openc;

{ Open files for code generator.
}

  procedure getoutputname;

  { Fill the globals "filename" and "outputname".
  }

    var
      i: FilenameIndex; {induction on outputname}
      limit: 1..maxprocnamelen; {length of outputname used}


    begin {getoutputname}
      getfilename(nil, true, true, filename, filename_length);
      limit := min(filename_length, maxprocnamelen);
      for i := 1 to limit do
        outputname[i] := filename[i];	
      for i := limit + 1 to maxprocnamelen do outputname[i] := ' ';
    end {getoutputname} ;

  begin {openc}
    getoutputname;
    if switcheverplus[outputmacro] then
      begin
      getfilename(macname, false, false, filename, filename_length);
      assign(macfile, trim(string(filename)) + '.s');
      rewrite(macfile);
      end;
  end {openc} ;

procedure closec;

{ Close object and macro files.
}


  begin {closec}
    if switcheverplus[outputmacro] then close(macfile);
  end {closec} ;


end.
