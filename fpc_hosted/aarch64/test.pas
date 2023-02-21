program test;

uses config,hdr,hdrc, commonc, code;

var

reg_prefix: array[boolean] of char;
signed_prefix: array[boolean] of char;
reg_extends_text: array[reg_extends] of packed array [1..3] of char;
reg_shifts_text: array[reg_shifts] of packed array [1..3] of char;
reg_offset_shifts: array [boolean] of 2..3;

o1, o2, o3, o4: oprnd_type;
i: inst_type;

procedure write_reg(r: regindex; sf: boolean);
begin
  if r = sp then write('sp')
  else if r = noreg then write('NOREG')
  else write(reg_prefix[sf], r);
end {write_reg};

procedure write_inst(i: inst_type);
begin
  case i.inst of
    ldr: write('ldr');
    ldrb: write('ldrb');
    ldrh: write('ldrh');
    ldrw: write('ldrw');
    ldrsb: write('ldrsb');
    ldrsh: write('ldrsh');
    ldrsw: write('ldrsw');
    str: write('str');
    strb: write('strb');
    strh: write('strh');
    add: write('add');
    sub: write('sub');
    otherwise write('bad inst');
  end;
  if (i.inst in [first_a .. last_a]) and i.s then
    write('s');
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
            write(', ', reg_shifts_text[o.value_oprnd.reg_shift], ' ', o.value_oprnd.shift_amount);
        end;
        extend_reg:
        begin
          write(', ', signed_prefix[o.value_oprnd.extend_signed], reg_extends_text[o.value_oprnd.reg_extend],
                ' ', o.value_oprnd.extend_amount);
        end;
        immediate:
        begin
          write(o.value_oprnd.value);
          if o.value_oprnd.shift then
            write(', lsl 12');
        end;
        register:;
        otherwise write('unknown value_oprnd');
      end;
    end;
  addr_oprnd:
    begin
      if o.addr_oprnd.basereg <> noreg then
        begin
        write('[');
        write_reg(o.addr_oprnd.basereg, true);
        end;
      case o.addr_oprnd.mode of
      pre_index: write(', ', o.addr_oprnd.index, ']!');
      post_index: write('], ', o.addr_oprnd.index);
      imm_offset: write(', ', o.addr_oprnd.index, ']');
      reg_offset:
        begin
        write(', ');
        write_reg(o.addr_oprnd.reg, o.addr_oprnd.extend = xtx);
        if (o.addr_oprnd.extend = xtx) and not o.addr_oprnd.signed and
            o.addr_oprnd.shift then
          write(', ', reg_shifts_text[lsl], ' ', reg_offset_shifts[sf])
        else if o.addr_oprnd.signed or (o.addr_oprnd.extend <> xtx) then
          begin
          write(', ', signed_prefix[o.addr_oprnd.signed],
                reg_extends_text[o.addr_oprnd.extend]);
          if o.addr_oprnd.shift then
            write(' ', reg_offset_shifts[sf]);
          end;
        write(']');
        end;
      literal: write(o.addr_oprnd.literal);
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
  write(chr(9));
  write_inst(p^.inst);
  sep := chr(9);
  for i := 1 to p^.oprnd_cnt do
  begin
    write(sep);
    sep := ',';
    write_oprnd(p^.oprnds[i], p^.inst.sf);
  end;
  writeln;
end {write_node};

begin

reg_shifts_text[lsl] := 'lsl';
reg_shifts_text[lsr] := 'lsr';
reg_shifts_text[asr] := 'asr';

reg_extends_text[xtb] := 'xtb';
reg_extends_text[xth] := 'xth';
reg_extends_text[xtw] := 'xtw';
reg_extends_text[xtx] := 'xtx';

reg_offset_shifts[false] := 2; reg_offset_shifts[true] := 3;
reg_prefix[false] := 'w'; reg_prefix[true] := 'x';
signed_prefix[false] := 'u'; signed_prefix[true] := 's';

i.inst := ldr;
i.sf := true;
i.s := false;

gen_inst_node(i, 2);

o1.typ := value_oprnd;
o1.value_oprnd.reg := 3;

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.basereg := noreg;
o2.addr_oprnd.mode := literal;
o2.addr_oprnd.literal := 16000;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

o1.typ := value_oprnd;
o1.value_oprnd.reg := 3;

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.basereg := sp;
o2.addr_oprnd.mode := pre_index;
o2.addr_oprnd.index := -16;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := post_index;
o2.addr_oprnd.index := 16;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := imm_offset;
o2.addr_oprnd.index := 256;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 1;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := false;
o2.addr_oprnd.extend := xtx;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 2;
o2.addr_oprnd.shift := true;
o2.addr_oprnd.signed := false;
o2.addr_oprnd.extend := xtx;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := true;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtx;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtx;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := true;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

i.sf := false;

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := true;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

i.inst := ldrb;
gen_inst_node(i, 2);

