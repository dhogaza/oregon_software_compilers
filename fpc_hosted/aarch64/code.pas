unit code;

interface

uses config, hdr, t_c, hdrc, utils, putcode;

procedure code;

procedure codeone;

procedure initcode;

procedure exitcode;

implementation

function buildinst(inst: insts; sf: boolean; s: boolean): insttype;

var
  i: insttype;

begin
  i.inst := inst;
  i.sf := sf;
  i.s := s;
  buildinst := i;
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

function immediate_oprnd(value: imm16; imm_shift: unsigned): oprndtype;

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
      lastnode^.nextnode := p;
    p^.kind := kind;
    p^.nextnode := nil;
    lastnode := p;
    newnode := p;
  end {newnode};

function newinsertbefore(before: nodeptr; kind: nodekinds): nodeptr;

{ Allocate a new node before the given node.  If before is nil, we assume
  this is the first node of the block.  We're not really concerned about
  the efficiency of this code today.  Maybe tomorrow.
}

  var
    p, p1: nodeptr;

  begin {newinsertbefore}
    new(p);
    p^.kind := kind;
    p^.nextnode := before;
    if before = nil then
      begin
      firstnode := p;
      lastnode := p;
      end
    else
      begin
      p1 := firstnode;
      while p1^.nextnode <> before do
        p1 := p1^.nextnode;
      p1^.nextnode := p;
      end;
    newinsertbefore := p;
  end {newinsertbefore};

function newinsertafter(after: nodeptr; kind: nodekinds): nodeptr;

{ Allocate a new node after the given node.
}

  var
    p: nodeptr;

  begin {newinsertafter}
    new(p);
    p^.kind := kind;
    p^.nextnode := after^.nextnode;
    after^.nextnode := p;
    if after = lastnode then
      lastnode := p;
    newinsertafter := p;
  end {newinsertafter};

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

Procedure gen1p(p: nodeptr;
                i: insttype;
                o1: keyindex);

{ Generate a single operand instruction, using keytable[dst] as
  the destination.
}

  begin {gen1p}
    geninst(p, i, 1);
    genoprnd(p, 1, keytable[o1].oprnd);
  end {gen1p} ;

Procedure gen1(i: insttype;
               o1: keyindex);

{ Generate a single operand instruction, using keytable[dst] as
  the destination.
}

  begin {gen1}
    gen1p(newnode(instnode),i, o1);
  end {gen1} ;


procedure gen2p(p: nodeptr;
                i: insttype;
                o1, o2: keyindex);

{ Generate a double operand instruction, using keytable[src/dst] as
  the two operands.
}


  begin {gen2p}
    geninst(p, i, 2);
    genoprnd(p, 1, keytable[o1].oprnd);
    genoprnd(p, 2, keytable[o2].oprnd);
  end {gen2p} ;


procedure gen2(i: insttype;
               o1, o2: keyindex);

{ Generate a double operand instruction, using keytable[src/dst] as
  the two operands.
}


  begin {gen2}
    gen2p(newnode(instnode), i, o1, o2);
  end {gen2} ;


procedure gen3p(p: nodeptr;
                i: insttype;
                o1, o2, o3: keyindex);

{ Generate a triple operand instruction.
}


  begin {gen3p}
    geninst(p, i, 3);
    genoprnd(p, 1, keytable[o1].oprnd);
    genoprnd(p, 2, keytable[o2].oprnd);
    genoprnd(p, 3, keytable[o3].oprnd);
  end {gen3p} ;


procedure gen3(i: insttype;
               o1, o2, o3: keyindex);

{ Generate a triple operand instruction.
}


  begin {gen3}
    gen3p(newnode(instnode), i, o1, o2, o3);
  end {gen3} ;


procedure gen4p(p: nodeptr;
                i: insttype;
                o1, o2, o3, o4: keyindex);

{ Generate a quadruple operand instruction.
}


  begin {gen4p}
    geninst(p, i, 4);
    genoprnd(p, 1, keytable[o1].oprnd);
    genoprnd(p, 2, keytable[o2].oprnd);
    genoprnd(p, 3, keytable[o3].oprnd);
    genoprnd(p, 4, keytable[o4].oprnd);
  end {gen4p} ;


procedure gen4(i: insttype;
               o1, o2, o3, o4: keyindex);

{ Generate a quadruple operand instruction.
}


  begin {gen4}
    gen4p(newnode(instnode), i, o1, o2, o3, o4);
  end {gen4} ;

procedure adjustregcount(k: keyindex; {operand to adjust}
                         delta: integer {amount to adjust count by});

{ Adjusts the register reference count for any registers used in the
  specified operand.  If a register pair is used, both registers will
  be adjusted by the same amount.
}


  begin
    with keytable[k], oprnd do
      if access = valueaccess then
        case mode of
          register, shift_reg, extend_reg, pre_index, post_index,
          imm_offset:
            if regvalid then
              registers[reg] := registers[reg] + delta;
          reg_offset:
            begin
            if regvalid then
              registers[reg] := registers[reg] + delta;
            if reg2valid then
              registers[reg2] := registers[reg2] + delta;
            end;
          otherwise
          end;
  end {adjustregcount} ;

procedure bumptempcount(k: keyindex; {key of temp desired}
                        delta: integer {amount to adjust ref count} );

{ Increment the reference of any temp containing the value for key "k".
  If there is no temp assigned, this is a no-op
}


  begin
    with keytable[k] do
      begin
      if regsaved and (properreg >= stackcounter) then
        with keytable[properreg] do
          begin
          if (delta < - refcount) then { overflow is rarely a problem }
            begin
            write('BUMPTEMPCOUNT, refcount underflow');
            compilerabort(inconsistent);
            end;
          refcount := refcount + delta;
          end;
      if reg2saved and (properreg2 >= stackcounter) then
        with keytable[properreg2] do
          begin
          if (delta < - refcount) then { overflow is rarely a problem }
            begin
            write('BUMPTEMPCOUNT, refcount underflow');
            compilerabort(inconsistent);
            end;
          refcount := refcount + delta;
          end;
      end;
  end {bumptempcount} ;


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

procedure setvalue(o: oprndtype);

