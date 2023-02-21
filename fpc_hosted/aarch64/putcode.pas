
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

procedure write_reg(r: regindex; sf: boolean);
begin
  if r = sp then write(macfile, 'sp')
  else if r = noreg then write(macfile, 'NOREG')
  else write(macfile, reg_prefix[sf], r);
end {write_reg};

procedure write_inst(i: inst_type);
begin
  case i.inst of
    ldr: write(macfile, 'ldr');
    ldrb: write(macfile, 'ldrb');
    ldrh: write(macfile, 'ldrh');
    ldrw: write(macfile, 'ldrw');
    ldrsb: write(macfile, 'ldrsb');
    ldrsh: write(macfile, 'ldrsh');
    ldrsw: write(macfile, 'ldrsw');
    ldp: write(macfile, 'ldp');
    stp: write(macfile, 'stp');
    str: write(macfile, 'str');
    strb: write(macfile, 'strb');
    strh: write(macfile, 'strh');
    add: write(macfile, 'add');
    sub: write(macfile, 'sub');
    ret: write(macfile, 'ret');
    otherwise write(macfile, 'bad inst');
  end;
  if (i.inst in [first_a .. last_a]) and i.s then
    write(macfile, 's');
end;

procedure write_oprnd(o: oprnd_type; sf: boolean);
begin
  case o.typ of
  value_oprnd:
    begin
      if o.value_oprnd.reg <> noreg then
        write_reg(o.value_oprnd.reg, sf);
      case o.value_oprnd.mode of
        shift_reg:
        begin
          if o.value_oprnd.shift_amount <> 0 then
            write(macfile, ', ', reg_shifts_text[o.value_oprnd.reg_shift], ' ', o.value_oprnd.shift_amount);
        end;
        extend_reg:
        begin
          write(macfile, ', ', signed_prefix[o.value_oprnd.extend_signed], reg_extends_text[o.value_oprnd.reg_extend],
                ' ', o.value_oprnd.extend_amount);
        end;
        immediate:
        begin
          write(macfile, o.value_oprnd.value);
          if o.value_oprnd.shift then
            write(macfile, ', lsl 12');
        end;
        register:;
        otherwise write(macfile, 'unknown value_oprnd');
      end;
    end;
  addr_oprnd:
    begin
      if o.addr_oprnd.basereg <> noreg then
        begin
        write(macfile, '[');
        write_reg(o.addr_oprnd.basereg, true);
        end;
      case o.addr_oprnd.mode of
      pre_index: write(macfile, ', ', o.addr_oprnd.index, ']!');
      post_index: write(macfile, '], ', o.addr_oprnd.index);
      imm_offset: write(macfile, ', ', o.addr_oprnd.index, ']');
      reg_offset:
        begin
        write(macfile, ', ');
        write_reg(o.addr_oprnd.reg, o.addr_oprnd.extend = xtx);
        if (o.addr_oprnd.extend = xtx) and not o.addr_oprnd.signed and
            o.addr_oprnd.shift then
          write(macfile, ', ', reg_shifts_text[lsl], ' ', reg_offset_shifts[sf])
        else if o.addr_oprnd.signed or (o.addr_oprnd.extend <> xtx) then
          begin
          write(macfile, ', ', signed_prefix[o.addr_oprnd.signed],
                reg_extends_text[o.addr_oprnd.extend]);
          if o.addr_oprnd.shift then
            write(macfile, ' ', reg_offset_shifts[sf]);
          end;
        write(macfile, ']');
        end;
      literal: write(macfile, o.addr_oprnd.literal);
      end;
    end;
  otherwise ;
  end;
end {write_oprnd};

procedure write_node(p: nodeptr);

var
  i: oprnd_range;
  sep: char;

begin {write_node}
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
    p := p^.next_node;
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
