unit putcode;

interface

uses config, product, hdr, hdrc, t_c, utils, sysutils;

procedure putcode;

procedure initmac;

procedure openc;

procedure closec;

procedure write_nodes(firstnode, lastnode: nodeptr);

implementation

var

reg_prefix: array[boolean] of char;
signed_prefix: array[boolean] of char;
reg_extends_text: array[reg_extends] of packed array [1..3] of char;
reg_shifts_text: array[reg_shifts] of packed array [1..3] of char;


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


procedure writeint(v: integer);

  var
    bufptr: 0..9;
    buffer: array [1..20] of char;
    u: unsigned;

  begin
    bufptr := 0;
    if v < 0 then
      write(macfile,'-');
    u := abs(v);

    repeat
      bufptr := bufptr + 1;
      buffer[bufptr] := chr (u mod 10 + ord('0'));
      u := u div 10;
    until u = 0;

    repeat
      write(macfile, buffer[bufptr]);
      bufptr := bufptr - 1;
    until bufptr = 0;
  end; {writeint}


procedure writehex(v: unsigned {value to write} );

{ Write an unsigned value to the macro file as a hexadecimal number.
  16 bit values only.
}
  const
    maxhex = 8;

  var
    hexbuf: packed array [1..maxhex] of char;
    i: 1..maxhex;    { induction var for filling hexbuf }
    j: 0..15;        { numeric value of one hex digit }

  begin
    write(macfile, '0x');
    for i := maxhex downto 1 do begin
      j  := v mod 16;
      v := v div 16;
      if j <= 9 then
        hexbuf[i] := chr(ord('0') + j)
      else hexbuf[i] := chr(ord('A') + j - 10);
      end; { for i }
    write(MacFile, hexbuf);
    column := column + 4;
  end {writehex} ;

procedure copysfile;

