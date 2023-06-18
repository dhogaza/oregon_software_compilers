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

  {if I ever get this compiler self-hosted it will be awfully nice to
   initialize these with constants!
  }
  reg_prefix: array[boolean] of char;
  signed_prefix: array[boolean] of char;
  reg_extends_text: array[reg_extends] of packed array [1..3] of char;
  reg_shifts_text: array[reg_shifts] of packed array [1..3] of char;
  conds_text: array[conds] of packed array [1..2] of char;

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

procedure libname(libroutine: libroutines;
                  var s: string);

  begin {libname}
    case libroutine of
      libarctan:        s := '_p_fatn    ';
      libbreak:         s := '_p_break   ';
      libcap:           s := '_p_cap     ';  { for Modula-2}
      libcasetrap:      s := '_p_caseerr ';
      libcexit:         s := '_p_cexit   ';  { for C }
      libmexit:         s := '_p_mexit   ';  { for Modula-2 }
      libcidiv:         s := '_p_cidiv   ';  { for C }
      libcinit:         s := '_p_centry  ';  { for C }
      libminit:         s := '_p_minit   ';  { for Modula-2 }
      libclose:         s := '_p_close   ';
      libcloseinrange:  s := '_p_clsrng  ';
      libconnect:       s := '_p_connect ';
      libcopy:          s := '_p_copy    ';
      libcos:           s := '_p_fcos    ';
      libcvtdr:         s := '_p_cvtdf   ';
      libcvtrd:         s := '_p_cvtfd   ';
      libdadd:          s := '_p_dadd    ';
      libdarctan:       s := '_p_datn    ';
      libdbgtrap:       s := '_p_dbgtrp  ';
      libdcos:          s := '_p_dcos    ';
      libddiv:          s := '_p_ddiv    ';
      libdefinebuf:     s := '_p_define  ';
      libdelete:        s := '_p_delete  ';
      libdeql:          s := '_p_deql    ';
      libdexp:          s := '_p_dexp    ';
      libdfloat:        s := '_p_dfloat  ';
      libdufloat:       s := '_p_dufloat ';  { for C }
      libdfloat_uns:    s := '_p_dfltu   ';
      libdispose:       s := '_p_dispos  ';
      libdgtr:          s := '_p_dgtr    ';
      libdln:           s := '_p_dln     ';
      libdlss:          s := '_p_dlss    ';
      libdmult:         s := '_p_dmul    ';
      libdround:        s := '_p_dround  ';
      libdsin:          s := '_p_dsin    ';
      libdsqr:          s := '_p_dsqr    ';
      libdsqrt:         s := '_p_dsqrt   ';
      libdsub:          s := '_p_dsub    ';
      libdswap:         s := '_p_dswap   ';
      libdtime:         s := '_p_dtime   ';
      libdtrunc:        s := '_p_dtrunc  ';
      libdf:            s := '_p_libdf   ';  { for C }
      libfd:            s := '_p_libfd   ';  { for C }
      libexit:          s := '_p_exit    ';
      libexp:           s := '_p_fexp    ';
      libfadd:          s := '_p_fadd    ';
      libfcmp:          s := '_p_fcmp    ';
      libfiletrap:      s := '_p_filerr  ';
      libfdiv:          s := '_p_fdiv    ';
      libffloat:        s := '_p_ffloat  ';
      libfufloat:       s := '_p_fufloat ';  { for C }
      libffloat_uns:    s := '_p_ffltu   ';
      libfmult:         s := '_p_fmul    ';
      libfree:          s := '_p_free    ';
      libfround:        s := '_p_fround  ';
      libfsqr:          s := '_p_fsqr    ';
      libfsub:          s := '_p_fsub    ';
      libftrunc:        s := '_p_ftrunc  ';
      libget:           s := '_p_get     ';
      libhalt:          s := '_p_halt    ';  { for Modula-2}
      libidiv:          s := '_p_idiv    ';
      libimult:         s := '_p_imul    ';
      libinitialize:    s := '_p_initio  ';
      libioerror:       s := '_p_ioerro  ';
      libiostatus:      s := '_p_iostat  ';
      libiotransfer:    s := '_p_iotrans ';  { for Modula-2}
      libln:            s := '_p_fln     ';
      libmcopy1:        s := '_m_copy1   ';  { for Modula-2}
      libmcopy2:        s := '_m_copy2   ';  { for Modula-2}
      libmcopy4:        s := '_m_copy4   ';  { for Modula-2}
      libmcopymd:       s := '_m_copymd  ';  { for Modula-2}
      libnew:           s := '_p_new     ';
      libnewprocess:    s := '_p_newprc  ';  { for Modula-2}
      libnoioerror:     s := '_p_noioer  ';
      libpack:          s := '_p_pack    ';
      libpage:          s := '_p_page    ';
      libpageo:         s := '_p_page_o  ';
      libpointertrap:   s := '_p_badptr  ';
      libpos:           s := '_p_pos     ';
      libprofilerdump:  s := '_p_prdump  ';
      libprofilerinit:  s := '_p_prinit  ';
      libprofilerstmt:  s := '_p_prstmt  ';
      libput:           s := '_p_put     ';
      librangetrap:     s := '_p_subrng  ';
      libreadchar:      s := '_p_rdc     ';
      libreadchari:     s := '_p_rdc_i   ';
      libreaddouble:    s := '_p_rdd     ';
      libreaddoublei:   s := '_p_rdd_i   ';
      libreadint:       s := '_p_rdi     ';
      libreadinti:      s := '_p_rdi_i   ';
      libreadln:        s := '_p_rdln    ';
      libreadlni:       s := '_p_rdln_i  ';
      libreadreal:      s := '_p_rdf     ';
      libreadreali:     s := '_p_rdf_i   ';
      libreadstring:    s := '_p_rds     ';
      libreadstringi:   s := '_p_rds_i   ';
      libreadxstring:   s := '_p_rdxs    ';
      libreadxstringi:  s := '_p_rdxs_i  ';
      librealloc:       s := '_p_realloc ';
      librename:        s := '_p_rename  ';
      libreset:         s := '_p_reset   ';
      librewrite:       s := '_p_rewrit  ';
      libscan:          s := '_p_scan    ';  { for Modula-2}
      libseek:          s := '_p_seek    ';
      libsin:           s := '_p_fsin    ';
      libsqrt:          s := '_p_fsqrt   ';
      libstrovr:        s := '_p_strovr  ';
      libsubscripttrap: s := '_p_subscr  ';
      libtell:          s := '_p_tell    ';
      libtime:          s := '_p_ftime   ';
      libtransfer:      s := '_p_trans   ';  { for Modula-2}
      libunpack:        s := '_p_unpack  ';
      libunsdiv:        s := '_p_udiv    ';
      libunsmod:        s := '_p_umod    ';
      libunsmult:       s := '_p_umul    ';
      libwritebool:     s := '_p_wtb     ';
      libwriteboolo:    s := '_p_wtb_o   ';
      libwritechar:     s := '_p_wtc     ';
      libwritecharo:    s := '_p_wtc_o   ';
      libwritedouble1:  s := '_p_wtd1    ';
      libwritedouble1o: s := '_p_wtd1_o  ';
      libwritedouble2:  s := '_p_wtd2    ';
      libwritedouble2o: s := '_p_wtd2_o  ';
      libwriteint:      s := '_p_wti     ';
      libwriteinto:     s := '_p_wti_o   ';
      libwriteln:       s := '_p_wtln    ';
      libwritelno:      s := '_p_wtln_o  ';
      libwritereal1:    s := '_p_wtf1    ';
      libwritereal1o:   s := '_p_wtf1_o  ';
      libwritereal2:    s := '_p_wtf2    ';
      libwritereal2o:   s := '_p_wtf2_o  ';
      libwritestring:   s := '_p_wts     ';
      libwritestringo:  s := '_p_wts_o   ';
      libdebugger_goto: s := '_p_dbggto  ';
      libdebugger_init: s := '_p_dbgint  ';
      libdebugger_entry:s := '_p_dbgent  ';
      libdebugger_exit: s := '_p_dbgext  ';
      libdebugger_step: s := '_p_dbstmt  ';
      libstrint0:       s := '_p_stri0   ';
      libstrint1:       s := '_p_stri1   ';
      libvalint:        s := '_p_vali    ';
      libstrreal0:      s := '_p_strf0   ';
      libstrreal1:      s := '_p_strf1   ';
      libstrreal2:      s := '_p_strf2   ';
      libvalreal:       s := '_p_valf    ';
      libstrdouble0:    s := '_p_strd0   ';
      libstrdouble1:    s := '_p_strd1   ';
      libstrdouble2:    s := '_p_strd2   ';
      libvaldouble:     s := '_p_vald    ';
      libinsert:        s := '_p_ins     ';
      libdeletestr:     s := '_p_delstr  ';
      libcmemcpy:           s := 'memcpy    ';
      otherwise
        begin
        write('Unexpected library name (', ord(libroutine):1, ')');
        compilerabort(inconsistent);
        end;
      end;

  end {libname} ;


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
      k, l: integer;
      m, v: uns_word;

    begin {write_constants}
    while i > 0 do
      begin
      write(macfile, chr(9),'.word', chr(9));

      k := 1;
      repeat
        if k > 1 then { separate words with commas }
          write(macfile, ',');
        v := 0;
        m := 1;
        while (m and maxaddr <> 0) and (i > 0) do
        begin
          v := v + getstringfile * m;
          m := m * 256;
          i := i - 1;
        end;
        writehex(v);
        k := k + 1;
      until (k > wordsperline) or (i = 0);
      writeln(macfile);
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
      writeln(macfile, chr(9), '.section', chr(9), '.rodata');
      writeln(macfile, chr(9), '.align 3');
      writeln(macfile, '.L', rodatalabel:1, ':'); { the label associated with constants }
      write_constants(i);
      end;
  end {copysfile} ;


  procedure writelibname(l: libroutines);

  { Write the name of a library routine to the mac file }

  var
    s: string;
    i: integer;

  begin
    libname(l, s);
    i := 0;
    repeat
      i := i + 1;
      write(macfile, s[i]);
    until (i = length(s)) or (s[i] = ' ');
  end;

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
    adr: write(macfile, 'adr');
    adrp: write(macfile, 'adrp');
    andinst: write(macfile, 'and');
    ands: write(macfile, 'ands');
    asrinst: write(macfile, 'asr');
    b: write(macfile, 'b');
    bcc: write(macfile, 'b.cc');
    bcs: write(macfile, 'b.cs');
    beq: write(macfile, 'b.eq');
    bge: write(macfile, 'b.ge');
    bgt: write(macfile, 'b.gt');
    bhi: write(macfile, 'b.hi');
    bhs: write(macfile, 'b.hs');
    bl: write(macfile, 'bl');
    ble: write(macfile, 'b.le');
    blt: write(macfile, 'b.lt');
    blo: write(macfile, 'b.lo');
    bls: write(macfile, 'b.ls');
    bne: write(macfile, 'b.ne');
    br: write(macfile, 'br');
    bvc: write(macfile, 'b.vc');
    bvs: write(macfile, 'b.vs');
    cbnz: write(macfile, 'cbnz');
    cbz: write(macfile, 'cbz');
    cinv: write(macfile, 'cinv');
    cmp: write(macfile, 'cmp');
    cmn: write(macfile, 'cmn');
    eon: write(macfile, 'eors');
    eor: write(macfile, 'eor');
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
    movk: write(macfile, 'movk');
    movn: write(macfile, 'movn');
    movz: write(macfile, 'movz');
    msub: write(macfile, 'msub');
    mul: write(macfile, 'mul');
    mvn: write(macfile, 'mvn');
    neg: write(macfile, 'neg');
    orinst: write(macfile, 'orr');
    orn: write(macfile, 'orn');
    ret: write(macfile, 'ret');
    sdiv: write(macfile, 'sdiv');
    stp: write(macfile, 'stp');
    str: write(macfile, 'str');
    strb: write(macfile, 'strb');
    strh: write(macfile, 'strh');
    sub: write(macfile, 'sub');
    udiv: write(macfile, 'udiv');
    otherwise write(macfile, 'bad inst: ', ord(i.inst));
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
    imm16:
    begin
      write(macfile, o.imm16_value);
      if o.imm16_shift <> 0 then
        write(macfile, ',lsl ', o.imm16_shift);
    end;
    imm12:
    begin
      write(macfile, o.imm12_value);
      if o.imm12_shift then
        write(macfile, ',lsl 12');
    end;
    immbitmask: write(macfile, o.bitmask_value);
    fpregister: write(macfile, 's', o.reg);
    register: write_reg(o.reg, sf);
    pre_index:
      begin
      write(macfile, '[');
      write_reg(o.reg, true);
      write(macfile, ',', o.index, ']!');
      end;
    post_index:
      begin
      write(macfile, '[');
      write_reg(o.reg, true);
      write(macfile, '],', o.index);
      end;
    signed_offset, unsigned_offset:
      begin
      write(macfile, '[');
      write_reg(o.reg, true);
      if o.index <> 0 then
        write(macfile, ',', o.index);
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
    cond: write(macfile, conds_text[o.condition]);
    literal: write(macfile, o.literal);
    proccall:
      if proctable[o.proclabelno].externallinkage then
        writeprocname(o.proclabelno)
      else
        begin
        write(macfile, '.P', o.proclabelno);
        if o.entry_offset <> 0 then
          write(macfile, -o.entry_offset * word);
        end;
    libcall: writelibname(o.libroutine);
    labeltarget:
      begin
        if o.lowbits then write(macfile, ':lo12:');
        write(macfile, '.L', o.labelno);
        if o.labeloffset <> 0 then write(macfile, '+',o.labeloffset:1);
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
  rodatanode:
    begin
      writeln(macfile, chr(9), '.section', chr(9), '.rodata');
      writeln(macfile, chr(9), '.align 3');
      writeln(macfile, '.L', p^.labelno:1,':');
     end;
  textnode:
    begin
    writeln(macfile, chr(9), '.text');
    writeln(macfile, chr(9), '.align 2');
    end;
  bssnode:
    begin
    writeln(macfile, chr(9), '.bss');
    writeln(macfile, chr(9), '.align 3');
    writeln(macfile, '.L', bsslabel, ':');
    writeln(macfile, chr(9), '.space ', p^.bsssize);
    end;
  proclabelnode: writeproclabel(p^.proclabel);
  labelnode: writeln(macfile, '.L', p^.labelno, ':');
  labeldeltanode: writeln(macfile, chr(9), '.word', chr(9), '(.L', p^.targetlabel,
                          '-.L', p^.tablebase, ')/4');
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

  conds_text[al] := 'al';
  conds_text[eq] := 'eq';
  conds_text[ne] := 'ne';
  conds_text[gt] := 'gt';
  conds_text[lt] := 'lt';
  conds_text[le] := 'le';
  conds_text[ge] := 'ge';
  conds_text[hi] := 'hi';
  conds_text[hs] := 'hs';
  conds_text[lo] := 'lo';
  conds_text[ls] := 'ls';
  conds_text[cc] := 'cc';
  conds_text[cs] := 'cs';
  conds_text[mi] := 'mi';
  conds_text[pl] := 'pl';
  conds_text[vs] := 'vs';
  conds_text[vc] := 'vc';

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