o1.value_oprnd.reg := 3;
gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

i.inst := ldrsw;
i.sf := true; { ldrsw requries an Xreg target }

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.basereg := 5;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

i.inst := str;

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.basereg := 5;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

i.sf := false;

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.basereg := 5;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

i.inst := strh;
i.sf := false;

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.basereg := 5;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

i.inst := strb;

gen_inst_node(i, 2);

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.basereg := 5;
o2.addr_oprnd.mode := reg_offset;
o2.addr_oprnd.reg := 3;
o2.addr_oprnd.shift := false;
o2.addr_oprnd.signed := true;
o2.addr_oprnd.extend := xtw;

gen_oprnd(lastnode, 2, o2);

i.inst := add;
i.sf := false;
i.s := true;

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2 := o1;
o2.value_oprnd.reg := 4;
gen_oprnd(lastnode, 2, o2);

o3 := o1;
o3.value_oprnd.reg := 20;
gen_oprnd(lastnode, 3, o3);

i.sf := true;
gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2 := o1;
o2.value_oprnd.reg := 4;
gen_oprnd(lastnode, 2, o2);

o3 := o1;
o3.value_oprnd.reg := 20;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 21;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 4;
o3.value_oprnd.mode := shift_reg;
o3.value_oprnd.reg_shift := lsl;
o3.value_oprnd.shift_amount := 20;
gen_oprnd(lastnode, 3, o3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 21;
gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 3);

o3.value_oprnd.reg := 4;
o3.value_oprnd.mode := shift_reg;
o3.value_oprnd.reg_shift := lsr;
o3.value_oprnd.shift_amount := 41;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 21;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 4;
o3.value_oprnd.mode := shift_reg;
o3.value_oprnd.reg_shift := asr;
o3.value_oprnd.shift_amount := 63;
gen_oprnd(lastnode, 3, o3);

i.sf := false;
gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 21;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 4;
o3.value_oprnd.mode := shift_reg;
o3.value_oprnd.reg_shift := lsl;
o3.value_oprnd.shift_amount := 20;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 21;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 4;
o3.value_oprnd.mode := shift_reg;
o3.value_oprnd.reg_shift := lsr;
o3.value_oprnd.shift_amount := 21;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 21;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 4;
o3.value_oprnd.mode := shift_reg;
o3.value_oprnd.reg_shift := asr;
o3.value_oprnd.shift_amount := 23;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 21;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := noreg;
o3.value_oprnd.mode := immediate;
o3.value_oprnd.value := 2332;
o3.value_oprnd.shift := false;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := noreg;
o3.value_oprnd.mode := immediate;
o3.value_oprnd.value := 2332;
o3.value_oprnd.shift := true;
gen_oprnd(lastnode, 3, o3);

i.inst := sub;
i.sf := true;
i.s := false;

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 5;
o3.value_oprnd.mode := extend_reg;
o3.value_oprnd.reg_extend := xtx;
o3.value_oprnd.extend_amount := 3;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 5;
o3.value_oprnd.mode := extend_reg;
o3.value_oprnd.reg_extend := xtb;
o3.value_oprnd.extend_signed := true;
o3.value_oprnd.extend_amount := 3;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 5;
o3.value_oprnd.mode := extend_reg;
o3.value_oprnd.reg_extend := xth;
o3.value_oprnd.extend_signed := false;
o3.value_oprnd.extend_amount := 3;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 5;
o3.value_oprnd.mode := extend_reg;
o3.value_oprnd.reg_extend := xtw;
o3.value_oprnd.extend_signed := true;
o3.value_oprnd.extend_amount := 3;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 5;
o3.value_oprnd.mode := extend_reg;
o3.value_oprnd.reg_extend := xtx;
o3.value_oprnd.extend_signed := true;
o3.value_oprnd.extend_amount := 3;
gen_oprnd(lastnode, 3, o3);

i.sf := false;
gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 5;
o3.value_oprnd.mode := extend_reg;
o3.value_oprnd.reg_extend := xtx;
o3.value_oprnd.extend_signed := true;
o3.value_oprnd.extend_amount := 3;
gen_oprnd(lastnode, 3, o3);

i.sf := false;
gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.reg := 5;
o3.value_oprnd.mode := shift_reg;
o3.value_oprnd.shift_amount := 31;
o3.value_oprnd.reg_shift := lsr;
gen_oprnd(lastnode, 3, o3);

i.sf := true;
gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.shift_amount := 61;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.shift_amount := 62;
o3.value_oprnd.reg_shift := lsl;
gen_oprnd(lastnode, 3, o3);

gen_inst_node(i, 3);

gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.reg := 22;
gen_oprnd(lastnode, 2, o2);

o3.value_oprnd.shift_amount := 63;
o3.value_oprnd.reg_shift := asr;
gen_oprnd(lastnode, 3, o3);

while firstnode <> nil do
begin
  write_node(firstnode);
  firstnode := firstnode^.next_node;
end;

end.
