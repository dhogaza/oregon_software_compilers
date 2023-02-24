unit code;

interface

uses config, hdr, t_c, hdrc, utils, putcode;

procedure code;

procedure codeone;

procedure initcode;

procedure exitcode;

implementation

function build_inst(inst: insts; sf: boolean; s: boolean): insttype;

var
  i: insttype;

begin
  i.inst := inst;
  i.sf := sf;
  i.s := s;
  build_inst := i;
end;

function nomode_oprnd: oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := nomode;
    o.reg := noreg;
    o.reg2 := noreg;
    nomode_oprnd := o;
  end;

function reg_oprnd(reg: regindex): oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := register;
    o.reg := reg;
    reg_oprnd := o;
  end;

function immediate_oprnd(value: imm12; imm_shift: boolean): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.mode := immediate;
    o.value := value;
    o.imm_shift := imm_shift;
    immediate_oprnd := o;
  end;

function shift_reg_oprnd(reg: regindex; reg_shift: reg_shifts;
                         shift_amount: imm6): oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := shift_reg;
    o.reg := reg;
    o.reg_shift := reg_shift;
    o.shift_amount := shift_amount;
    shift_reg_oprnd := o;
  end;

function extend_reg_oprnd(reg: regindex; reg_extend: reg_extends; extend_amount: imm3;
                          extend_signed: boolean): oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := extend_reg;
    o.reg := reg;
    o.reg_extend := reg_extend;
    o.extend_amount := extend_amount;
    o.extend_signed := extend_signed;
    extend_reg_oprnd := o;
  end;

function index_oprnd(mode: oprnd_modes; reg: regindex; index: integer): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := reg;
    o.mode := mode;
    o.index := index;
    index_oprnd := o;
  end;

function reg_offset_oprnd(reg, reg2: regindex; shift: boolean;
                          extend: reg_extends; signed: boolean): oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := reg_offset;
    o.reg := reg;
    o.reg2 := reg2;
    o.shift := shift;
    o.extend := extend;
    o.signed := signed;
    reg_offset_oprnd := o;
  end;


function literal_oprnd(lit: integer): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.mode := literal;
    o.literal := lit;
    literal_oprnd := o;
  end;


function newnode(kind: nodekinds): nodeptr;

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
    newnode := p;
  end {newnode};


procedure geninst(p: nodeptr;
                   i: insttype;
                   l: oprnd_range {number of operands});

var n: 1..max_oprnds;

begin
  if p = nil then
    p := newnode(instnode);
  with p^ do
  begin
    tempcount := 0;
    inst := i;
    labeled := labelnextnode;
    oprnd_cnt := l;
    for n := 1 to max_oprnds do
      oprnds[n] := nomode_oprnd;
  end;
  labelnextnode := false;
end;

procedure genoprnd(p: nodeptr; 
                   i: oprnd_range; {which operand to generate}
                   o: oprndtype {operand to generate} );

{ Generates the given operand in lastptr.  If the operand contains an offset
dependent on the stack, tempcount is set appropriately.
}

  begin {genoprnd}

    with p^ do
      begin
      if false then {check on what this is all about}
        if o.reg = fp then
          begin
            { code to switch fp to sp if noframe goes here in m68K? }
          end 
        else if o.reg = sp then
          begin
            { code to adjust stack offset goes here in m68K? }
          end;
      p^.oprnds[i] := o;
    end;
  end {genoprnd} ;

Procedure gen1(p: nodeptr;
               i: insttype;
               dst: keyindex);

{ Generate a single operand instruction, using keytable[dst] as
  the destination.
}

  begin {gen1}
    geninst(p, i, 1);
    genoprnd(p, 1, keytable[dst].oprnd);
  end {gen1} ;


procedure gen2(p: nodeptr;
               i: insttype;
               dst, src: keyindex);

{ Generate a double operand instruction, using keytable[src/dst] as
  the two operands.
}


  begin {gen2}
    geninst(p, i, 2);
    genoprnd(p, 1, keytable[dst].oprnd);
    genoprnd(p, 2, keytable[src].oprnd);
  end {gen2} ;


procedure gen3(p: nodeptr;
               i: insttype;
               dst, src1, src2: keyindex);

{ Generate a triple operand instruction.
}


  begin {gen3}
    geninst(p, i, 2);
    genoprnd(p, 1, keytable[dst].oprnd);
    genoprnd(p, 2, keytable[src1].oprnd);
    genoprnd(p, 3, keytable[src2].oprnd);
  end {gen3} ;


procedure gen4(p: nodeptr;
               i: insttype;
               dst, src1, src2, src3: keyindex);

{ Generate a quadruple operand instruction.
}


  begin {gen4}
    geninst(p, i, 2);
    genoprnd(p, 1, keytable[dst].oprnd);
    genoprnd(p, 2, keytable[src1].oprnd);
    genoprnd(p, 3, keytable[src2].oprnd);
    genoprnd(p, 4, keytable[src3].oprnd);
  end {gen4} ;

