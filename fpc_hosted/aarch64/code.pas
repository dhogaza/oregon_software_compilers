

unit code;

interface

uses config, hdr, t_c, hdrc, utils, commonc, putcode;

procedure code;

procedure codeone;

procedure initcode;

procedure exitcode;

procedure gen_inst_node(i: inst_type; {instruction to generate}
                        l: oprnd_range {number of operands});

procedure gen_inst(p: nodeptr;
                   i: inst_type; {instruction to generate}
                   l: oprnd_range {number of operands});

procedure gen_oprnd(p: nodeptr; 
                   i: oprnd_range; {which operand to generate}
                   o: oprnd_type {operand to generate} );

implementation

procedure gen_inst(p: nodeptr;
                   i: inst_type; {instruction to generate}
                   l: oprnd_range {number of operands});

begin
  with p^ do
  begin
    tempcount := 0;
    inst := i;
    labeled := labelnextnode;
    oprnd_cnt := l;
  end;
  labelnextnode := false;
end;


procedure gen_inst_node(i: inst_type; {instruction to generate}
                        l: oprnd_range {number of operands});

{ Generate an instruction node


  All other fields not specified are cleared to zero, and will normally be
  filled in by the calling procedure.  In particular, tempcount is set to
  zero.

}

  begin {gen_inst_node}
    newnode(instnode);
    gen_inst(lastnode, i, l);
  end {gen_inst_node} ;

procedure gen_oprnd(p: nodeptr; 
                    i: oprnd_range; {which operand to generate}
                    o: oprnd_type {operand to generate} );

{ Generates the given operand in lastptr.  If the operand contains an offset
dependent on the stack, tempcount is set appropriately.
}

  begin {genoprnd}

    with p^ do
      begin
      if o.typ = addr_oprnd then
        if o.value_oprnd.reg = fp then
          begin
            { code to switch fp to sp if noframe goes here in m68K? }
          end 
        else if o.value_oprnd.reg = sp then
          begin
            { code to adjust stack offset goes here in m68K? }
          end;
      p^.oprnds[i] := o;
    end;
  end {genoprnd} ;


procedure code;
begin
end;

procedure codeone;
begin
end;

procedure initcode;

{ Initialize the code generation pass.
}

  var
    i: integer; {general purpose induction variable}
    procno: proctableindex;

  begin {initcode}


    labelnextnode := false;
    labeltable[0].nodelink := nil;

    {Now initialize file variables}

    nokeydata := [endpseudocode, bad, blockentry, blockexit, jumpf, jumpt, jump,
		 pascallabel, savelabel, clearlabel, joinlabel, restorelabel,
		 sysroutine, caseelt, setfile, closerange, restoreloop,
                 saveactkeys];

    oneoperand := [endpseudocode, bad, blockexit, dovar, dounsvar, doint, doorigin,
		 pseudolabel, savelabel, clearlabel, joinlabel, restorelabel,
		 copyaccess, flt, pshaddr, pshstraddr, pshint, pshptr, pshreal,
		 pshstr, pshstruct, pshset, pshlitint, pshlitptr, pshlitreal,
		 copystack, fmt, wrint, wrreal, wrchar, wrst, wrbool, wrbin, wrxstr,
		 rdbin, rdint, rdchar, rdreal, rdst, rdxstr, stacktarget, ptrchk,
		 chrstr, arraystr, definelazy, setbinfile, setfile, closerange,
		 restoreloop];


    curstringblock := 0;
    nextstringfile := 0;
    level := 0;
    fileoffset := 0;
    formatcount := 0;
    filenamed := false;

    keytable[0].validtemp := false;

    lastnode := nil;
    firstnode := nil;

    testing := switcheverplus[test] and switcheverplus[outputmacro];

    if switcheverplus[outputmacro] then initmac;

    stackcounter := keysize - 1; {fiddle consistency check}

    if peeping then for i := 0 to maxpeephole do peep[i] := 0;

  end {initcode} ;

procedure exitcode;

  var
    p, p1: nodeptr;

o1, o2, o3, o4: oprnd_type;
i: inst_type;

  begin


i.inst := ldr;
i.sf := true;
i.s := false;

gen_inst_node(i, 2);

o1.typ := value_oprnd;
o1.value_oprnd.mode := register;
o1.value_oprnd.reg := 3;

gen_oprnd(lastnode, 1, o1);

o2.typ := addr_oprnd;
o2.addr_oprnd.basereg := noreg;
o2.addr_oprnd.mode := literal;
o2.addr_oprnd.literal := 16000;

gen_oprnd(lastnode, 2, o2);

gen_inst_node(i, 2);

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

i.inst := stp;
i.sf := true;
gen_inst_node(i, 3);

o3 := o2;
o2 := o1;
o1.value_oprnd.reg := 29;
gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.mode := register;
o2.value_oprnd.reg := 30;
gen_oprnd(lastnode, 2, o2);

o3.typ := addr_oprnd;
o3.addr_oprnd.basereg := sp;
o3.addr_oprnd.mode := pre_index;
o3.addr_oprnd.index := -16;
gen_oprnd(lastnode, 3, o3);

i.inst := ldp;
i.sf := true;
gen_inst_node(i, 3);

o3 := o2;
o2 := o1;
o1.value_oprnd.reg := 29;
gen_oprnd(lastnode, 1, o1);

o2.value_oprnd.mode := register;
o2.value_oprnd.reg := 30;
gen_oprnd(lastnode, 2, o2);

o3.typ := addr_oprnd;
o3.addr_oprnd.basereg := sp;
o3.addr_oprnd.mode := post_index;
o3.addr_oprnd.index := 16;
gen_oprnd(lastnode, 3, o3);

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

i.inst := ret;
gen_inst_node(i, 0);

putcode.putcode;

    p := firstnode;
    while p <> nil do
    begin
      p1 := p^.next_node;
      dispose(p);
      p := p1;
    end
  end {exitcode};
     
end.