begin {setvalue}
  with keytable[key] do
    begin
    keytable[key].access := valueaccess;
    keytable[key].oprnd := o;
    adjustregcount(key, refcount);
    bumptempcount(key, refcount);
    end;
end {setvalue} ;

procedure setkeyvalue(k: keyindex);

{call setvalue with fields from keytable[k]
}


  begin
    with keytable[k] do
      begin
      keytable[key].packedaccess := packedaccess;
      setvalue(oprnd);
      keytable[key].signed := signed;
      keytable[key].signlimit := signlimit;
      end;
  end {setkeyvalue} ;


procedure setallfields(k: keyindex);

{similar to setkeyvalue but also copies properaddress, packedrecord,
 etc.  Can only be used if we are copying a keyvalue and not changing
 regset, mode, or offset, as in dovarx.
}


  begin
    with keytable[k] do
      begin
      keytable[key].regsaved := regsaved;
      keytable[key].reg2saved := reg2saved;
      keytable[key].regvalid := regvalid;
      keytable[key].reg2valid := reg2valid;
      keytable[key].properreg := properreg;
      keytable[key].properreg2 := properreg2;
      keytable[key].tempflag := tempflag;
      setkeyvalue(k);
      end;
  end {setallfields} ;

procedure settemp(l: unsigned; o: oprndtype);

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
      len := l;
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

procedure dereference(k: keyindex {operand} );

{ Reduce all appropriate reference counts for this key.  This is called
  when a particular reference is completed.
}


  begin
    if k > 0 then
      begin
      with keytable[k] do
        begin
        if refcount = 0 then
          begin
          write('DEREFERENCE, refcount < 0');
          compilerabort(inconsistent);
          end;
        refcount := refcount - 1;
        end;
      bumptempcount(k, - 1);
      adjustregcount(k, - 1);
      end;
  end {dereference} ;

procedure derefboth;

{ Reduce the reference counts on the global left and right operands.
  This is called after generating a binary operation.
}


  begin
    dereference(left);
    dereference(right);
  end {derefboth} ;

procedure initblock;

{ Initialize global variables for a new block.
}

  var
    i: integer; {general purpose induction variable}

  begin
    maxstackdepth := 0;
    paramlist_started := false; {reset switch}

    while (currentswitch <= lastswitch) and
          ((switches[currentswitch].mhi = gethi) and
          (switches[currentswitch].mlow <= getlow) or
          (switches[currentswitch].mhi < gethi)) do
      with switches[currentswitch] do
        begin
        switchcounters[s] := switchcounters[s] + v;
        currentswitch := currentswitch + 1;
        end;

    openarray_base := nil; { Modula2 only, but initialization needed for all }
    firstbr := nil;
    lastnode := nil;
    nextlabel := 0;
    forsp := 0;
    oktostuff := true; {until proven otherwise}
    dontchangevalue := 0;
    settargetused := false;
    firststmt := 0;

    contextsp := 1;
    context[1].keymark := 1;
    context[1].clearflag := false;
    context[1].lastbranch := nil;
    loopsp := 0;

    for i := 0 to maxreg do
      begin
      with loopstack[0].regstate[i] do
        begin
        active := false;
        killed := false;
        used := false;
        stackcopy := 0;
        end;

      with loopstack[0].fpregstate[i] do
        begin
        active := false;
        killed := false;
        used := false;
        stackcopy := 0;
        end;
      end;

    loopoverflow := 0;
    lastkey := 0;

    {initialize the keytable to empty}

    for i := lowesttemp to keysize do
      with keytable[i] do
        begin
        access := noaccess;
        properreg := i;
        properreg2 := i;
        regvalid := false;
        reg2valid := false;
        regsaved := false;
        reg2saved := false;
        validtemp := false;
        tempflag := false;
        end;

    keytable[keysize].refcount := 1;
    keytable[keysize - 1].refcount := 1;

    keytable[loopsrc].refcount := 255;
    keytable[loopsrc1].refcount := 255;
    keytable[loopdst].refcount := 255;

    {zero out all register data}
    for i := 0 to maxreg do
      begin
      regused[i]:=false;
      fpregused[i]:=false;
      registers[i] := 0;
      fpregisters[i] := 0;
      end;

    {initialize temp allocation vars}
    stackcounter := keysize - 1;
    stackoffset := 0;

  end {initblock} ;

procedure stmtbrkx;

{ Generate statement information for the macro file and later for gdb.
}

  var
    p: nodeptr;

  begin
    if firststmt = 0 then firststmt := pseudoinst.oprnds[1];
    p := newnode(stmtnode);
    with p^ do
      begin
      stmtno := pseudoinst.oprnds[1];
      current_stmt := pseudoinst.oprnds[1];
      sourceline := pseudoinst.oprnds[2];
      current_line := pseudoinst.oprnds[2] - lineoffset;
      filename := len;
      end;
  end; {stmtbrkx}

procedure dointx;

{ Access a constant integer operand.  The value is in oprnds[1].
  This simply sets up the key for the value, with immediate mode.
}


  begin {dointx}
    keytable[key].access := valueaccess;
    keytable[key].len := pseudoinst.len;
    keytable[key].signed := true;
    keytable[key].oprnd := immediate_oprnd(pseudoinst.oprnds[1], 0);
  end {dointx} ;


{
procedure dofptrx;

{ Access a constant function pointer.  The procref is in oprnds[1].
}


  begin {dofptrx}
    keytable[key].access := valueaccess;
    keytable[key].len := pseudoinst.len;
    keytable[key].signed := false;
    keytable[key].oprnd.m := usercall;
    keytable[key].oprnd.offset := pseudoinst.oprnds[1];
    keytable[key].knowneven := true;
  end {dofptrx} ;
}