procedure setcommonkey;

{ Check the key specified in the pseudoinstruction just read, and if
  it is a new key initialize its fields from the data in the pseudo-
  instruction.

  This uses the global "key", which is the operand for the latest
  pseudoinstruction.
}


  begin {setcommonkey}
    with keytable[key] do
      begin
      if key >= stackcounter then compilerabort(manykeys);
      if key > lastkey then
        begin
        access := noaccess;
        regsaved := false;
        properreg := key; {simplifies certain special cases}
        properreg2 := key;
        validtemp := false;
        reg2saved := false;
        regvalid := true;
        reg2valid := true;
        packedaccess := false;
        joinreg := false;
        joinreg2 := false;
        signed := true;
        signlimit := 0;
        knownword := false;
        oprnd := nomode_oprnd;
        end
      else if (key <> 0) and (access <> valueaccess) then
        begin
        write('setcommonkey screwup:', key: 1,', ',lastkey:1);
        compilerabort(inconsistent);
        end;
      len := pseudoinst.len;
      refcount := pseudoinst.refcount;
      copycount := pseudoinst.copycount;
      copylink := 0;
      tempflag := false;
      instmark := nil;
      end;
  end {setcommonkey} ;


procedure settemp(lth: datarange; {length of data referenced}
                  o: oprndtype);

{ Set up a temporary key entry with the characteristics specified.  This has
  nothing to do with runtime temp administration.  It strictly sets up a key
  entry.  Negative key values are used for these temp entries, and they are
  basically administered as a stack using "tempkey" as the stack pointer.
}


  begin {settemp}
    if tempkey = lowesttemp then compilerabort(interntemp);
    tempkey := tempkey - 1;
    with keytable[tempkey] do
      begin
      len := lth;
      refcount := 0;
      copycount := 0;
      copylink := 0;
      properreg := 0;
      properreg2 := 0;
      access := valueaccess;
      tempflag := true;
      regsaved := false;
      reg2saved := false;
      regvalid := true;
      reg2valid := true;
      packedaccess := false;
      signed := true;
      signlimit := 0;
      oprnd := o;
      end;
  end {settemp} ;

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


geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, literal_oprnd(16000));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, index_oprnd(pre_index, sp, -16));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, index_oprnd(post_index, sp, 16));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, index_oprnd(imm_offset, 8, 256));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 1, false, xtx, false));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 2, true, xtx, false));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(3, 4, true, xtx, true));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(3, 4, false, xtx, true));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(3, 4, true, xtx, true));

geninst(nil, build_inst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

geninst(nil, build_inst(ldr, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 3, true, xtw, true));

geninst(nil, build_inst(ldr, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

geninst(nil, build_inst(ldrb, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

geninst(nil, build_inst(ldrsw, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, build_inst(str, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, build_inst(str, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, build_inst(strh, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, build_inst(strb, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, build_inst(stp, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(29));
genoprnd(lastnode, 2, reg_oprnd(30));
genoprnd(lastnode, 3, index_oprnd(pre_index, sp, -16));

geninst(nil, build_inst(ldp, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(29));
genoprnd(lastnode, 2, reg_oprnd(30));
genoprnd(lastnode, 3, index_oprnd(post_index, sp, 16));

geninst(nil, build_inst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(6));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, reg_oprnd(3));

geninst(nil, build_inst(add, true, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, reg_oprnd(20));

geninst(nil, build_inst(add, true, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, lsl, 20));

geninst(nil, build_inst(add, true, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, lsr, 41));

geninst(nil, build_inst(add, true, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 1, reg_oprnd(5));

geninst(nil, build_inst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, lsl, 20));

geninst(nil, build_inst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, lsr, 21));

geninst(nil, build_inst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, asr, 23));

geninst(nil, build_inst(add, false,true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, immediate_oprnd(2332, false));

geninst(nil, build_inst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, immediate_oprnd(2332, true));

geninst(nil, build_inst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

geninst(nil, build_inst(sub, true,false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtb, 3, true));

geninst(nil, build_inst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xth, 3, false));

geninst(nil, build_inst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtw, 3, true));

geninst(nil, build_inst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(22));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

geninst(nil, build_inst(sub, false, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(22));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

geninst(nil, build_inst(sub, false, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(22));
genoprnd(lastnode, 3, shift_reg_oprnd(17, lsr, 31));

geninst(nil, build_inst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(22));
genoprnd(lastnode, 3, shift_reg_oprnd(21, lsr, 61));

geninst(nil, build_inst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(3, lsl, 62));

geninst(nil, build_inst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(6, asr, 63));

geninst(nil, build_inst(ret, false, false), 0);

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