{ Copy the string table and constant table from the string file to
  the macro file.  This is written as straight binary data, with no
  attempt to interpret it as strings or real numbers.

  The string file is actually divided into three parts.  The first is
  the string table, which contains string constants parsed by the
  scanner.  The second part is a table of identifiers, and the third
  part is constants built by analys.  Only the first and third
  parts are written here.
}

  var
    i: integer; { outer loop counter }


  procedure write_constants(i: integer);

    const
      wordsperline = 4;  { number of constant structure values (hex) per line }

    var
      k, l, m: integer;
      v: uns_word;

    begin {write_constants}
    while i > 0 do
      begin
      write(macfile, chr(9),'.word', chr(9));

      for k := 1 to min(wordsperline, (i + 1) div word) do
        begin
        if k > 1 then { separate words with commas }
          write(macfile, ',');
        v := 0;
        m := 1;
        for l := 0 to  min(i mod word, word - 1) do
        begin
          v := v + getstringfile * m;
          m := m * 256;
          i := i - 1;
        end;
        writehex(v);
        end;
      writeln(macfile);;
      end;
    end; {write_constants}


  begin {copysfile}
    curstringblock := 1;
    stringblkptr := stringblkptrtbl[curstringblock];
    nextstringfile := 0;

    { first write the string table as fixed length character strings }

    i := stringfilecount;
    if i > 0 then begin
      writeln(macfile, '#');
      writeln(macfile, '#  Constants');
      writeln(macfile, '#');
      writeln(macfile, chr(9), '.data');
      writeln(macfile, chr(9), '.align 3');
      writeln(macfile, '.L:'); { the label associated with constants }
      end;
    write_constants(i);
  end {copysfile} ;


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
      write(macfile, chr(getstringfile));
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
    asrinst: write(macfile, 'asr');
    b: write(macfile, 'b');
    beq: write(macfile, 'b.eq');
    bge: write(macfile, 'b.ge');
    bhi: write(macfile, 'b.hi');
    bhs: write(macfile, 'b.hs');
    bl: write(macfile, 'bl');
    ble: write(macfile, 'b.le');
    blo: write(macfile, 'b.lo');
    bls: write(macfile, 'b.ls');
    bne: write(macfile, 'b.ne');
    bvc: write(macfile, 'b.vc');
    bvs: write(macfile, 'b.vs');
    cmp: write(macfile, 'cmp');
    cmn: write(macfile, 'cmn');
    ldr: write(macfile, 'ldr');
    ldrb: write(macfile, 'ldrb');
    ldrh: write(macfile, 'ldrh');
    ldrw: write(macfile, 'ldrw');
    ldrsb: write(macfile, 'ldrsb');
    ldrsh: write(macfile, 'ldrsh');
    ldrsw: write(macfile, 'ldrsw');
    ldp: write(macfile, 'ldp');
    lslinst: write(macfile, 'lsl');
    lsrinst: write(macfile, 'lsr');
    madd: write(macfile, 'madd');
    mov: write(macfile, 'mov');
    movz: write(macfile, 'movz');
    msub: write(macfile, 'msub');
    mul: write(macfile, 'mul');
    neg: write(macfile, 'neg');
    ret: write(macfile, 'ret');
    sdiv: write(macfile, 'sdiv');
    stp: write(macfile, 'stp');
    str: write(macfile, 'str');
    strb: write(macfile, 'strb');
    strh: write(macfile, 'strh');
    sub: write(macfile, 'sub');
    udiv: write(macfile, 'udiv');
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
            ' ', o.extend_shift);
    end;
    immediate16:
    begin
      write(macfile, o.imm16_value);
      if o.imm16_shift <> 0 then
        write(macfile, ', lsl ', o.imm16_shift);
    end;
    immediate:
    begin
      write(macfile, o.imm_value);
      if o.imm_shift then
        write(macfile, ', lsl 12');
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
      if (o.extend = xtx) and not o.signed and (o.shift <> 0) then
        write(macfile, ', ', reg_shifts_text[lsl], ' ', o.shift)
      else if o.signed or (o.extend <> xtx) then
        begin
        write(macfile, ', ', signed_prefix[o.signed],
              reg_extends_text[o.extend]);
        if (o.shift <> 0) then
          write(macfile, ' ', o.shift);
        end;
      write(macfile, ']');
      end;
    literal: write(macfile, o.literal);
    proccall:
      if proctable[o.proclabelno].externallinkage and
         not proctable[o.proclabelno].bodydefined then
        writeprocname(o.proclabelno)
      else
        begin
        write(macfile, '.P', o.proclabelno);
        if o.entry_offset <> 0 then
          write(macfile, -o.entry_offset * word);
        end;
    syscall: write(macfile, '_P_', o.labelno);
    labeltarget:
      begin
        if o.lowbits then write(macfile, ':lo12:');
        write(macfile, '.L', o.labelno);
      end;
    tworeg:
      begin
      write('operand mode tworeg found in instruction node');
      compilerabort(inconsistent);
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
  labelnode: writeln(macfile, '.L', p^.labelno, ':');
  otherwise writeln('bad node');
  end;
end {write_node};

procedure initmac;

begin
  reg_prefix[false] := 'w'; reg_prefix[true] := 'x';
  signed_prefix[false] := 'u'; signed_prefix[true] := 's';

  reg_shifts_text[lsl] := 'lsl';
  reg_shifts_text[lsr] := 'lsr';
  reg_shifts_text[asr] := 'asr';
  
  reg_extends_text[xtb] := 'xtb';
  reg_extends_text[xth] := 'xth';
  reg_extends_text[xtw] := 'xtw';
  reg_extends_text[xtx] := 'xtx';

  copysfile;

end;

procedure write_nodes(firstnode, lastnode: nodeptr);
  var stopnode: nodeptr;

begin {write_nodes}
  stopnode := lastnode^.nextnode;
  repeat
    write_node(firstnode);
    firstnode := firstnode^.nextnode;
  until firstnode = stopnode;
end {write_nodes};

procedure putcode;
begin
  write_nodes(firstnode, lastnode);
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