{
procedure dorealx;

{ Access a constant real operand.  The value is given in oprnds[1]
  and oprnds[2].  Travrs scans and generates all constants prior to
  generating code, so these may be inserted in the code stream directly
  and an absolute reference to them inserted in the key.
}

  const
    word_zero = false;
    word_one = true;

  var
    kluge: record
      case boolean of
        false: (i: integer);
        true: (damn: packed array [boolean] of - 32767..32767);
      end;


  begin {dorealx}
    with pseudoinst do
      if oprnds[3] <> 1 then
        begin
        write('Invalid real number intermediate code');
        compilerabort(inconsistent);
        end
      else with keytable[key].oprnd do
        begin
        m := immediatelong;
        reg := 0;
        indxr := 0;
        flavor := float;

        if len = quad then {double precision}
          if mc68881 then
            begin
            m := immediatequad;
            kluge.i := oprnds[1];
            offset1 := (kluge.damn[word_zero] * 256) * 256
              + (kluge.damn[word_one] and 65535);
              { The "and" defeats sign extension }
            kluge.i := oprnds[2];
            offset := (kluge.damn[word_zero] * 256) * 256
              + (kluge.damn[word_one] and 65535);
{            begin
            genlongword(offset);
            genlongword(offset1);
            offset := highcode;
            offset1 := 0;
            highcode := highcode + 8;
            m := pcrelative;
}            end
          else
            begin
            kluge.i := oprnds[1];
            offset1 := (kluge.damn[word_zero] * 256) * 256
              + (kluge.damn[word_one] and 65535);
              { The "and" defeats sign extension }
            kluge.i := oprnds[2];
            offset := (kluge.damn[word_zero] * 256) * 256
              + (kluge.damn[word_one] and 65535);
            end
        else {single precision}
          begin
          kluge.i := oprnds[1];
          offset := kluge.damn[true];
          offset1 := kluge.damn[false];
          end;
        end;        
  end {dorealx} ;
}

procedure dolevelx(ownflag: boolean {true says own sect def} );

