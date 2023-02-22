unit code;

interface

uses config, hdr, t_c, hdrc, utils, putcode;

procedure code;

procedure codeone;

procedure initcode;

procedure exitcode;

implementation

procedure newnode(kind: nodekinds);

{ Allocate a new node and link it to list of nodes
}

  var
    p: nodeptr;

  begin {newnode}
    new(p);
    if lastnode = nil then
      firstnode := p
    else
      lastnode^.next_node := p;
    p^.kind := kind;
    p^.next_node := nil;
    lastnode := p;
  end {newnode};


procedure gen_inst(p: nodeptr;
                   i: insts;
                   sf: boolean;
                   s: boolean;
                   l: oprnd_range {number of operands});

begin
  with p^ do
  begin
    tempcount := 0;
    inst.inst := i;
    inst.sf := sf;
    inst.s := s;
    labeled := labelnextnode;
    oprnd_cnt := l;
  end;
  labelnextnode := false;
end;

procedure gen_inst_node(i: insts;
                        sf: boolean;
                        s: boolean;
                        l: oprnd_range {number of operands});

{ Generate a new instruction node 

  All other fields not specified are cleared to zero, and will normally be
  filled in by the calling procedure.  In particular, tempcount is set to
  zero.

}

  begin {gen_inst_node}
    newnode(instnode);
    gen_inst(lastnode, i, sf, s, l);
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

function reg_oprnd(reg: regindex): oprnd_type;

  var
    o:oprnd_type;
  begin
    o.typ := value_oprnd;
    o.value_oprnd.mode := register;
    o.value_oprnd.reg := reg;
    reg_oprnd := o;
  end;

function immediate_oprnd(value: imm12; shift: boolean): oprnd_type;

  var
    o:oprnd_type;
  begin
    o.typ := value_oprnd;
    o.value_oprnd.reg := noreg;
    o.value_oprnd.mode := immediate;
    o.value_oprnd.value := value;
    o.value_oprnd.shift := shift;
    immediate_oprnd := o;
  end;

function shift_reg_oprnd(reg: regindex; reg_shift: reg_shifts;
                         shift_amount: imm6): oprnd_type;

  var
    o:oprnd_type;
  begin
    o.typ := value_oprnd;
    o.value_oprnd.mode := shift_reg;
    o.value_oprnd.reg := reg;
    o.value_oprnd.reg_shift := reg_shift;
    o.value_oprnd.shift_amount := shift_amount;
    shift_reg_oprnd := o;
  end;

function extend_reg_oprnd(reg: regindex; reg_extend: reg_extends; extend_amount: imm3;
                          extend_signed: boolean): oprnd_type;

  var
    o:oprnd_type;
  begin
    o.typ := value_oprnd;
    o.value_oprnd.mode := extend_reg;
    o.value_oprnd.reg := reg;
    o.value_oprnd.reg_extend := reg_extend;
    o.value_oprnd.extend_amount := extend_amount;
    o.value_oprnd.extend_signed := extend_signed;
    extend_reg_oprnd := o;
  end;

function index_oprnd(mode: addr_oprnd_modes; basereg: regindex; index: integer): oprnd_type;

  var
    o:oprnd_type;
  begin
    o.typ := addr_oprnd;
    o.addr_oprnd.basereg := basereg;
    o.addr_oprnd.mode := mode;
    o.addr_oprnd.index := index;
    index_oprnd := o;
  end;

function reg_offset_oprnd(basereg, reg2: regindex; shift: boolean;
                          extend: reg_extends; signed: boolean): oprnd_type;

  var
    o:oprnd_type;
  begin
    o.typ := addr_oprnd;
    o.addr_oprnd.mode := reg_offset;
    o.addr_oprnd.basereg := basereg;
    o.addr_oprnd.reg2 := reg2;
    o.addr_oprnd.shift := shift;
    o.addr_oprnd.extend := extend;
    o.addr_oprnd.signed := signed;
    reg_offset_oprnd := o;
  end;


function literal_oprnd(lit: integer): oprnd_type;

  var
    o:oprnd_type;
  begin
    o.typ := addr_oprnd;
    o.addr_oprnd.basereg := noreg;
    o.addr_oprnd.mode := literal;
    o.addr_oprnd.literal := lit;
    literal_oprnd := o;
  end;

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

  begin {exitcode}


gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, literal_oprnd(16000));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, index_oprnd(pre_index, sp, -16));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, index_oprnd(post_index, sp, 16));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, index_oprnd(imm_offset, 8, 256));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(18, 1, false, xtx, false));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(18, 2, true, xtx, false));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(3, 4, true, xtx, true));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(3, 4, false, xtx, true));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(3, 4, true, xtx, true));

gen_inst_node(ldr, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

gen_inst_node(ldr, false, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(18, 3, true, xtw, true));

gen_inst_node(ldr, false, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

gen_inst_node(ldrb, false, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

gen_inst_node(ldrsw, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

gen_inst_node(str, true, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

gen_inst_node(str, false, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

gen_inst_node(strh, false, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

gen_inst_node(strb, false, false, 2);
gen_oprnd(lastnode, 1, reg_oprnd(3));
gen_oprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

gen_inst_node(stp, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(29));
gen_oprnd(lastnode, 2, reg_oprnd(30));
gen_oprnd(lastnode, 3, index_oprnd(pre_index, sp, -16));

gen_inst_node(ldp, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(29));
gen_oprnd(lastnode, 2, reg_oprnd(30));
gen_oprnd(lastnode, 3, index_oprnd(post_index, sp, 16));

gen_inst_node(add, false, true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(6));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, reg_oprnd(3));

gen_inst_node(add, true, true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, reg_oprnd(20));

gen_inst_node(add, true, true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, shift_reg_oprnd(4, lsl, 20));

gen_inst_node(add, true, true, 3);
gen_oprnd(lastnode, 3, shift_reg_oprnd(4, lsr, 41));
gen_inst_node(add, true, true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));

gen_inst_node(add, false, true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, shift_reg_oprnd(4, lsl, 20));

gen_inst_node(add, false, true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, shift_reg_oprnd(4, lsr, 21));

gen_inst_node(add, false, true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, shift_reg_oprnd(4, asr, 23));

gen_inst_node(add, false,true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, immediate_oprnd(2332, false));

gen_inst_node(add, false, true, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, immediate_oprnd(2332, true));

gen_inst_node(sub, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

gen_inst_node(sub, true,false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, extend_reg_oprnd(5, xtb, 3, true));

gen_inst_node(sub, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, extend_reg_oprnd(5, xth, 3, false));

gen_inst_node(sub, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, extend_reg_oprnd(5, xtw, 3, true));

gen_inst_node(sub, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(22));
gen_oprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

gen_inst_node(sub, false, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(22));
gen_oprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

gen_inst_node(sub, false, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(22));
gen_oprnd(lastnode, 3, shift_reg_oprnd(17, lsr, 31));

gen_inst_node(sub, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(22));
gen_oprnd(lastnode, 3, shift_reg_oprnd(21, lsr, 61));

gen_inst_node(sub, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, shift_reg_oprnd(3, lsl, 62));

gen_inst_node(sub, true, false, 3);
gen_oprnd(lastnode, 1, reg_oprnd(5));
gen_oprnd(lastnode, 2, reg_oprnd(8));
gen_oprnd(lastnode, 3, shift_reg_oprnd(6, asr, 63));

gen_inst_node(ret, false, false, 0);

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
