program test;

uses config,hdr,hdrc;

var

reg_prefix: array[boolean] of char;
signed_prefix: array[boolean] of char;
reg_shifts_text: array[reg_shifts] of packed array [1..3] of char;
reg_extends_text: array[reg_extends] of packed array [1..3] of char;

o: oprnd2_type;
l: ldstr_oprnd_type;

procedure write_reg(r: regindex; sf: boolean);
begin
  if r = sp then write('sp')
  else if r = noreg then write('NOREG')
  else write(reg_prefix[sf], r);
end;

procedure write_oprnd2(o: oprnd2_type; sf: boolean);
begin
  if o.reg <> noreg then
    write_reg(o.reg, sf);
  case o.oprnd2_mode of
    shift_reg:
    begin
      if o.shift_amount <> 0 then
        write(', ', reg_shifts_text[o.reg_shift], ' ', o.shift_amount);
    end;
    extend_reg:
    begin
      write(', ', signed_prefix[o.extend_signed], reg_extends_text[o.reg_extend],
            ' ', o.extend_amount);
    end;
    immediate:
    begin
      write(o.value);
      if o.shift then
        write(', lsl 12');
    end;
    register:;
    otherwise write('unknown oprnd2');
  end;
  writeln;
end;


procedure write_ldstr_oprnd(o: ldstr_oprnd_type; sf: boolean);
begin
  if o.basereg <> noreg then
    begin
    write('[');
    write_reg(o.basereg, sf);
    end;
  case o.ldstr_oprnd_mode of
  ldstr_pre_index: write(', ', o.index, ']!');
  ldstr_post_index: write('], ', o.index);
  ldstr_immediate: write(', ', o.index, ']');
  ldstr_literal: write(o.literal);
  end;
  writeln;
end;

begin

reg_shifts_text[lsl] := 'lsl';
reg_shifts_text[lsr] := 'lsr';
reg_shifts_text[asr] := 'asr';

reg_extends_text[xtb] := 'xtb';
reg_extends_text[xth] := 'xth';
reg_extends_text[xtw] := 'xtw';
reg_extends_text[xtx] := 'xtx';

reg_prefix[false] := 'w'; reg_prefix[true] := 'x';
signed_prefix[false] := 'u'; signed_prefix[true] := 's';

writeln('ldstr operands');

l.basereg := sp;
l.ldstr_oprnd_mode := ldstr_pre_index;
l.index := -16;

write_ldstr_oprnd(l, false);

l.basereg := 9;
l.ldstr_oprnd_mode := ldstr_pre_index;
l.index := -16;

write_ldstr_oprnd(l, false);

l.basereg := 9;
l.ldstr_oprnd_mode := ldstr_post_index;
l.index := 16;

write_ldstr_oprnd(l, true);

l.basereg := noreg;
l.ldstr_oprnd_mode := ldstr_literal;
l.literal := 16000;

write_ldstr_oprnd(l, true);

writeln('oprnd2 operands');
o.reg := 3;
o.oprnd2_mode := register;

write_oprnd2(o, true);
write_oprnd2(o, false);

o.reg := 4;
o.oprnd2_mode := shift_reg;
o.reg_shift := lsl;
o.shift_amount := 20;

write_oprnd2(o, true);
write_oprnd2(o, false);

o.reg := 5;
o.oprnd2_mode := extend_reg;
o.reg_extend := xtx;
o.extend_amount := 4;

write_oprnd2(o, true);

o.reg := 5;
o.oprnd2_mode := extend_reg;
o.reg_extend := xtb;
o.extend_amount := 3;

write_oprnd2(o, false);

o.reg := noreg;
o.oprnd2_mode := immediate;
o.value := 23;
o.shift := true;

write_oprnd2(o, true);
write_oprnd2(o, false);

o.reg := noreg;
o.oprnd2_mode := immediate;
o.value := 23;
o.shift := false;

write_oprnd2(o, true);
write_oprnd2(o, false);

end.