{ Generate a reference to the data area for the level specified in
  opernds[1].  This is a direct reference to the global area for level 1,
  and a reference relative to sp for the local frame.  There is another
  procedure, dolevelx, in genblk which handles intermediate level references.
  These two cases (global+current vs. intermediate levels) are split up
  purely to save space and to facilitate inclusion of blockcodex in this
  overlay.
}

  var
    reg: regindex; {reg for indirect reference}


  begin
    keytable[key].access := valueaccess;
    with keytable[key], oprnd do
      begin
      if ownflag then
        begin
        end
      else if left = 0 then
        begin
{
        m := abslong;
        offset := 0;}
        end
      else if left = 1 then
        setvalue(index_oprnd(imm_offset, gp, 0))
      else if left = level then
        setvalue(index_oprnd(imm_offset, fp, 0))
      { we don't do origin else if left = 0 then setvalue(abslong, 0, 0, false, 0, 0)}
      else if left = level - 1 then setvalue(index_oprnd(imm_offset, sl, 0))
      else
        begin
{ intermediate level 
    address(target);
        settempareg(getareg);
        gensimplemove(target, tempkey);
        setvalue(relative, keytable[tempkey].oprnd.reg, 0, false, 0, 0);
}
        end;
      len := long;
      end;
  end {dolevelx} ;

procedure blockcodex;

{ Generate code for the beginning of a block.

  If this is a procedure block, standard procedure entry code is generated.
}

  var
    i: integer; {general use induction variable}
    p: nodeptr;

  begin {blockcodex}

    firstnode := nil;
    lastnode := nil;
    context[1].lastbranch := nil;
    context[1].firstnode := nil;
    context[1].keymark := lastkey + 1;
    context[0] := context[1];
    lastfpreg := maxreg - target;
    lastreg := sl - left;
    lineoffset := pseudoinst.len;

    with proctable[blockref] do
      begin
      if intlevelrefs then
      {generate indirect moves before entry}
        begin
        settemp(quad, reg_oprnd(sl));
        settemp(quad, index_oprnd(imm_offset, sl, 0));
        for i := 1 to levelspread - 1 do
          begin
          gen2(buildinst(ldr, true, false), tempkey + 1, tempkey);
          end;
        end;
      end;
    p := newnode(proclabelnode);
    p^.proclabel := blockref;
    codeproctable[blockref].proclabelnode := p;
    stackoffset := 0;

  end {blockcodex} ;

procedure putblock;

{ After all code has been generated for a block, this procedure generates
  cleanup code, calls the various peep-hole optimization
  routines, and finally outputs the macro code.
}

  var
    i: regindex; {induction var for scanning registers}
    blockcost: integer; {max bytes allocated on the stack}
    p, p1: nodeptr;
    fptemp, sptemp: keyindex;
    regcost, fpregcost: integer; {bytes allocated to save registers on stack}
    regoffset, fpregoffset: array [regindex] of integer; {offset for each reg}
    fpregssaved : array [0..23] of boolean;
    regssaved : array [0..23] of boolean;
    reg: integer; { temp for dummy register }

  begin {PutBlock}
    { save procedure symbol table index }


    { Clean up stack, and make sure we did so
    }
{

    if mc68881 then context[contextsp].lastbranch := fpsavereginst + 3
    else context[contextsp].lastbranch := savereginst + 3;

    adjusttemps;
}

    { One more temp is needed for 68881 code.  Proctrailer kills it.
      Another temp is used by Modula2 for openarrays.  Proctrailer kills
      it too.
    }
    if stackcounter < keysize - 2 then
      begin
      compilerabort(undeltemps);
{
      writeln('Excess temps: ', keysize - 2 - stackcounter: 1, ', Bytes left: ',
             stackoffset + keytable[stackcounter].oprnd.offset: 1);
}
      end;

    { eventually peephole optimizations happen now }

    regcost := 0;
    { we only save registers x19 ... }
    for i := pr + 1 to sl - 1 do
      if regused[i] then
        begin
        regcost := regcost + quad;
        regoffset[i] := regcost;
        end;

    { 1. convert all negative sp offsets to positive.
      2. gen sub sp, sp, stacksize/strp in prologue
      3. gen ldp/add sp, sp, stacksize in postlogue
    }

{    if proctable[blockref].opensfile then
      begin
      settemp(long, relative, sp, 0, false, (fpregcost - 96) * ord(mc68881) +
              regcost - 13 * long, 0, 1, unknown);
      gen1(pea, long, tempkey);
      tempkey := tempkey + 1;
      settempimmediate(long, blksize);
      settempreg(long, autod, sp);
      gen2(move, long, tempkey + 1, tempkey);
      tempkey := tempkey + 2;
      callsupport(libcloseinrange);
      settempimmediate(word, 8);  { Clean up stack }
      settempareg(sp);
      gen2(adda, word, tempkey + 1, tempkey);
      tempkey := tempkey + 1;
      end;
}

    { procedure entry code. Grow stack,save link and frame pointer registers,
     save used callee-saved registers.
    }

    p := newinsertafter(codeproctable[blockref].proclabelnode, instnode);
    settemp(quad, reg_oprnd(sp));
    settemp(quad, immediate_oprnd(blksize, 0));
    gen3p(p, buildinst(sub, true, false), tempkey + 1, tempkey + 1, tempkey);

    p := newinsertafter(p, instnode);
    settemp(quad, reg_oprnd(fp));
    settemp(quad, reg_oprnd(link));
    settemp(quad, index_oprnd(imm_offset, sp, 0));
    gen3p(p, buildinst(stp, true, false), tempkey + 1, tempkey + 2, tempkey);

    p := newinsertafter(p, instnode);
    settemp(quad, immediate_oprnd(0, 0));
    gen3p(p, buildinst(add, true, false), tempkey + 3, tempkey + 5, tempkey);

    { procedure exit code. Restore callee-saved registers, link and frame pointer
      registers, and shrink stack.
    } 

    p := newnode(instnode);
    gen3p(p, buildinst(ldp, true, false), tempkey + 2, tempkey + 3, tempkey + 1);

    p := newinsertafter(p, instnode);
    gen3p(p, buildinst(add, true, false), tempkey + 5, tempkey + 5, tempkey + 4);

    tempkey := tempkey + 5;

    geninst(nil, buildinst(ret, false, false), 0);

    { write output code }
    if switcheverplus[outputmacro] then putcode.putcode;

  end { PutBlock } ;

procedure blockexitx;

{ Finish up after one procedure block.
}
  var
    i: regindex;
    anyfound: boolean;

  begin {blockexitx}
    if (level <> 1) or (switchcounters[mainbody] > 0) then putblock;
    if (blockref = 0) or (level = 1) then
      mainsymbolindex := pseudoinst.oprnds[1];

    { Complain about any registers that have a non-zero reference count at the
      end of the procedure.  This is not a fatal condition because we will
      only generate code that uses more registers than it should, but it
      is usually correct.
    }
    if switcheverplus[test] then
      begin
      anyfound := false;
      for i := 0 to maxreg do
        begin
        if registers[i] <> 0 then anyfound := true;
        if fpregisters[i] <> 0 then anyfound := true;
        end;

      if anyfound then
        begin
        write('Found registers with non-zero use counts');
        compilerabort(inconsistent); { Display procedure name }

        for i := 0 to maxreg do
          if registers[i] <> 0 then
            write('  x', i:1, ' = ', registers[i]:1);

        for i := 0 to maxreg do
          if fpregisters[i] <> 0 then
            write('  fp', i:1, ' = ', fpregisters[i]:1);

        writeln;
        end;
      end;
  end   {blockexitx};


procedure blockentryx;

{ Called at the beginning of every block, after a "blockentry" pseudo-op
  has been read.

  This just sets up to generate code and saves data about the block.
}

  var
    i: regindex;

  begin {blockentryx}
    initblock;
    with pseudoinst do
      begin
      blockref := oprnds[1];
      paramsize := oprnds[2];
      { global parameters aren't stored on the stack, kludging here
        rather fixing in the frontend.
      }
      if blockref = 0 then blksize := 0
      else blksize := oprnds[3];
      end;
    level := proctable[blockref].level;
    blockusesframe := switcheverplus[framepointer]
	or ((language = modula2) and proctable[blockref].needsframeptr);
    for i := 0 to maxreg do
      begin
      context[1].bump[i] := false;
      context[1].fpbump[i] := false;
      registers[i] := 0;
      fpregisters[i] := 0;
      end;
  end {blockentryx} ;


procedure regtempx;

{ Generate a reference to a local variable permanently assigned to a
  general register.  "pseudoinst.oprnds[3]" contains the number of the
  temp register assigned, and oprnds[1] is the variable access being
  so assigned.
}


  begin
    { address(left) in mc68000 codgen, simplified here because regtemp is
      not based on volatile registers and I've not implemented address()
      yet.
    }
    dereference(left);
    setvalue(reg_oprnd(pr + pseudoinst.oprnds[3]));
    regused[pr + pseudoinst.oprnds[3]] := true;
  end {regtempx} ;

procedure dovarx(s: boolean {signed variable reference} );

{ Defines the left operand as a variable reference and sets the
  result "key" to show this.

  This is used by the "dovar" and "dounsvar" pseudo-ops.
}


  begin
    setallfields(left);
    dereference(left);
    with keytable[key] do
      begin
      signed := s;
      if packedaccess then signlimit := (len - 1) div bitsperunit + 1
      else signlimit := len;
      end;
  end {dovarx} ;

{ Just a temporary hack }
procedure movlitintx;
  begin
    setallfields(left);
    dereference(left);
    settemp(len, immediate_oprnd(right, 0));
    gen2(buildinst(movz, len = quad, false), left, tempkey); 
  end;

procedure codeselect;

{ Generate code for one of the pseudoops handled by this part of the
  code generator.
}

  begin {codeselect}
    tempkey := loopcount - 1;
    setcommonkey;
    use_preferred_key := false; {code generator flag}
    case pseudoinst.op of
      doint, doptr: dointx;
      dolevel:  dolevelx(false);
      doown: dolevelx(true);
      blockentry: blockentryx;
      blockcode: blockcodex;
      blockexit: blockexitx;
{
      doreal: dorealx;
      dofptr: dofptrx;
}
      stmtbrk: stmtbrkx;
{
      copyaccess: copyaccessx;
      clearlabel: clearlabelx;
      savelabel: savelabelx;
      restorelabel: restorelabelx;
      joinlabel: joinlabelx;
      pseudolabel: pseudolabelx;
      pascallabel: pascallabelx;
      pascalgoto: pascalgotox;
      defforlitindex: defforindexx(true, true);
      defforindex: defforindexx(true, false);
      defunsforlitindex: defforindexx(false, true);
      defunsforindex: defforindexx(false, false);
      fordntop: fortopx(blt, blo);
      fordnbottom: forbottomx(false, sub, bge, bhs);
      fordnimproved: forbottomx(true, sub, bge, bhs);
      foruptop: fortopx(bgt, bhi);
      forupbottom: forbottomx(false, add, ble, bls);
      forupimproved: forbottomx(true, add, ble, bls);
      forupchk: forcheckx(true);
      fordnchk: forcheckx(false);
      forerrchk: forerrchkx;
      casebranch: casebranchx;
      caseelt: caseeltx;
      caseerr: caseerrx;
      dostruct: dostructx;
      doset: dosetx;
      dolevel: dolevelx;
}
      dovar: dovarx(true);
      dounsvar, doptrvar, dofptrvar: dovarx(false);
{
      doext: doextx;
      indxchk: checkx(false, index_error);
      rangechk: checkx(true, range_error);
      congruchk: checkx(true, index_error);
}
      regtemp: regtempx;
{
      ptrtemp: ptrtempx;
      realtemp: realtempx;
      indxindr: indxindrx;
      indx: indxx;
      aindx: aindxx;
      pindx: pindxx;
      paindx: paindxx;
      createfalse: createfalsex;
      createtrue: createtruex;
      createtemp: createtempx;
      jointemp: jointempx;
      addr: addrx;
      setinsert: setinsertx;
      inset: insetx;
      movint, returnint: movintx;
      movptr, returnptr, returnfptr: movx(false, areg, @getareg);
}
      movlitint: movlitintx;
{
      movlitptr: movlitptrx;
      movreal, returnreal: movrealx;
      movlitreal: movlitrealx;
      movstruct, returnstruct: movstructx(false, true);
      movstr: movstrx;
      movcstruct: movcstructx;
      movset: movstructx(true, true);
      addstr: addstrx;
      addint: integerarithmetic(add);
      subint, subptr: integerarithmetic(sub);
      mulint: mulintx;
      stddivint: divintx(true);
      divint: divintx(false);
      getquo: getremquox(false);
      getrem: getremquox(true);
      shiftlint: shiftlintx(false);
      shiftrint: shiftlintx(true);
      negint: unaryintx(neg);
      incint: incdec(add, false);
      decint: incdec(sub, false);
      orint: integerarithmetic(orinst);
      andint: integerarithmetic(andinst);
      xorint: xorintx;
      addptr: addptrx;
      compbool: incdec(add, true);
      compint: unaryintx(notinst);
      addreal: realarithmeticx(true, libfadd, libdadd, fadd);
      subreal: realarithmeticx(false, libfsub, libdsub, fsub);
      mulreal: realarithmeticx(true, libfmult, libdmult, fmul);
      divreal: realarithmeticx(false, libfdiv, libddiv, fdiv);
      negreal: negrealx;
      addset: setarithmetic(orinst, false);
      subset: setarithmetic(andinst, true);
      mulset: setarithmetic(andinst, false);
      divset: setarithmetic(eor, false);
      stacktarget: stacktargetx;
      makeroom: makeroomx;
      callroutine: callroutinex(true);
      unscallroutine: callroutinex(false);
      sysfnstring: sysfnstringx;
      sysfnint: sysfnintx;
      sysfnreal: sysfnrealx;
      castreal: castrealx;
      castrealint: castrealintx;
      castint, castptr: castintx;
      loopholefn, castptrint, castintptr, castfptrint, castintfptr:
	loopholefnx;
      sysroutine: sysroutinex;
      chrstr: chrstrx;
      arraystr: arraystrx;
      flt: fltx;
      pshint, pshptr: pshx;
      pshfptr: pshfptrx;
      pshlitint: pshlitintx;
      pshlitptr, pshlitfptr: pshlitptrx;
      pshlitreal: pshlitrealx;
      pshreal: pshx;
      pshaddr: pshaddrx;
      pshstraddr: pshstraddrx;
      pshproc: pshprocx;
      pshstr: pshstrx;
      pshstruct, pshset: pshstructx;
      fmt: fmtx;
      setbinfile: setbinfilex;
      setfile: setfilex;
      closerange: closerangex;
      copystack: copystackx;
      rdint: rdintcharx(libreadint, defaulttargetintsize);
      rdchar: rdintcharx(libreadchar, byte);
      rdreal: rdintcharx(libreadreal, len);
      rdst:
        if filenamed then callandpop(libreadstring, 2)
        else callandpop(libreadstringi, 2);
      rdxstr: rdxstrx;
      rdbin: callsupport(libget);
      wrbin: callsupport(libput);
      wrint: wrcommon(libwriteint, 12);
      wrchar: wrcommon(libwritechar, 1);
      wrst: wrstx(true);
      wrxstr: wrstx(false);
      wrbool: wrcommon(libwritebool, 5);
      wrreal: wrrealx;
      jump: jumpx(pseudoinst.oprnds[1], false);
      jumpf: jumpcond(true);
      jumpt: jumpcond(false);

      eqreal: cmprealx(beq, libdeql, fbngl);
      neqreal: cmprealx(bne, libdeql, fbgl);
      lssreal: cmprealx(blt, libdlss, fblt);
      leqreal: cmprealx(ble, libdlss, fble);
      geqreal: cmprealx(bge, libdgtr, fbge);
      gtrreal: cmprealx(bgt, libdgtr, fbgt);

      eqint: cmpx(beq, beq, dreg, @getdreg);
      eqptr, eqfptr: cmpx(beq, beq, areg, @getareg);
      neqint: cmpx(bne, bne, dreg, @getdreg);
      neqptr, neqfptr: cmpx(bne, bne, areg, @getareg);
      leqint, leqptr: cmpx(ble, bls, dreg, @getdreg);
      geqint, geqptr: cmpx(bge, bhs, dreg, @getdreg);
      lssint, lssptr: cmpx(blt, blo, dreg, @getdreg);
      gtrint, gtrptr: cmpx(bgt, bhi, dreg, @getdreg);

      eqstruct: cmpstructx(beq);
      neqstruct: cmpstructx(bne);
      leqstruct: cmpstructx(ble);
      geqstruct: cmpstructx(bge);
      lssstruct: cmpstructx(blt);
      gtrstruct: cmpstructx(bgt);

      eqstr: cmpstrx(beq);
      neqstr: cmpstrx(bne);
      leqstr: cmpstrx(ble);
      geqstr: cmpstrx(bge);
      lssstr: cmpstrx(blt);
      gtrstr: cmpstrx(bgt);

      eqlitreal: cmplitrealx(beq, libdeql, fbngl);
      neqlitreal: cmplitrealx(bne, libdeql, fbgl);
      lsslitreal: cmplitrealx(blt, libdlss, fblt);
      leqlitreal: cmplitrealx(ble, libdlss, fble);
      gtrlitreal: cmplitrealx(bgt, libdgtr, fbgt);
      geqlitreal: cmplitrealx(bge, libdgtr, fbge);

      eqlitptr, eqlitfptr: cmplitptrx(beq);
      neqlitptr, neqlitfptr: cmplitptrx(bne);

      eqlitint: cmplitintx(beq, beq, beq);
      neqlitint: cmplitintx(bne, bne, bne);
      leqlitint: cmplitintx(ble, bls, beq);
      geqlitint: cmplitintx(bge, bhs, bra);
      lsslitint: cmplitintx(blt, blo, nop);
      gtrlitint: cmplitintx(bgt, bhi, bne);

      eqset: cmpstructx(beq);
      neqset: cmpstructx(bne);
      geqset: cmpsetinclusion(left, right);
      leqset: cmpsetinclusion(right, left);

      postint: postintptrx(false);
      postptr: postintptrx(true);
      postreal: postrealx;

      ptrchk: ptrchkx;
      definelazy: definelazyx;
      restoreloop: restoreloopx;
      startreflex: dontchangevalue := dontchangevalue + 1;
      endreflex: dontchangevalue := dontchangevalue - 1;
      cvtrd: cvtrdx;
      cvtdr: cvtdrx; { SNGL function }
      dummyarg: dummyargx;
      dummyarg2: dummyarg2x;
      openarray: openarrayx;
      saveactkeys: saveactivekeys;
}
      otherwise
        begin
        {write('Not yet implemented: ', ord(pseudoinst.op): 1);
        compilerabort(inconsistent);}
        end;
      end;
    if key > lastkey then lastkey := key;
{
    with keytable[key] do
      if refcount + copycount > 1 then savekey(key);

    adjusttemps;
}

    while (keytable[lastkey].refcount = 0) and
          (lastkey >= context[contextsp].keymark) do
      begin
      keytable[lastkey].access := noaccess;
      lastkey := lastkey - 1;
      end;

    { This prevents stumbling on an old key later.
    }
{    key := lastkey;

    while key >= context[contextsp].keymark do
      begin
      if keytable[key].refcount = 0 then keytable[key].access := noaccess;
      key := key - 1;
      end;}
  end; {codeselect}


procedure dumppseudo;


  begin {dumppseudo}
    with pseudoinst do
      begin
        if (op = blockentry) then
          writeln;
        case op of
          blockentry: write('blockentry': 15);
          addint: write('addint': 15);
          addptr: write('addptr': 15);
          addr: write('addr': 15);
          addreal: write('addreal': 15);
          addset: write('addset': 15);
          addstr: write('addstr': 15);
          aindx: write('aindx': 15);
          andint: write('andint': 15);
          arraystr: write('arraystr': 15);
          bad: write('bad': 15);
          blockcode: write('blockcode': 15);
          blockexit: write('blockexit': 15);
          callroutine: write('callroutine': 15);
          casebranch: write('casebranch': 15);
          caseelt: write('caseelt': 15);
          caseerr: write('caseerr': 15);
          castfptrint: write('castfptrint': 15);
          castint: write('castint': 15);
          castintfptr: write('castintfptr': 15);
          castintptr: write('castintptr': 15);
          castptr: write('castptr': 15);
          castptrint: write('castptrint': 15);
          castreal: write('castreal': 15);
          castrealint: write('castrealint': 15);
          chrstr: write('chrstr': 15);
          clearlabel: write('clearlabel': 15);
          closerange: write('closerange': 15);
          commafake: write('commafake': 15);
          compbool: write('compbool': 15);
          compint: write('compint': 15);
          congruchk: write('congruchk': 15);
          copyaccess: write('copyaccess': 15);
          copystack: write('copystack': 15);
          createfalse: write('createfalse': 15);
          createtemp: write('createtemp': 15);
          createtrue: write('createtrue': 15);
          cvtdr: write('cvtdr': 15);
          cvtrd: write('cvtrd': 15);
          dataadd: write('dataadd': 15);
          dataaddr: write('dataaddr': 15);
          dataend: write('dataend': 15);
          datafaddr: write('datafaddr': 15);
          datafield: write('datafield': 15);
          datafill: write('datafill': 15);
          dataint: write('dataint': 15);
          datareal: write('datareal': 15);
          datastart: write('datastart': 15);
          datastore: write('datastore': 15);
          datastruct: write('datastruct': 15);
          datasub: write('datasub': 15);
          decint: write('decint': 15);
          defforindex: write('defforindex': 15);
          defforlitindex: write('defforlitindex': 15);
          definelazy: write('definelazy': 15);
          defunsforindex: write('defunsforindex': 15);
          defunsforlitindex: write('defunsforlitindex': 15);
          divint: write('divint': 15);
          divreal: write('divreal': 15);
          divset: write('divset': 15);
          doext: write('doext': 15);
          dofptr: write('dofptr': 15);
          dofptrvar: write('dofptrvar': 15);
          doint: write('doint': 15);
          dolevel: write('dolevel': 15);
          doorigin: write('doorigin': 15);
          doown: write('doown': 15);
          doptr: write('doptr': 15);
          doptrvar: write('doptrvar': 15);
          doreal: write('doreal': 15);
          doretptr: write('doretptr': 15);
          doset: write('doset': 15);
          dostruct: write('dostruct': 15);
          dotemp: write('dotemp': 15);
          dounsvar: write('dounsvar': 15);
          dovar: write('dovar': 15);
          dummyarg: write('dummyarg': 15);
          dummyarg2: write('dummyarg2': 15);
          endpseudocode: write('endpseudocode': 15);
          endreflex: write('endreflex': 15);
          eqfptr: write('eqfptr': 15);
          eqint: write('eqint': 15);
          eqlitfptr: write('eqlitfptr': 15);
          eqlitint: write('eqlitint': 15);
          eqlitptr: write('eqlitptr': 15);
          eqlitreal: write('eqlitreal': 15);
          eqptr: write('eqptr': 15);
          eqreal: write('eqreal': 15);
          eqset: write('eqset': 15);
          eqstr: write('eqstr': 15);
          eqstruct: write('eqstruct': 15);
          flt: write('flt': 15);
          fmt: write('fmt': 15);
          fordnbottom: write('fordnbottom': 15);
          fordnchk: write('fordnchk': 15);
          fordnimproved: write('fordnimproved': 15);
          fordntop: write('fordntop': 15);
          forerrchk: write('forerrchk': 15);
          forupbottom: write('forupbottom': 15);
          forupchk: write('forupchk': 15);
          forupimproved: write('forupimproved': 15);
          foruptop: write('foruptop': 15);
          geqint: write('geqint': 15);
          geqlitint: write('geqlitint': 15);
          geqlitptr: write('geqlitptr': 15);
          geqlitreal: write('geqlitreal': 15);
          geqptr: write('geqptr': 15);
          geqreal: write('geqreal': 15);
          geqset: write('geqset': 15);
          geqstr: write('geqstr': 15);
          geqstruct: write('geqstruct': 15);
          getquo: write('getquo': 15);
          getrem: write('getrem': 15);
          gtrint: write('gtrint': 15);
          gtrlitint: write('gtrlitint': 15);
          gtrlitptr: write('gtrlitptr': 15);
          gtrlitreal: write('gtrlitreal': 15);
          gtrptr: write('gtrptr': 15);
          gtrreal: write('gtrreal': 15);
          gtrstr: write('gtrstr': 15);
          gtrstruct: write('gtrstruct': 15);
          incint: write('incint': 15);
          incstk: write('incstk': 15);
          indx: write('indx': 15);
          indxchk: write('indxchk': 15);
          indxindr: write('indxindr': 15);
          inset: write('inset': 15);
          joinlabel: write('joinlabel': 15);
          jointemp: write('jointemp': 15);
          jump: write('jump': 15);
          jumpf: write('jumpf': 15);
          jumpt: write('jumpt': 15);
          jumpvfunc: write('jumpvfunc': 15);
          kwoint: write('kwoint': 15);
          leqint: write('leqint': 15);
          leqlitint: write('leqlitint': 15);
          leqlitptr: write('leqlitptr': 15);
          leqlitreal: write('leqlitreal': 15);
          leqptr: write('leqptr': 15);
          leqreal: write('leqreal': 15);
          leqset: write('leqset': 15);
          leqstr: write('leqstr': 15);
          leqstruct: write('leqstruct': 15);
          loopholefn: write('loopholefn': 15);
          lssint: write('lssint': 15);
          lsslitint: write('lsslitint': 15);
          lsslitptr: write('lsslitptr': 15);
          lsslitreal: write('lsslitreal': 15);
          lssptr: write('lssptr': 15);
          lssreal: write('lssreal': 15);
          lssstr: write('lssstr': 15);
          lssstruct: write('lssstruct': 15);
          makeroom: write('makeroom': 15);
          modint: write('modint': 15);
          movcstruct: write('movcstruct': 15);
          movint: write('movint': 15);
          movlitint: write('movlitint': 15);
          movlitptr: write('movlitptr': 15);
          movlitreal: write('movlitreal': 15);
          movptr: write('movptr': 15);
          movreal: write('movreal': 15);
          movset: write('movset': 15);
          movstr: write('movstr': 15);
          movstruct: write('movstruct': 15);
          mulint: write('mulint': 15);
          mulreal: write('mulreal': 15);
          mulset: write('mulset': 15);
          negint: write('negint': 15);
          negreal: write('negreal': 15);
          neqfptr: write('neqfptr': 15);
          neqint: write('neqint': 15);
          neqlitfptr: write('neqlitfptr': 15);
          neqlitint: write('neqlitint': 15);
          neqlitptr: write('neqlitptr': 15);
          neqlitreal: write('neqlitreal': 15);
          neqptr: write('neqptr': 15);
          neqreal: write('neqreal': 15);
          neqset: write('neqset': 15);
          neqstr: write('neqstr': 15);
          neqstruct: write('neqstruct': 15);
          openarray: write('openarray': 15);
          orint: write('orint': 15);
          paindx: write('paindx': 15);
          pascalgoto: write('pascalgoto': 15);
          pascallabel: write('pascallabel': 15);
          pindx: write('pindx': 15);
          postint: write('postint': 15);
          postptr: write('postptr': 15);
          postreal: write('postreal': 15);
          preincptr: write('preincptr': 15);
          pseudolabel: write('pseudolabel': 15);
          pshaddr: write('pshaddr': 15);
          pshfptr: write('pshfptr': 15);
          pshint: write('pshint': 15);
          pshlitfptr: write('pshlitfptr': 15);
          pshlitint: write('pshlitint': 15);
          pshlitptr: write('pshlitptr': 15);
          pshlitreal: write('pshlitreal': 15);
          pshproc: write('pshproc': 15);
          pshptr: write('pshptr': 15);
          pshreal: write('pshreal': 15);
          pshretptr: write('pshretptr': 15);
          pshset: write('pshset': 15);
          pshstr: write('pshstr': 15);
          pshstraddr: write('pshstraddr': 15);
          pshstruct: write('pshstruct': 15);
          ptrchk: write('ptrchk': 15);
          ptrtemp: write('ptrtemp': 15);
          rangechk: write('rangechk': 15);
          rdbin: write('rdbin': 15);
          rdchar: write('rdchar': 15);
          rdint: write('rdint': 15);
          rdreal: write('rdreal': 15);
          rdst: write('rdst': 15);
          rdxstr: write('rdxstr': 15);
          realtemp: write('realtemp': 15);
          regtemp: write('regtemp': 15);
          restorelabel: write('restorelabel': 15);
          restoreloop: write('restoreloop': 15);
          returnfptr: write('returnfptr': 15);
          returnint: write('returnint': 15);
          returnptr: write('returnptr': 15);
          returnreal: write('returnreal': 15);
          returnstruct: write('returnstruct': 15);
          savelabel: write('savelabel': 15);
          saveactkeys: write('saveactkeys': 15);
          setbinfile: write('setbinfile': 15);
          setfile: write('setfile': 15);
          setinsert: write('setinsert': 15);
          shiftlint: write('shiftlint': 15);
          shiftrint: write('shiftrint': 15);
          stacktarget: write('stacktarget': 15);
          startreflex: write('startreflex': 15);
          stddivint: write('stddivint': 15);
          stdmodint: write('stdmodint': 15);
          stmtbrk: write('stmtbrk': 15);
          subint: write('subint': 15);
          subptr: write('subptr': 15);
          subreal: write('subreal': 15);
          subset: write('subset': 15);
          sysfnint: write('sysfnint': 15);
          sysfnreal: write('sysfnreal': 15);
          sysfnstring: write('sysfnstring': 15);
          sysroutine: write('sysroutine': 15);
          temptarget: write('temptarget': 15);
          unscallroutine: write('unscallroutine': 15);
          wrbin: write('wrbin': 15);
          wrbool: write('wrbool': 15);
          wrchar: write('wrchar': 15);
          wrint: write('wrint': 15);
          wrreal: write('wrreal': 15);
          wrst: write('wrst': 15);
          wrxstr: write('wrxstr': 15);
          xorint: write('xorint': 15);
          otherwise write('unknown op:', ord(op): 15);
        end;
        if not (op in nokeydata) then
          write(':', len: 6, ' (', key: 3, ',', refcount: 3, ',', copycount: 3, ') ')
        else write(':',' ':21);
        { Only one operand }
        if op in oneoperand then writeln(oprnds[1]:5)
        else writeln(oprnds[1]:5, oprnds[2]:5, oprnds[3]:5);
    end
  end {dumppseudo} ;

procedure codeone;

{ Routine called by directly by travrs to generate code for one
  pseudoop for big compiler version.
}

  begin {codeone}
    if travcode then
      begin
      if switcheverplus[test] then
        dumppseudo;
      key := pseudoinst.key;
      len := pseudoinst.len;
      left := pseudoinst.oprnds[1];
      right := pseudoinst.oprnds[2];
      target := pseudoinst.oprnds[3];
      codeselect;
      end;
  end {codeone};



procedure code;
begin
end;
     

procedure initcode;

{ Initialize the code generation pass.
}

  var
    i: integer; {general purpose induction variable}
    procno: proctableindex;

  begin {initcode}

    { Front end doesn't do this for deeply historical reasons but in Linux
      the main program's just an external procedure.
    }
    proctable[0].externallinkage := true;

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

{
geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, literal_oprnd(16000));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, index_oprnd(pre_index, sp, -16));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, index_oprnd(post_index, sp, 16));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, index_oprnd(imm_offset, 8, 256));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 1, false, xtx, false));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 2, true, xtx, false));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(3, 4, true, xtx, true));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(3, 4, false, xtx, true));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(3, 4, true, xtx, true));

geninst(nil, buildinst(ldr, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

geninst(nil, buildinst(ldr, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 3, true, xtw, true));

geninst(nil, buildinst(ldr, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

geninst(nil, buildinst(ldrb, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(18, 3, false, xtw, true));

geninst(nil, buildinst(ldrsw, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, buildinst(str, true, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, buildinst(str, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, buildinst(strh, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, buildinst(strb, false, false), 2);
genoprnd(lastnode, 1, reg_oprnd(3));
genoprnd(lastnode, 2, reg_offset_oprnd(5, 3, false, xtw, true));

geninst(nil, buildinst(stp, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(29));
genoprnd(lastnode, 2, reg_oprnd(30));
genoprnd(lastnode, 3, index_oprnd(pre_index, sp, -16));

geninst(nil, buildinst(ldp, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(29));
genoprnd(lastnode, 2, reg_oprnd(30));
genoprnd(lastnode, 3, index_oprnd(post_index, sp, 16));

geninst(nil, buildinst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(6));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, reg_oprnd(3));

geninst(nil, buildinst(add, true, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, reg_oprnd(20));

geninst(nil, buildinst(add, true, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, lsl, 20));

geninst(nil, buildinst(add, true, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, lsr, 41));

geninst(nil, buildinst(add, true, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 1, reg_oprnd(5));

geninst(nil, buildinst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, lsl, 20));

geninst(nil, buildinst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, lsr, 21));

geninst(nil, buildinst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(4, asr, 23));

geninst(nil, buildinst(add, false,true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, immediate_oprnd(2332, 0));

geninst(nil, buildinst(add, false, true), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, immediate_oprnd(2332, 12));

geninst(nil, buildinst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

geninst(nil, buildinst(sub, true,false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtb, 3, true));

geninst(nil, buildinst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xth, 3, false));

geninst(nil, buildinst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtw, 3, true));

geninst(nil, buildinst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(22));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

geninst(nil, buildinst(sub, false, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(22));
genoprnd(lastnode, 3, extend_reg_oprnd(5, xtx, 3, true));

geninst(nil, buildinst(sub, false, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(22));
genoprnd(lastnode, 3, shift_reg_oprnd(17, lsr, 31));

geninst(nil, buildinst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(22));
genoprnd(lastnode, 3, shift_reg_oprnd(21, lsr, 61));

geninst(nil, buildinst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(3, lsl, 62));

geninst(nil, buildinst(sub, true, false), 3);
genoprnd(lastnode, 1, reg_oprnd(5));
genoprnd(lastnode, 2, reg_oprnd(8));
genoprnd(lastnode, 3, shift_reg_oprnd(6, asr, 63));

geninst(nil, buildinst(ret, false, false), 0);

settemp(quad, reg_oprnd(sp));
settemp(quad, immediate_oprnd(0, false));
gen3(buildinst(sub, true, false), tempkey + 1, tempkey + 1, tempkey);

settemp(quad, reg_oprnd(fp));
settemp(quad, reg_oprnd(link));
settemp(quad, index_oprnd(imm_offset, sp, 0));
gen3(buildinst(stp, true, false), tempkey + 1, tempkey + 2, tempkey);

gen3(buildinst(ldp, true, false), tempkey + 1, tempkey + 2, tempkey);

gen3(buildinst(add, true, false), tempkey + 4, tempkey + 4, tempkey + 3);

tempkey := tempkey + 5;
putcode.putcode;
}

    p := firstnode;
    while p <> nil do
    begin
      p1 := p^.nextnode;
      dispose(p);
      p := p1;
    end
  end {exitcode};
end.
