unit code;

interface

uses config, hdr, t_c, hdrc, utils, putcode;

procedure code;

procedure codeone;

procedure initcode;

procedure exitcode;

implementation

procedure dumpstack;

  var i: integer;


  begin {dumpstack}
    if switcheverplus[test] then
      begin
      for i := stackcounter to keysize - 1 do 
        with keytable[i], oprnd do begin
          write(macfile, 'key: ', i : 1);
          write(macfile, ', ref: ', refcount:1, ', len ', len:1);
          write(macfile, ', tempflag: ', tempflag);
          write(macfile, ', index: ', index:1);
          writeln(macfile);
          end;
    end;
  end {dumpstack} ;

procedure dumppseudo(var f: text);


  begin {dumppseudo}
    with pseudoinst do
      begin
        if (op = blockentry) then
          writeln(f);
        case op of
          blockentry: write(f, 'blockentry': 15);
          addint: write(f, 'addint': 15);
          addptr: write(f, 'addptr': 15);
          addr: write(f, 'addr': 15);
          addreal: write(f, 'addreal': 15);
          addset: write(f, 'addset': 15);
          addstr: write(f, 'addstr': 15);
          aindx: write(f, 'aindx': 15);
          andint: write(f, 'andint': 15);
          arraystr: write(f, 'arraystr': 15);
          bad: write(f, 'bad': 15);
          blockcode: write(f, 'blockcode': 15);
          blockexit: write(f, 'blockexit': 15);
          callroutine: write(f, 'callroutine': 15);
          casebranch: write(f, 'casebranch': 15);
          caseelt: write(f, 'caseelt': 15);
          caseerr: write(f, 'caseerr': 15);
          castfptrint: write(f, 'castfptrint': 15);
          castint: write(f, 'castint': 15);
          castintfptr: write(f, 'castintfptr': 15);
          castintptr: write(f, 'castintptr': 15);
          castptr: write(f, 'castptr': 15);
          castptrint: write(f, 'castptrint': 15);
          castreal: write(f, 'castreal': 15);
          castrealint: write(f, 'castrealint': 15);
          chrstr: write(f, 'chrstr': 15);
          clearlabel: write(f, 'clearlabel': 15);
          closerange: write(f, 'closerange': 15);
          commafake: write(f, 'commafake': 15);
          compbool: write(f, 'compbool': 15);
          compint: write(f, 'compint': 15);
          congruchk: write(f, 'congruchk': 15);
          copyaccess: write(f, 'copyaccess': 15);
          copystack: write(f, 'copystack': 15);
          createfalse: write(f, 'createfalse': 15);
          createtemp: write(f, 'createtemp': 15);
          createtrue: write(f, 'createtrue': 15);
          cvtdr: write(f, 'cvtdr': 15);
          cvtrd: write(f, 'cvtrd': 15);
          dataadd: write(f, 'dataadd': 15);
          dataaddr: write(f, 'dataaddr': 15);
          dataend: write(f, 'dataend': 15);
          datafaddr: write(f, 'datafaddr': 15);
          datafield: write(f, 'datafield': 15);
          datafill: write(f, 'datafill': 15);
          dataint: write(f, 'dataint': 15);
          datareal: write(f, 'datareal': 15);
          datastart: write(f, 'datastart': 15);
          datastore: write(f, 'datastore': 15);
          datastruct: write(f, 'datastruct': 15);
          datasub: write(f, 'datasub': 15);
          decint: write(f, 'decint': 15);
          defforindex: write(f, 'defforindex': 15);
          defforlitindex: write(f, 'defforlitindex': 15);
          definelazy: write(f, 'definelazy': 15);
          defunsforindex: write(f, 'defunsforindex': 15);
          defunsforlitindex: write(f, 'defunsforlitindex': 15);
          divint: write(f, 'divint': 15);
          divreal: write(f, 'divreal': 15);
          divset: write(f, 'divset': 15);
          doext: write(f, 'doext': 15);
          dofptr: write(f, 'dofptr': 15);
          dofptrvar: write(f, 'dofptrvar': 15);
          doint: write(f, 'doint': 15);
          dolevel: write(f, 'dolevel': 15);
          doorigin: write(f, 'doorigin': 15);
          doown: write(f, 'doown': 15);
          doptr: write(f, 'doptr': 15);
          doptrvar: write(f, 'doptrvar': 15);
          doreal: write(f, 'doreal': 15);
          doretptr: write(f, 'doretptr': 15);
          doset: write(f, 'doset': 15);
          dostruct: write(f, 'dostruct': 15);
          dotemp: write(f, 'dotemp': 15);
          dounsvar: write(f, 'dounsvar': 15);
          dovar: write(f, 'dovar': 15);
          dummyarg: write(f, 'dummyarg': 15);
          dummyarg2: write(f, 'dummyarg2': 15);
          endpseudocode: write(f, 'endpseudocode': 15);
          endreflex: write(f, 'endreflex': 15);
          eqfptr: write(f, 'eqfptr': 15);
          eqint: write(f, 'eqint': 15);
          eqlitfptr: write(f, 'eqlitfptr': 15);
          eqlitint: write(f, 'eqlitint': 15);
          eqlitptr: write(f, 'eqlitptr': 15);
          eqlitreal: write(f, 'eqlitreal': 15);
          eqptr: write(f, 'eqptr': 15);
          eqreal: write(f, 'eqreal': 15);
          eqset: write(f, 'eqset': 15);
          eqstr: write(f, 'eqstr': 15);
          eqstruct: write(f, 'eqstruct': 15);
          flt: write(f, 'flt': 15);
          fmt: write(f, 'fmt': 15);
          fordnbottom: write(f, 'fordnbottom': 15);
          fordnchk: write(f, 'fordnchk': 15);
          fordnimproved: write(f, 'fordnimproved': 15);
          fordntop: write(f, 'fordntop': 15);
          forerrchk: write(f, 'forerrchk': 15);
          forupbottom: write(f, 'forupbottom': 15);
          forupchk: write(f, 'forupchk': 15);
          forupimproved: write(f, 'forupimproved': 15);
          foruptop: write(f, 'foruptop': 15);
          geqint: write(f, 'geqint': 15);
          geqlitint: write(f, 'geqlitint': 15);
          geqlitptr: write(f, 'geqlitptr': 15);
          geqlitreal: write(f, 'geqlitreal': 15);
          geqptr: write(f, 'geqptr': 15);
          geqreal: write(f, 'geqreal': 15);
          geqset: write(f, 'geqset': 15);
          geqstr: write(f, 'geqstr': 15);
          geqstruct: write(f, 'geqstruct': 15);
          getquo: write(f, 'getquo': 15);
          getrem: write(f, 'getrem': 15);
          gtrint: write(f, 'gtrint': 15);
          gtrlitint: write(f, 'gtrlitint': 15);
          gtrlitptr: write(f, 'gtrlitptr': 15);
          gtrlitreal: write(f, 'gtrlitreal': 15);
          gtrptr: write(f, 'gtrptr': 15);
          gtrreal: write(f, 'gtrreal': 15);
          gtrstr: write(f, 'gtrstr': 15);
          gtrstruct: write(f, 'gtrstruct': 15);
          incint: write(f, 'incint': 15);
          incstk: write(f, 'incstk': 15);
          indx: write(f, 'indx': 15);
          indxchk: write(f, 'indxchk': 15);
          indxindr: write(f, 'indxindr': 15);
          inset: write(f, 'inset': 15);
          joinlabel: write(f, 'joinlabel': 15);
          jointemp: write(f, 'jointemp': 15);
          jump: write(f, 'jump': 15);
          jumpf: write(f, 'jumpf': 15);
          jumpt: write(f, 'jumpt': 15);
          jumpvfunc: write(f, 'jumpvfunc': 15);
          kwoint: write(f, 'kwoint': 15);
          leqint: write(f, 'leqint': 15);
          leqlitint: write(f, 'leqlitint': 15);
          leqlitptr: write(f, 'leqlitptr': 15);
          leqlitreal: write(f, 'leqlitreal': 15);
          leqptr: write(f, 'leqptr': 15);
          leqreal: write(f, 'leqreal': 15);
          leqset: write(f, 'leqset': 15);
          leqstr: write(f, 'leqstr': 15);
          leqstruct: write(f, 'leqstruct': 15);
          loopholefn: write(f, 'loopholefn': 15);
          lssint: write(f, 'lssint': 15);
          lsslitint: write(f, 'lsslitint': 15);
          lsslitptr: write(f, 'lsslitptr': 15);
          lsslitreal: write(f, 'lsslitreal': 15);
          lssptr: write(f, 'lssptr': 15);
          lssreal: write(f, 'lssreal': 15);
          lssstr: write(f, 'lssstr': 15);
          lssstruct: write(f, 'lssstruct': 15);
          makeroom: write(f, 'makeroom': 15);
          modint: write(f, 'modint': 15);
          movcstruct: write(f, 'movcstruct': 15);
          movint: write(f, 'movint': 15);
          movlitint: write(f, 'movlitint': 15);
          movlitptr: write(f, 'movlitptr': 15);
          movlitreal: write(f, 'movlitreal': 15);
          movptr: write(f, 'movptr': 15);
          movreal: write(f, 'movreal': 15);
          movset: write(f, 'movset': 15);
          movstr: write(f, 'movstr': 15);
          movstruct: write(f, 'movstruct': 15);
          mulint: write(f, 'mulint': 15);
          mulreal: write(f, 'mulreal': 15);
          mulset: write(f, 'mulset': 15);
          negint: write(f, 'negint': 15);
          negreal: write(f, 'negreal': 15);
          neqfptr: write(f, 'neqfptr': 15);
          neqint: write(f, 'neqint': 15);
          neqlitfptr: write(f, 'neqlitfptr': 15);
          neqlitint: write(f, 'neqlitint': 15);
          neqlitptr: write(f, 'neqlitptr': 15);
          neqlitreal: write(f, 'neqlitreal': 15);
          neqptr: write(f, 'neqptr': 15);
          neqreal: write(f, 'neqreal': 15);
          neqset: write(f, 'neqset': 15);
          neqstr: write(f, 'neqstr': 15);
          neqstruct: write(f, 'neqstruct': 15);
          openarray: write(f, 'openarray': 15);
          orint: write(f, 'orint': 15);
          paindx: write(f, 'paindx': 15);
          pascalgoto: write(f, 'pascalgoto': 15);
          pascallabel: write(f, 'pascallabel': 15);
          pindx: write(f, 'pindx': 15);
          postint: write(f, 'postint': 15);
          postptr: write(f, 'postptr': 15);
          postreal: write(f, 'postreal': 15);
          preincptr: write(f, 'preincptr': 15);
          pseudolabel: write(f, 'pseudolabel': 15);
          pshaddr: write(f, 'pshaddr': 15);
          pshfptr: write(f, 'pshfptr': 15);
          pshint: write(f, 'pshint': 15);
          pshlitfptr: write(f, 'pshlitfptr': 15);
          pshlitint: write(f, 'pshlitint': 15);
          pshlitptr: write(f, 'pshlitptr': 15);
          pshlitreal: write(f, 'pshlitreal': 15);
          pshproc: write(f, 'pshproc': 15);
          pshptr: write(f, 'pshptr': 15);
          pshreal: write(f, 'pshreal': 15);
          pshretptr: write(f, 'pshretptr': 15);
          pshset: write(f, 'pshset': 15);
          pshstr: write(f, 'pshstr': 15);
          pshstraddr: write(f, 'pshstraddr': 15);
          pshstruct: write(f, 'pshstruct': 15);
          ptrchk: write(f, 'ptrchk': 15);
          ptrregparam: write(f, 'ptrregparam': 15);
          ptrtemp: write(f, 'ptrtemp': 15);
          rangechk: write(f, 'rangechk': 15);
          rdbin: write(f, 'rdbin': 15);
          rdchar: write(f, 'rdchar': 15);
          rdint: write(f, 'rdint': 15);
          rdreal: write(f, 'rdreal': 15);
          rdst: write(f, 'rdst': 15);
          rdxstr: write(f, 'rdxstr': 15);
          realregparam: write(f, 'realregparam': 15);
          realtemp: write(f, 'realtemp': 15);
          regparam: write(f, 'regparam': 15);
          regtarget: write(f, 'regtarget': 15);
          regtemp: write(f, 'regtemp': 15);
          restorelabel: write(f, 'restorelabel': 15);
          restoreloop: write(f, 'restoreloop': 15);
          returnfptr: write(f, 'returnfptr': 15);
          returnint: write(f, 'returnint': 15);
          returnptr: write(f, 'returnptr': 15);
          returnreal: write(f, 'returnreal': 15);
          returnstruct: write(f, 'returnstruct': 15);
          savelabel: write(f, 'savelabel': 15);
          saveactkeys: write(f, 'saveactkeys': 15);
          setbinfile: write(f, 'setbinfile': 15);
          setfile: write(f, 'setfile': 15);
          setinsert: write(f, 'setinsert': 15);
          shiftlint: write(f, 'shiftlint': 15);
          shiftrint: write(f, 'shiftrint': 15);
          stacktarget: write(f, 'stacktarget': 15);
          startreflex: write(f, 'startreflex': 15);
          stddivint: write(f, 'stddivint': 15);
          stdmodint: write(f, 'stdmodint': 15);
          stmtbrk: write(f, 'stmtbrk': 15);
          subint: write(f, 'subint': 15);
          subptr: write(f, 'subptr': 15);
          subreal: write(f, 'subreal': 15);
          subset: write(f, 'subset': 15);
          sysfnint: write(f, 'sysfnint': 15);
          sysfnreal: write(f, 'sysfnreal': 15);
          sysfnstring: write(f, 'sysfnstring': 15);
          sysroutine: write(f, 'sysroutine': 15);
          temptarget: write(f, 'temptarget': 15);
          unscallroutine: write(f, 'unscallroutine': 15);
          wrbin: write(f, 'wrbin': 15);
          wrbool: write(f, 'wrbool': 15);
          wrchar: write(f, 'wrchar': 15);
          wrint: write(f, 'wrint': 15);
          wrreal: write(f, 'wrreal': 15);
          wrst: write(f, 'wrst': 15);
          wrxstr: write(f, 'wrxstr': 15);
          xorint: write(f, 'xorint': 15);
          otherwise write(f, 'unknown op:', ord(op): 15);
        end;
        write(f, ':', len: 6, ' (', key: 3, ',', refcount: 3, ',', copycount: 3, ') ');
        writeln(f, oprnds[1]:5, oprnds[2]:5, oprnds[3]:5);
    end
  end {dumppseudo} ;

function newlabel: integer;

begin {newlabel}
  newlabel := lastlabel;
  lastlabel := lastlabel - 1;
end {newlabel};

procedure power2check(n: integer; { number to check }
                      var power2: boolean; {true if n = power of 2}
                      var power2value: integer {resulting power} );

{ Find out if n is an even power of 2, and return the exponent if so.
}


  begin {power2check}
    power2value := 0;
    while (n > 0) and not odd(n) do
      begin
      n := n div 2;
      power2value := power2value + 1;
      end;
    power2 := (n = 1);
  end {power2check} ;


function bits(i: unsigned): integer;

{ return the number of bits in i }

var b: integer;

begin {bits}
  b := -1;
  while i <> 0 do
    begin
    b := b + 1;
    i := i div 2;
    end;
  bits := b;
end {bits};

function regmoveok(n: integer): boolean;

  var
    power2: boolean;
    power2value: integer;

{ when we implemenet use of vector registers, we can move 16 bytes
  in a register rather than just 8.
}

begin {regmoveok}
  power2check(n, power2, power2value);
  regmoveok := power2 and (power2value <= 3);
end; {regmoveok}

procedure setkeyentry(k: keyindex; l:unsigned; o: oprndtype);

{ Set up an arbitrary key entry with the given operand.
}

  begin {setkeyentry}
    with keytable[k] do
      begin
      len := l;
      refcount := 0;
      copycount := 0;
      copylink := 0;
      properreg := 0;
      properreg2 := 0;
      access := valueaccess;
      tempflag := false;
      regsaved := false;
      reg2saved := false;
      regvalid := true;
      reg2valid := true;
      packedaccess := false;
      signed := true;
      signlimit := 0;
      oprnd := o;
      end;
  end {setkeyentry};

procedure settemp(l: unsigned; o: oprndtype);

{ Set up a temporary key entry with the given operand.  This has
  nothing to do with runtime temp administration.  It strictly sets up a key
  entry.  Negative key values are used for these temp entries, and they are
  basically administered as a stack using "tempkey" as the stack pointer.
}


  begin {settemp}
    if tempkey = lowesttemp then compilerabort(interntemp);
    tempkey := tempkey - 1;
    setkeyentry(tempkey, l, o);
  end {settemp} ;


function buildinst(inst: insts; sf: boolean; s: boolean): insttype;

var
  i: insttype;

begin
  i.inst := inst;
  i.sf := sf;
  i.s := s;
  buildinst := i;
end;

function ldrinst(l: addressrange; s: boolean):insttype;

  var
    inst: insts;

  begin {ldrinst}
    case l  of
      byte: if s then inst := ldrsb else inst := ldrb;
      short: if s then inst := ldrsh else inst := ldrh;
      word: if s then inst := ldrsw else inst := ldr;
      long: inst := ldr;
      otherwise
        begin
        write('operand length ', l, ' given to ldrinst');
        compilerabort(inconsistent)
        end
    end;
    ldrinst := buildinst(inst, l >= word, false);
  end {ldrinst};

function strinst(l: addressrange):insttype;

  var
    inst: insts;

  begin {strinst}
    case l  of
      1: inst := strb;
      2: inst := strh;
      4, 8: inst := str;
      otherwise
        begin
        write('operand length ', l, ' given to strinst');
        compilerabort(inconsistent)
        end
    end;
    strinst := buildinst(inst, l = long, false);
  end {loadinst};

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
    o.reg2 := noreg;
    reg_oprnd := o;
  end;

function fpreg_oprnd(reg: regindex): oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := fpregister;
    o.reg := reg;
    o.reg2 := noreg;
    fpreg_oprnd := o;
  end;

function immediate16_oprnd(imm16_value: imm16; imm16_shift: unsigned): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := immediate16;
    o.imm16_value := imm16_value;
    o.imm16_shift := imm16_shift;
    immediate16_oprnd := o;
  end;

function immediate_oprnd(imm_value: imm12; imm_shift: boolean): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := immediate;
    o.imm_value := imm_value;
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
    o.reg2 := noreg;
    o.reg_shift := reg_shift;
    o.shift_amount := shift_amount;
    shift_reg_oprnd := o;
  end;

function extend_reg_oprnd(reg: regindex; reg_extend: reg_extends; extend_shift: imm3;
                          extend_signed: boolean): oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := extend_reg;
    o.reg := reg;
    o.reg2 := noreg;
    o.reg_extend := reg_extend;
    o.extend_shift := extend_shift;
    o.extend_signed := extend_signed;
    extend_reg_oprnd := o;
  end;

function index_oprnd(mode: oprnd_modes; reg: regindex; index: integer): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := reg;
    o.reg2 := noreg;
    o.mode := mode;
    o.index := index;
    index_oprnd := o;
  end;

function reg_offset_oprnd(reg, reg2: regindex; shift: imm2;
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


function tworeg_oprnd(reg, reg2: regindex): oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := tworeg;
    o.reg := reg;
    o.reg2 := reg2;
    tworeg_oprnd := o;
  end;

function cond_oprnd(c: conds): oprndtype;

  var
    o:oprndtype;
  begin
    o.mode := cond;
    o.condition := c;
    o.reg := noreg;
    o.reg2 := noreg;
    cond_oprnd := o;
  end;

function literal_oprnd(lit: integer): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := literal;
    o.literal := lit;
    literal_oprnd := o;
  end;


function labeltarget_oprnd(labelno: integer; lowbits: boolean;
                           labeloffset: integer): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := labeltarget;
    o.labelno := labelno;
    o.lowbits := lowbits;
    o.labeloffset := labeloffset;
    labeltarget_oprnd := o;
  end;


function proccall_oprnd(proclabelno: unsigned; entry_offset: integer): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := proccall;
    o.proclabelno := proclabelno;
    o.entry_offset := entry_offset;
    proccall_oprnd := o;
  end;


function libcall_oprnd(l: libroutines): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := libcall;
    o.libroutine := l;
    libcall_oprnd := o;
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
    p^.prevnode := lastnode;

    { strategy here is that the nodes from first to last are
      those that created the current key value once we move to the next key,
      while the prevnode field allows us to more easily delete nodes
      attached to a key.
    }

    if key > 0 then
      with keytable[key] do
        begin
        last := p;
        if first = nil then
          first := p;
        end;

    lastnode := p;
    newnode := p;
      
  end {newnode};

function newinsertbefore(before: nodeptr; kind: nodekinds): nodeptr;

{ Allocate a new node before the given node.  If before is nil, we assume
  this is the first node of the block.
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
      p^.prevnode := before^.prevnode;
      before^.prevnode := p;
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
    p^.prevnode := after^.prevnode;
    after^.prevnode := p;
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

  var tc: keyindex;

  begin {genoprnd}

    with p^ do
      begin
{
      if o.reg = fp then
        begin
        end 
      else if (o.mode = unsigned_offset) and (o.reg = sp) then
          begin
          tc := keysize;
          while (o.index < keytable[tc].oprnd.index) and
                (tc > stackcounter) do
            tc := tc - 1;
          tempcount := tc - stackcounter;
          o.index := o.index + keytable[tc].oprnd.index;
          end;
}
      oprnds[i] := o;
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

{ Generate a longruple operand instruction.
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

{ Generate a longruple operand instruction.
}


  begin {gen4}
    gen4p(newnode(instnode), i, o1, o2, o3, o4);
  end {gen4} ;

procedure genbr(inst: insts; labelno: integer);

  begin {genbr}
    settemp(long, labeltarget_oprnd(labelno, false, 0));
    gen1(buildinst(inst, false, false), tempkey);
    tempkey := tempkey + 1;
    context[contextsp].lastbranch := lastnode;
  end {genbr};

procedure genlabeldelta(tablebase, targetlabel: integer);

  var
    p: nodeptr;

  begin {genlabeldelta}
    p := newnode(labeldeltanode);
    p^.tablebase := tablebase;
    p^.targetlabel := targetlabel;
  end; {genlabeldelta}

procedure deletenodes(first, last: nodeptr);

  var
    p, p1, p2: nodeptr;

  begin {deletenodes}

    if first^.prevnode = nil then
      firstnode := last^.nextnode
    else
      first^.prevnode^.nextnode := last^.nextnode;

    if last^.nextnode = nil then 
      lastnode := first^.prevnode { deleting the tail of the generated nodes}
    else
      last^.nextnode^.prevnode := first^.prevnode;

    p := first; p2 := last^.nextnode;
    while p <> p2 do
      begin
      p1 := p^.nextnode;
      dispose(p);
      p := p1;
      end;

  end {deletenodes};

procedure definelabel(l: integer {label number to define} );

{ Define a label with label number "l" pointing to "lastnode".

  Labels are always kept sorted in node order.  Labels which are
  defined as code is initially emitted are naturally in node order,
  but those defined as a result of peep-hole optimizations may
  have to be sorted in.
}

  var
    t: labelindex; {induction var used in search for slot}
    t1: labelindex; {induction var used in moving labels}
    p: nodeptr;

  begin {definelabel}
    if l <> 0 then
      begin
      p := newnode(labelnode);
      p^.labelno := l;
      p^.stackdepth := 0;
      p^.brnodelink := nil;

  {
      if l <> 0 then
        begin
        if nextlabel = labeltablesize then compilerabort(manylabels)
        else nextlabel := nextlabel + 1;
        t := nextlabel;
        labelnextnode := true;
        labeltable[0].nodelink := 0;
        while labeltable[t - 1].nodelink > lastnode do t := t - 1;
        for t1 := nextlabel downto t + 1 do
          labeltable[t1] := labeltable[t1 - 1];
        with labeltable[t] do
          begin
          labno := l;
          nodelink := lastnode + 1;
          stackdepth := stackoffset;
          address := undefinedaddr;
          end;
        end;
  }
    end;
  end {definelabel} ;

procedure definelastlabel;

{ Define the label with number "lastlabel".  This is used by the code
  generator to generate new labels as needed.  Such "local" labels are
  defined from "maxint" down, while labels emitted by travrs are defined
  from 1 up.
}


  begin {definelastlabel}
    definelabel(lastlabel);
    lastlabel := lastlabel - 1;
  end {definelastlabel} ;

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
          signed_offset, unsigned_offset:
            if regvalid then
              registers[reg] := registers[reg] + delta;
          reg_offset, tworeg:
            begin
            if regvalid then
              registers[reg] := registers[reg] + delta;
            if reg2valid then
              registers[reg2] := registers[reg2] + delta;
            end;
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
            write('BUMPTEMPCOUNT properreg: ', properreg, ' delta: ', delta, ' refcount: ',
                  refcount); 
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
      first := nil;
      last := nil;
      saves := nil;
      end;
  end {setcommonkey} ;

procedure setbr(inst: insts; {branch instruction used}
                o: oprndtype {for cbz, cbnz});

{ Sets the operand data for an operand which is accessed by a branch.
  That is, only the condition code is used.  The type of conditions tested
  for are implicit in the branch instruction.

  This uses the global "key", which is the operand for the latest
  pseudoinstruction.
}


  begin
    adjustdelay := true;
    with keytable[key] do
      begin
      access := branchaccess;
      brinst := inst;
      oprnd := o;
      end;
  end {setbr} ;

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
      keytable[key].brinst := brinst;
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

procedure rereference(k: keyindex {operand} );

{ Increase all appropriate reference counts for this key.  This is called
  when we need to compensate for an extra dereference.
}


  begin {rereference}
    if k > 0 then
      begin
      with keytable[k] do refcount := refcount + 1;
      adjustregcount(k, 1);
      bumptempcount(k, 1);
      end;
  end {rereference} ;

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

{ stack offset adjustment procedures }

procedure finalizestackoffsets(firstnode: nodeptr; lastnode: nodeptr;
                               amount: integer);

{ Flip the dummy negative offsets to the stack to positive offsets. }

  var
    stopnode: nodeptr;
    i: integer;

  begin {finalizestackoffsets}
    stopnode := lastnode^.nextnode;
    while firstnode <> stopnode do
      begin
      with firstnode^ do
        if (kind = instnode) then
          {DRB: this is going to fail with large offsets that are already
           set up as address registers}
          if (inst.inst = add) and (oprnds[2].mode = register) and
             (oprnds[2].reg = sp) and (oprnds[3].mode = immediate) then
            oprnds[3].imm_value := oprnds[3].imm_value + amount  
          else
            for i := 1 to oprnd_cnt do
              if (oprnds[i].mode = signed_offset) and
                 (oprnds[i].reg = sp) then
                begin
                oprnds[i].mode := unsigned_offset;
                oprnds[i].index := oprnds[i].index + amount;
                end;
      firstnode := firstnode^.nextnode;
      end;
  end {finalizestackoffsets};

procedure adjuststackoffsets(firstnode: nodeptr; lastnode: nodeptr;
                             amount: integer);

{ Adjust references to stack temps (but not procedure parameters passed
  on the stack) for instructions in the given range  }

  var
    stopnode: nodeptr;
    i: integer;

  begin {adjuststackoffsets}
    stopnode := lastnode^.nextnode;
    while firstnode <> stopnode do
      begin
      with firstnode^ do
        if (kind = instnode) then
        for i := 1 to oprnd_cnt do
          if (oprnds[i].mode = signed_offset) and
             (oprnds[i].reg = sp) then
              oprnds[i].index := oprnds[i].index + amount;
      firstnode := firstnode^.nextnode;
      end;
  end {adjuststackoffsets};

{ Stack temp allocation procedures }

function precedeslastbranch(k: keyindex): boolean;
  var
    p: nodeptr;

  begin {precedeslastbranch}
    precedeslastbranch := false;
    if context[contextsp].lastbranch <> nil then
      begin
      p := context[contextsp].lastbranch;
      repeat
        p := p^.nextnode;
      until (p = nil) or
            (p = keytable[k].first);
      precedeslastbranch := p <> nil;
      end
  end {precedeslastbranch} ;

function activetemp(k: keyindex): boolean;

begin
  activetemp := keytable[k].validtemp and (k < context[contextsp].savedstackcounter);
end;

function uselesstemp(k: keyindex): boolean;

{ True if the top temp on the tempstack is no longer needed.  It must
  have a refcount of zero and have been created after the last branch
  in this context.  With our non-popping stack model we might be able
  to relax this.
}

  var
    p, p1: nodeptr;

  begin {uselesstemp}
    uselesstemp := activetemp(k) and (keytable[k].refcount = 0)
                   and not precedeslastbranch(k);
  end {uselesstemp} ;

procedure deleteregsave(k: keyindex);
  var p, p1: tempsaveptr;

  begin
    p := keytable[k].saves;
    while p <> nil do
      begin
      deletenodes(p^.first, p^.last);
      p1 := p;
      p := p^.nextsave;
      dispose(p1);
      end;
    keytable[k].saves := nil;
  end;

procedure processregsaves;

{ Iterate over the stack temps allocated in this block,
  deleting all saves to that temp so the temp itself
  can later be deleted.

  This code also disposes the list of reg saves for
  each temp, whether it is used or not, as this is only
  done once when we are finished with each context
  block.
}

var
  k: keyindex;
  p, p1: tempsaveptr;

begin {processregsaves}
  if not switcheverplus[test] then
  begin
    k := stackcounter;
    while activetemp(k) do
      begin
      if uselesstemp(k) and not keytable[k].tempflag then
        deleteregsave(k);
      p := keytable[k].saves;
      while p <> nil do
        begin
        p1 := p^.nextsave;
        dispose(p);
        p := p1;
        end;
      keytable[k].saves := nil;
      k := k + 1;
      end;
  end;
end {processregsaves};

procedure consolidatestack;

{ Consolidates consecutive useless stack slots into a single slot.  This
  will aid the reuse of stack slots since we don't pop them off after
  they are no longer needed.
}

var
  k, k1, k2: keyindex;
  movecnt: integer;
  len: addressrange;
  i: integer;

begin
  K := stackcounter;
  while activetemp(k) do
    begin
    while activetemp(k) and not uselesstemp(k) do
      k := k + 1;
    len := 0;
    k1 := k;
    while uselesstemp(k) do
      begin
      len := len + keytable[k].len;
      if uselesstemp(k) and not keytable[k].tempflag then
        deleteregsave(k);
      k := k + 1;
      end;
    movecnt := k - k1 - 1;
    if movecnt > 0 then
      begin
      keytable[k1].len := len;
      for k2 := k1 downto stackcounter do
        keytable[k2 + movecnt] := keytable[k2];
      stackcounter := stackcounter + movecnt;
      end;
    end;
end;

procedure splittemp(k: keyindex; size: addressrange);

  var
    k1: keyindex;

  begin {splittemp}
    size := (size + (stackalign - 1)) and - stackalign;

    if not uselesstemp(k) or
       (keytable[k].len < size) then
      compilerabort(inconsistent);

    if not keytable[k].tempflag then
      deleteregsave(k);

    if keytable[k].len > size then
      begin
      stackcounter := stackcounter - 1;
      if stackcounter <= lastkey then compilerabort(manykeys);
      for k1 := stackcounter to k - 1 do
        keytable[k1] := keytable[k1 + 1];
      with keytable[k] do
        begin
        oprnd.index := oprnd.index + len - size;
        len := size;
        end;
      with keytable[k - 1] do
        len := len - size;
      end;
  end {splittemp} ;

function besttemp(size: addressrange): keyindex;

  var
    bestsize: addressrange;
    k: keyindex;

  begin {besttemp}
    size := (size + (stackalign - 1)) and - stackalign;
    bestsize := maxaddr;
    k := stackbase;
    besttemp := 0;

    while (k >= stackcounter) and (bestsize > size) do
    begin
      if uselesstemp(k) and (keytable[k].len >= size) and
        (keytable[k].len < bestsize) then
        begin
        bestsize := keytable[k].len;
        besttemp := k;
        end;
      k := k - 1;
    end;
  end {besttemp} ;

function newtemp(size: addressrange {size of temp to allocate} ): keyindex;

{ Create a new temp. Temps are allocated from the top of the keys,
  while expressions are allocated from the bottom.

  We neither push or pop temps as adequate stack space is allocated
  at block entry.  Instead, we try to find an empty slot on the 
  stack and reuse it.

  Offsets to the stack are negative offsets from the base of the stack
  rather than positive offsets to the top of the stack.  This makes
  removing temps easier.  We flip the indexes at the end of the
  block.  They are given the mode signed_offset and will later become
  unsigned_offset, while parameters are given unsigned_offset when
  first allocated.
}

  begin {newtemp}
    size := (size + (stackalign - 1)) and - stackalign;
    stackoffset := stackoffset + size;
    if stackoffset > maxstackoffset then
      maxstackoffset := stackoffset;
    stackcounter := stackcounter - 1;
    if stackcounter <= lastkey then compilerabort(manykeys)
    else
      begin
      with keytable[stackcounter] do
        begin
        len := size;
        access := valueaccess;
        tempflag := false;
        validtemp := true;
        regvalid := true;
        reg2valid := true;
        regsaved := false;
        reg2saved := false;
        packedaccess := false;
        refcount := 0;
        first := nil;
        last := nil;
        oprnd := index_oprnd(signed_offset, sp, -stackoffset);
        end;
      end;
    newtemp := stackcounter;
  end {newtemp} ;

function stacktemp(size: addressrange): keyindex;
  var
    k: keyindex;

  begin {stacktemp}
    size := (size + (stackalign - 1)) and - stackalign;
    k := besttemp(size);
    if k <> 0 then
      begin
      stacktemp := k;
      splittemp(k, size)
      end
    else
      begin
      { DRB temp }
      stacktemp := newtemp(size);
      end;
  end {stacktemp} ;

{ Register allocation procedures }

{ Currently registers are always spilled to the stack.  At one point regparams
  were being assigned local variable space and would be saved there instead,
  but that turned out to be not necessarily and somewhat wasteful of memory.
  However we might spill to caller-saved registers in the future and this
  code should handle that case with the addition of allocation code.
}

procedure addtempsave(k: keyindex; first, last: nodeptr);

  var
    p: tempsaveptr;

  begin {addtempsave}
    if k < stackcounter then
      begin
      writeln('attemping to add a stack save to a non-stack entry');
      compilerabort(inconsistent);
      end;
    new(p);
    p^.first := first;
    p^.last := last;
    p^.nextsave := keytable[k].saves;
    keytable[k].saves := p;
  end {addtempsave};

function savereg(r: regindex {register to save}) : keyindex;

{ Save the given register on the runtime stack.  This routine is quite clever
  about the process since it attempts to reuse an existing copy of the register
  if possible.  If not, the contents of the register are spilled to the stack.
  This is coded as a function to simplify the coding of "savekey".  Normally,
  one would write this as a procedure with a var param, but one cannot pass a
  packed field as a var param.
}

  var
    i: keyindex; {induction var used to search keytable}
    found: boolean; {set true when we find an existing saved copy}
    saved: boolean; {true if we don't need to save it}
    savekey: keyindex; {where we will save it if we must}
    p: nodeptr;
    tempsave: tempsaveptr;

  begin {savereg}
    i := lastkey;
    found := false;
    saved := false;

    with context[contextsp] do
      while not found and (i >= keymark) do
        begin
        with keytable[i], oprnd do
          if (access = valueaccess) and (refcount > 0) then
            if (r = reg) and regvalid and keytable[properreg].validtemp and
               ((properreg >= stackcounter) or (properreg <= lastkey)) then
              begin
              found := true;
              savekey := properreg;
              saved := regsaved;
              end
            else if (r = reg2) and reg2valid and
               keytable[properreg2].validtemp and
               ((properreg2 >= stackcounter) or (properreg2 <= lastkey)) then
              begin
              found := true;
              savekey := properreg2;
              saved := reg2saved;
              end;
        i := i - 1;
        end;

    if not saved then
      begin
      if not found then
        savekey := stacktemp(long);
      settemp(long, reg_oprnd(r));
      p := newnode(instnode);
      gen2p(p, buildinst(str, true, false), tempkey, savekey);
      addtempsave(savekey, p, lastnode);
{if switcheverplus[test] and (keytable[key].first <> nil) then
begin
writeln(macfile, 'savekey:', savekey);
write_nodes(tempsave^.first, tempsave^.last);
end;
}
      end;
    savereg := savekey;
  end {savereg} ;

procedure markreg(r: regindex {register to clobber} );

{ Mark a register used.  Since such a register is just about to be
  modified,  any operand which depends on its current value must be
  saved.  This is done by scanning the keytable for operands which
  use this register.  If the operand is within the current context,
  the value is saved in a temp.  In any case, the "join" flag is
  set so it will be invalidated at the join context at the end
  of a conditional construct.

  For each operand saved, a scan of unsaved keys is made to set
  any keys with equivalent access to the same temp location.
}

  var
    i, savedreg: keyindex; {induction vars for keytable scan}
    saved: boolean; {true if the register has already been saved}
    j: loopindex;


  begin {markreg}
    regused[r] := true;
    if (r >= firstreg) and (r <= lastreg) then
      begin
      saved := false;
      registers[r] := 0;
      context[contextsp].bump[r] := false;

      for j := loopsp downto 1 do
        loopstack[j].regstate[r].killed := true;

      with context[contextsp] do
        for i := lastkey downto 1 do
          with keytable[i], oprnd do
            if (access = valueaccess) then
              if (r = reg) and regvalid then
              begin
              if i >= keymark then 
                begin
                if not regsaved and (refcount > 0) then
                  begin
                  if not saved then
                    begin
                    savedreg := savereg(r);
                    saved := true;
                    end;
                  regsaved := true;
                  properreg := savedreg;
                  keytable[savedreg].refcount := keytable[savedreg].refcount +
                                                 refcount
                  end;
                regvalid := false;
                end;
              joinreg := true;
              end
            else if (r = reg2) and reg2valid then
              begin
              if i >= keymark then
                begin
                if not reg2saved and (refcount > 0) then
                  begin
                  if not saved then
                    begin
                    savedreg := savereg(r);
                    saved := true;
                    end;
                  reg2saved := true;
                  properreg2 := savedreg;
                  keytable[savedreg].refcount := keytable[savedreg].refcount +
                                                 refcount
                  end;
                reg2valid := false;
                end;
              joinreg2 := true;
              end;
      end;
  end {markreg} ;

procedure markscratchregs;

{procedure calls walk on all of the callee-saved general registers}

  var
    r: regindex;

  begin {markscratchregs}
    for r := 0 to pr - 1 do
      markreg(r);
  end {markscratchregs};


function regvalue(r: regindex): unsigned;

{ the idea here is that callee-saved registers are more expensive than
  caller-saved registers unless it has already been used, because the
  first use invokes a save/restore.  After being used once, they're cheaper
  than scratch registers due to the fact that proc calls kill all
  scratch registers.  This kludge actually fails miserably but we'll work
  on it as we get further on.  
}

  begin {regvalue}
    regvalue := registers[r] + ord(context[contextsp].bump[r]) * 4 +
                ord((r > pr) and not regused[r]) * 2 + ord(r < pr) +
                maxint * ord(r = pr);
  end {regvalue} ;

function countreg: regindex;

{ Returns lowest register usage count of any general register.
  Register count is increased if register is seen to be useful
  beyond the next join point. This situation is recorded in the
  bump field of the context stack when the context is first entered
  via a savelabel.  This code prefers a scratch register, however
  once a calle-saved register has been used, the cost of reusing
  it is actually cheaper as we know it will be saved and restored
  for this block.
}

  var
    cnt: integer;
    r: regindex;

  begin {countreg}
    cnt := maxint;
    for r := firstreg to lastreg do
      if regvalue(r) < cnt then
        cnt := regvalue(r);
    countreg := cnt;
  end {countreg} ;


function bestreg(reg: regindex {register to check} ): boolean;

{ Returns true if reg is the "best" register to step on.
}

  var
    cnt: integer;

  begin {bestreg}
    cnt := countreg;
    bestreg := (reg <= lastreg) and (reg >= firstreg) and
               (regvalue(reg) <= cnt);
  end {bestreg} ;


function getreg: regindex;

{ Return the least worthwhile data register.  If necessary, the current
  contents of the selected register is flushed via markreg.
}

  var
    cnt: integer;
    r: regindex;


  begin {getreg}
    cnt := countreg;
    r := lastreg;
    while (r >= firstreg) and (regvalue(r) <> cnt) do
      r := r - 1;
    markreg(r);
    getreg := r;
  end {getreg} ;

{various keytable manipulation routes}

procedure savedstkey(k: keyindex);

  var
    p: nodeptr;
  begin
    with keytable[k],oprnd do
      if regvalid and not regsaved and (reg >= firstreg) and
         (reg <= lastreg) and keytable[properreg].validtemp then
        begin
        p := newnode(instnode);
        gen2p(p, buildinst(str, true, false), k, properreg);
        addtempsave(properreg, p, lastnode);
        regsaved := true;
        end;
  end;

procedure savekey(k: keyindex {operand to save} );

{ Save all volatile registers required by given key.
}


  begin
    if k > 0 then
      with keytable[k] do
        if access = valueaccess then
          begin
          bumptempcount(k, - refcount);
          with oprnd do
            begin
              if regvalid and not regsaved and (reg <= lastreg) and
                 (reg >= firstreg) and (reg <> noreg) then
                begin
                properreg := savereg(reg);
                regsaved := true;
                end;
              if reg2valid and not reg2saved and (reg2 <> noreg) and
                 (reg2 >= firstreg) and (reg2 <= lastreg) then
                begin
                properreg2 := savereg(reg2);
                reg2saved := true;
                end;
            end;
          bumptempcount(k, refcount);
          end;
  end {savekey} ;

  procedure saveactivekeys;

    var
      i: keyindex; {for stepping through active portion of keytable}


    begin {saveactivekeys}
     if dontchangevalue <= 0 then
      begin
      for i := context[contextsp].keymark to lastkey do
        with keytable[i] do
begin
          if (refcount > 0) and not (regsaved and reg2saved)
          then savekey(i);
end;
      end;
    end {saveactivekeys} ;

procedure allowmodify(var k: keyindex; {operand to be modified}
                      forcecopy: boolean {caller can force temp} );

{ Makes sure that the operand "k" can be modified.  If the operand was
  generated before the last conditional jump, it must not be modified, so
  a copy of the key is made in the temporary
  key area and the value of "k" modified accordingly.  This temporary
  key can be used in generating the current operand.  The boolean "forcecopy"
  forces this routine to create a copy of the key.
}


  begin
    if forcecopy or (k <= context[contextsp].keymark) or precedeslastbranch(k) then
      begin
      if tempkey = lowesttemp then compilerabort(interntemp);
      tempkey := tempkey - 1;
      keytable[tempkey] := keytable[k];
      keytable[tempkey].refcount := 0;
      keytable[tempkey].copycount := 0;
      keytable[tempkey].regsaved := false;
      keytable[tempkey].reg2saved := false;
      k := tempkey
      end;
  end {allowmodify} ;


procedure lock(k: keyindex {operand to lock} );

{ Make sure that operand "k" will not be deallocated by setting
  reference counts to an impossibly high value.
}


  begin
    adjustregcount(k, maxrefcount);
    bumptempcount(k, maxrefcount);
  end {lock} ;


procedure unlock(k: keyindex {operand to unlock} );

{ Undoes the effects of "lock" so normal deallocation can be done.
}


  begin
    bumptempcount(k, - maxrefcount);
    adjustregcount(k, - maxrefcount);
  end {unlock} ;


procedure changevalue(var key1: keyindex; {key to be changed}
                      key2: keyindex {source of key data} );

{ Effectively assigns the contents of key2 to key1.  This is complicated
  by the same things as allowmodify, and by the need to adjust reference
  counts.  If the key will be referenced later, it is saved.
}


  begin
    allowmodify(key1, dontchangevalue > 0);
    with keytable[key1] do
      begin
      adjustregcount(key1, - refcount);
      bumptempcount(key1, - refcount);
      regsaved := keytable[key2].regsaved or (refcount <= 0);
      reg2saved := keytable[key2].reg2saved or (refcount <= 0);
      regvalid := keytable[key2].regvalid;
      reg2valid := keytable[key2].reg2valid;
      properreg := keytable[key2].properreg;
      properreg2 := keytable[key2].properreg2;
      packedaccess := keytable[key2].packedaccess;
      oprnd := keytable[key2].oprnd;
      bumptempcount(key1, refcount);
      adjustregcount(key1, refcount);
      end;
    savekey(key1);
  end {changevalue} ;

procedure makeaddressable(var k: keyindex);

{ Force addressability of specified key. Also permanently makes the new
  address mode available subject to restrictions of allowmodify. A key
  becomes unaddressed when one of the mark routines clears regvalid or
  reg2valid. Makeaddressable reloads the missing register(s) and clears
  the marked reg/reg2 status.
}

  var
    restorereg, restorereg2: boolean;
    t: keyindex;

  procedure recall_reg(regx: regindex; properregx: keyindex);

    { Unkill a general reg if possible.
    }
    begin
      with loopstack[loopsp] do
        if (thecontext = contextsp) and (loopoverflow = 0) and
           (thecontext <> contextdepth - 1) and
           (regstate[regx].stackcopy = properregx) then
          regstate[regx].killed := false;
    end;

  begin {makeaddressable}
    with keytable[k], oprnd do
      begin
      restorereg := not regvalid;
      restorereg2 := not reg2valid;
      if restorereg then keytable[properreg].tempflag := true;
      if restorereg2 then keytable[properreg2].tempflag := true;
      end;
    if restorereg or restorereg2 then allowmodify(k, false);
    with keytable[k], oprnd do
      begin
      adjustregcount(k, - refcount);
      if restorereg then
        begin
        {DRB try to restore a register operand to the current register param
         target if possible.
        }
        if (oprnd.mode = register) and
           (registers[keytable[regparam_target].oprnd.reg] = 1) then
          oprnd.reg := keytable[regparam_target].oprnd.reg
        else
          oprnd.reg := getreg;
        recall_reg(oprnd.reg, properreg);
        settemp(long, reg_oprnd(reg));
        gen2(buildinst(ldr, true, false), tempkey, properreg);
        tempkey := tempkey + 1;
        end;
      if restorereg2 then
        begin
        oprnd.reg2 := getreg;
        recall_reg(oprnd.reg2, properreg2);
        settemp(long, reg_oprnd(reg2));
        gen2(buildinst(ldr, true, false), tempkey, properreg);
        tempkey := tempkey + 1;
        end;
      regvalid := true;
      reg2valid := true;
      joinreg := false;
      joinreg2 := false;
      regsaved := regsaved and keytable[properreg].validtemp;
      reg2saved := reg2saved and keytable[properreg2].validtemp;
      adjustregcount(k, refcount);
      end;
  end {makeaddressable} ;

procedure address(var k: keyindex);

{ Shorthand concatenation of a dereference and makeaddressable call }


  begin
    dereference(k);
    makeaddressable(k);
  end {address} ;


procedure addressboth;

 { address both operands of a binary pseudoop }


  begin
    address(right);
    lock(right);
    address(left);
    unlock(right);
  end {addressboth} ;

procedure makedstaddressable(k: keyindex);
  var
    i: keyindex;

  begin
    with keytable[k], oprnd do
      if (mode = register) then
        begin
        if not regvalid then
          begin
          reg := getreg;
          regvalid := true;
          adjustregcount(k, keytable[k].refcount);
          end;
        regsaved := false;
        if (reg >= firstreg) and (reg <= lastreg) then
          for i := context[contextsp].keymark downto 1 do
            if (keytable[i].access = valueaccess) then
              begin
              if keytable[i].oprnd.reg = reg then
                keytable[i].joinreg := true;
              if keytable[i].oprnd.reg2 = reg then
                keytable[i].joinreg2 := true;
              end;
        end
      else makeaddressable(k);
  end;

procedure addressdst(k: keyindex);

  begin
    dereference(k);
    makedstaddressable(k);
  end;


procedure settargetorreg;

{ Set the current key value to the target, if possible,  If
  not allocate a register and set the key value to that.
}

begin {settargetorreg}
  if (keytable[target].oprnd.mode = register) and keytable[target].regvalid then
    setallfields(target)
  else
    setvalue(reg_oprnd(getreg()));
end {settargetorreg};

procedure initblock;

{ Initialize global variables for a new block.
}

  var
    i: integer; {general purpose induction variable}

  begin
    regparam_target := 0; {reset switch}

    while (currentswitch <= lastswitch) and
          ((switches[currentswitch].mhi = gethi) and
          (switches[currentswitch].mlow <= getlow) or
          (switches[currentswitch].mhi < gethi)) do
      with switches[currentswitch] do
        begin
        switchcounters[s] := switchcounters[s] + v;
        currentswitch := currentswitch + 1;
        end;

    { initialize stack temp allocation vars

      Pascal-2 code generators traditionally use keysize as the
      base of the stack, but on this machine we might want to
      spill to registers or the like so we're using a variable
      for the stack base to make things more flexible.
    }

    stackbase := keysize;
    stackcounter := stackbase;
    stackoffset := 0;
    maxstackoffset := 0;
    keytable[stackcounter].oprnd := index_oprnd(unsigned_offset, sp, 0);

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

    keytable[keysize].refcount := maxrefcount;

    keytable[loopsrc].refcount := maxrefcount;
    keytable[loopsrc1].refcount := maxrefcount;
    keytable[loopdst].refcount := maxrefcount;

    {zero out all register data}
    for i := 0 to maxreg do
      begin
      regused[i]:=false;
      fpregused[i]:=false;
      registers[i] := 0;
      fpregisters[i] := 0;
      context[1].bump[i] := false;
      context[1].fpbump[i] := false;
      end;

  end {initblock} ;

{ code gen utilities }

function equivaddr(l, r: keyindex): boolean;

{ True if the addresses accessed for key l and key r are the same.
}

  var same: boolean;

  begin {equivaddr}
    same := true;
    with keytable[l].oprnd, keytable[r] do
      begin
      if (access <> valueaccess) or (keytable[l].access <> valueaccess) or
         (packedaccess <> keytable[l].packedaccess) or
         (oprnd.mode <> mode) or
         (oprnd.reg <> reg) or (oprnd.reg2 <> reg2) then
        same := false;
      if same then
        case oprnd.mode of
        shift_reg: same := (reg_shift = oprnd.reg_shift) and
                          (shift_amount = oprnd.shift_amount);
        extend_reg: same := (reg_extend = oprnd.reg_extend) and
                            (extend_shift = oprnd.extend_shift) and
                            (extend_signed = oprnd.extend_signed);
         pre_index, post_index, signed_offset, unsigned_offset:
           same := (index = oprnd.index);
         reg_offset: same := (shift = oprnd.shift) and
                             (extend = oprnd.extend) and
                             (signed = oprnd.signed);
         otherwise same := true;
         end;
      end;
    equivaddr := same;
  end {equivaddr} ;


procedure gensimplemove(src, dst: keyindex);

  { move a simple item from the src to dst, currently just values that
    aren't in a floating-point register.
  }

  begin {gensimplemove}
    if not equivaddr(dst, src) then
      if (keytable[dst].oprnd.mode = register) and
         ((keytable[src].oprnd.mode = register) or
          (keytable[src].oprnd.mode in [immediate, immediate16]))  then
        gen2(buildinst(mov, true, false), dst, src)
      else if keytable[dst].oprnd.mode = register then
        gen2(ldrinst(keytable[src].len, keytable[src].signed), dst, src)
      else if keytable[src].oprnd.mode <> register then
        begin
        lock(dst);
        settemp(long, reg_oprnd(getreg));
        unlock(dst);
        if keytable[src].oprnd.mode = immediate then
          gen2(buildinst(mov, true, false), tempkey, src)
        else
          gen2(ldrinst(keytable[src].len, keytable[src].signed), tempkey, src);
        gen2(strinst(keytable[dst].len), tempkey, dst);
        tempkey := tempkey + 1;
        end
      else
        gen2(strinst(keytable[dst].len), src, dst);
  end {gensimplemove} ;

procedure genmoveaddress(src, dst: keyindex);

{ Move the address of the src value to the destination value,
  which must be a general register.
}

  begin {genmoveaddress}
{
    if keytable[src].oprnd.mode = register then
      begin
      keytable[keytable[src].properreg].tempflag := true;
      if not keytable[src].regsaved then
        begin
        write('fix_effective_addr screw-up ');
        compilerabort(inconsistent);
        end;
      src := keytable[src].properreg;
      end;
}
    with keytable[src].oprnd do
      case mode of
      signed_offset, unsigned_offset:
        if (keytable[dst].oprnd.mode <> register) or
           (keytable[dst].oprnd.reg <> reg) or
           (index <> 0) then
          begin
          settemp(long, reg_oprnd(reg));
          settemp(long, immediate_oprnd(index, false));
          gen3(buildinst(add, true, false), dst, tempkey + 1, tempkey);
          tempkey := tempkey + 2;
          end;
      reg_offset:
        begin
        settemp(long, reg_oprnd(reg));
        settemp(long, extend_reg_oprnd(reg2, extend, shift, signed));
        gen3(buildinst(add, true, false), dst, tempkey + 1, tempkey);
        tempkey := tempkey + 2;
        end;
      otherwise
        begin
        write('bad operand in genmoveaddress ');
        compilerabort(inconsistent);
        end;
      end;
  end; {genmoveaddress}

function signedoprnds : boolean;

{ True if both left and right operands of the current operation are
  signed.  Picks up the operands from the globals "left" and "right".
}


  begin
    signedoprnds := keytable[left].signed and keytable[right].signed;
  end {signedoprnds} ;

procedure loadreg(var k: keyindex; other: keyindex);

{load key into a register for read access, without bothering other

 won't work for longs extended from shorter sized most likely at the moment
}

begin {loadreg}
  if keytable[k].oprnd.mode <> register then
    begin
    lock(other);
    settemp(keytable[k].len, keytable[k].oprnd);
    settemp(keytable[k].len, reg_oprnd(getreg));
    gensimplemove(tempkey + 1, tempkey);
    unlock(other);
    changevalue(k, tempkey);
    tempkey := tempkey + 2;
    end;
end {loadreg} ;

procedure clearcontext;

{ Clear the current context.  That is, forget where everything is in the
  current context.  Any registers containing temps are saved.
  This is called at labels when the context at this point is unpredictable.
}

  var
    i: regindex; {induction var for killing variables}


  begin
    for i := 0 to lastreg do if regused[i] then markreg(i);
{
    for i := 0 to lastfpreg do if fpregused[i] then markfpreg(i);
}

{ Preserve innermost for loop induction register if this is the first
  clear at the current level (we know the first one is derived from the
  for loop itself, and therefore is under our control).
}

    if (forsp > 0) and forstack[forsp].firstclear then
      begin
      forstack[forsp].firstclear := false;
      with forstack[forsp], keytable[forkey] do
        if not regvalid then
          begin
          regvalid := true;
          adjustregcount(forkey, refcount);
          end;
      end;

    context[contextsp].clearflag := true;
    context[contextsp].lastbranch := lastnode;
  end {clearcontext} ;

procedure enterloop;

{ Enter a loop construct.  Travrs has internally done a 'clearcontext'
  operation and has issued a 'clearlabel' or 'fortop' pseudoop.  All
  registers are empty at this point except those generated by 'with'
  statements and for loop indices.  We track these registers, and
  if they are spoiled by code within the loop, restore them at the
  bottom.

  Since loops may be nested, we use a special stack of limited size
  to do the required tracking.  If the stack is full, we simply do
  a clearcontext and increment the overflow counter.
}

  var
    i: regindex; {for stepping through volatile registers}


  begin {enterloop}
    if loopsp < loopdepth then
      begin
      if forsp > 0 then forstack[forsp].firstclear := false;

      loopsp := loopsp + 1;

      with loopstack[loopsp] do
        begin
        { Save the bump fields so we can restore them properly.
        }
        thecontext := contextsp;
        bump := context[contextsp].bump;
        fpbump := context[contextsp].fpbump;
        savefirst:= context[contextsp].first;
        savelast:= context[contextsp].last;
        savelastbranch := context[contextsp].lastbranch;

        for i := 0 to lastreg do
          with regstate[i] do
            begin
            reloadfirst := nil; { not reloaded yet }
            killed := false;
            used := registers[i] > 0;
            if used then context[contextsp].bump[i] := true;
            active := context[contextsp].bump[i];
            if active then
              begin
              stackcopy := savereg(i);
              keytable[stackcopy].refcount := keytable[stackcopy].refcount +
                                              1;
              end;
            end; {with}
{
        for i := 0 to lastfpreg do
          with fpregstate[i] do
            begin
            reloadfirst := nil; { not reloaded yet }
            killed := false;
            used := (fpregisters[i] > 0);
            if used then context[contextsp].fpbump[i] := true;
            active := context[contextsp].fpbump[i];
            if active then
              begin
              stackcopy := savefpreg(i);
              keytable[stackcopy].refcount := keytable[stackcopy].refcount +
                                              1;
              end;
            end; {with}
}
      end; {with loopstack}
      context[contextsp].clearflag := true;
      context[contextsp].lastbranch := lastnode;
      context[contextsp].first := lastnode; { prevent popping stack
                                                  in loop }
      end
    else
      begin
      clearcontext;
      loopoverflow := loopoverflow + 1;
      end;
  end {enterloop} ;


procedure reloadloop;
  {
  We can't do the restore of loop registers at the bottom of a repeat loop
  since the until may kill restored registers, therefore we restore at
  the top and then delete any unneeded restores at the bottom. Since we
  can't tell the difference from while loops they work the same way.
  }

  var
    i: regindex;
    r: keyindex;


  begin
    if loopoverflow = 0 then
      begin
      with loopstack[loopsp] do
        begin
        settemp(long, reg_oprnd(0)); {dummy}
        r := tempkey;

        for i := 0 to lastreg do
          with regstate[i] do
            if active then
              begin
              keytable[r].oprnd.reg := i;
              reloadfirst := newnode(instnode);
              gen2p(reloadfirst, ldrinst(long, true), r, stackcopy);
              reloadlast := lastnode;
              end;


{
        keytable[r].oprnd.mode := fpregister;
        for i := 0 to lastfpreg do
          with fpregstate[i] do
            if active then
              begin
              keytable[r].oprnd.reg := i;
              reload := lastnode + 1;
              gensimplemove(stackcopy, r);
              end;
}
        end;
      end;
  end {reloadloop} ;



{start of individual pseudoop codegen procedures}

{ context processing pseudops }

procedure copyaccessx;

{ Make a copy at the current context level of the keytable entry
  for the operand in oprnds[1].  This allows modifications to the
  local key without affecting the outer context key.  If the flag
  "clearflag" is set in the local context mark,  The properaddress of
  the key is copied into the local key, as we assume that the volatile
  copy of the key may not exist at this point, and we must use the
  non-volatile copy in "properaddress".

  The refcount of the key being copied (and all intermediate copies)
  is reduced by the difference between the local refcount and
  copycount.  This number is the number of references in the new
  local context.
}

  var
    delta: integer; {difference between refcount and copycount}
    useproperaddress: boolean; {true if copy is logically within a loop}


  begin
    { Because of hoisting, we may have a copy operator appearing
      before the clearlabel, defeating the purpose of the context
      clearflag.  Fortunately, travrs warns us by passing a flag
      in the len field.
    }
    useproperaddress := (len <> 0) or context[contextsp].clearflag;

    with keytable[key] do
      begin {copy the key}
      len := keytable[left].len;
      copylink := left;
      delta := refcount - copycount;
      end;

    with keytable[left], oprnd do
      begin
      keytable[key].regsaved := regsaved;
      keytable[key].reg2saved := reg2saved;
      keytable[key].regvalid := regvalid;
      keytable[key].reg2valid := reg2valid;
      keytable[key].properreg := properreg;
      keytable[key].properreg2 := properreg2;
      keytable[key].tempflag := tempflag;
      keytable[key].packedaccess := packedaccess;

      { Point to the properaddress if clearcontext}
      if useproperaddress then
        begin
        if joinreg then keytable[key].regvalid := false;
        if joinreg2 then keytable[key].reg2valid := false;
        end;

      with loopstack[loopsp] do
        begin
        with regstate[reg] do
          if active and keytable[key].regvalid and 
             (keytable[key].oprnd.mode in [register, tworeg, shift_reg, extend_reg,
                                           relative, pre_index, post_index, signed_offset,
                                           unsigned_offset, reg_offset])  then used := true;
        with regstate[reg2] do
          if active and keytable[key].reg2valid and
             (keytable[key].oprnd.mode in [tworeg, reg_offset]) then used := true;
        with fpregstate[reg] do
          if active and keytable[key].regvalid and
             (keytable[key].oprnd.mode = fpregister) then used := true;

        end; { loopstack[loopsp] }

      setvalue(oprnd);
      keytable[key].signed := signed;
      keytable[key].signlimit := signlimit;
      end;

    { Now decrement refcounts }
    repeat
      with keytable[left] do
        begin
        refcount := refcount - delta;
        copycount := copycount - delta;
        bumptempcount(left, - delta);
        left := copylink;
        end;
    until left = 0;
  end {copyaccessx} ;


procedure clearlabelx;

{ Define a label at the head of a loop.  All CSE's except 'with'
  expressions and for loop indices were purged by travrs.  The
  routine 'enterloop' enters bookkeeping information which allows
  registers to be used within the loop.  This scheme depends upon
  'restoreloopx' properly restoring registers to their state as of
  loop entry.
}


  begin
    saveactivekeys;
    enterloop;
{    clearcontext;}
    definelabel(pseudoinst.oprnds[1]);
    reloadloop;
  end {clearlabelx} ;

procedure savelabelx;

{ Define a label and save the current context for later restoration.
  This is called at the beginning of each branching structure, and
  corresponds to the same operation in "travrs".

  The context is saved in the "contextstack" data structure.
}

  var
    i: integer; {induction var for scanning keys and registers.}


  begin

    adjustdelay := false; {DRB probably not needed for arm64 after we pull calls from paramlists}
    definelabel(pseudoinst.oprnds[1]);
    saveactivekeys;
    contextsp := contextsp + 1;

    with context[contextsp] do
      begin
      savedstackoffset := stackoffset;
      savedstackcounter := stackcounter;
      clearflag := false;
      keymark := lastkey + 1;
      first := lastnode;
      last := lastnode;
      lastbranch := nil;
      bump := context[contextsp - 1].bump;
      fpbump := context[contextsp - 1].fpbump;
      for i := 0 to lastreg do if registers[i] > 0 then bump[i] := true;
      for i := 0 to lastfpreg do if fpregisters[i] > 0 then fpbump[i] := true;
      end;

    for i := context[contextsp - 1].keymark to lastkey do
      adjustregcount(i, - keytable[i].refcount);

  end {savelabelx} ;

procedure restorelabelx;

{ Define a label and restore the previous environment.  This is used at the
  end of one branch of a branching construct.  It gets rid of any temps
  generated along this branch and resets to the previous context.
}

  var
    i: keyindex; {used to scan keys to restore register counts}


  begin
    definelabel(pseudoinst.oprnds[1]);

    while lastkey >= context[contextsp].keymark do
      with keytable[lastkey] do
        begin
{DRB why aren't refcounts zero?}
        bumptempcount(lastkey, -refcount);
        adjustregcount(lastkey, -refcount);
        refcount := 0;
        lastkey := lastkey - 1;
        end;

{DRB is this order correct? }
    processregsaves;
    stackcounter := context[contextsp].savedstackcounter;
    stackoffset := context[contextsp].savedstackoffset;
    contextsp := contextsp - 1;
    for i := context[contextsp].keymark to lastkey do
      adjustregcount(i, keytable[i].refcount);
  end {restorelabelx} ;


procedure restoreloopx;
  {
  Restore necessary registers at the bottom of a loop. This is necessary
  because code at the top of the loop may depend upon these register
  values.
  }

  var
    i: regindex;
    tempreg: keyindex;


  begin
    if loopoverflow > 0 then loopoverflow := loopoverflow - 1
    else
      begin
      with loopstack[loopsp] do
        begin
        { get bump field back to what it should be }
        context[thecontext].bump := bump;
        context[thecontext].fpbump := fpbump;

        context[thecontext].first := savefirst;
        context[thecontext].lastbranch := savelastbranch;

        { seem like we should only restore registers that were used? hmm. }
        settemp(long, reg_oprnd(0)); {dummy}
        tempreg := tempkey;

        for i := 0 to lastreg do
          with regstate[i] do
            if active then
              begin
              if killed then
                begin
                keytable[stackcopy].tempflag := true;
                { if not restored at top of loop (i.e. for loop) do it now }
                if reloadfirst = nil then
                  begin
                  markreg(i); { tell current user }
                  keytable[tempreg].oprnd.reg := i;
                  gen2(ldrinst(long, true), tempreg, stackcopy);
                  end;
                end
              else if reloadfirst <> nil then deletenodes(reloadfirst, reloadlast);
              keytable[stackcopy].refcount := keytable[stackcopy].refcount -
                                              1;
              end;

{
        keytable[tempreg].oprnd.m := fpreg;

        for i := 0 to lastfpreg do
          with fpregstate[i] do
            if active then
              begin
              if killed then
                begin
                keytable[stackcopy].tempflag := true;
                { if not restored at top of loop (i.e. for loop) do it now }
                if reload = nil then
                  begin
                  markfpreg(i); { tell current user }
                  keytable[tempreg].oprnd.reg := i;
                  gensimplemove(stackcopy, tempreg);
                  end;
                end
              else if reload <> 0 then deletenodes(reloadfirst, reloadlast);
              keytable[stackcopy].refcount := keytable[stackcopy].refcount -
                                              1;
              end;
}
        end; {with loopstack}
      loopsp := loopsp - 1;
      end;
  end {restoreloopx} ;

procedure joinlabelx;

{ Define a label and adjust temps at the end of a forking construction.
  Temps which are used along any branch of the fork have the "join" flag
  set, and at this point such temps are flagged as used.  This corresponds
  to the "join" construction in travrs.
}

  var
    i: keyindex; {induction var for scanning keys}

  begin
    definelabel(pseudoinst.oprnds[1]);
    for i := context[contextsp].keymark to lastkey do
      with keytable[i] do
        begin
        adjustregcount(i, - refcount);
        if joinreg then regvalid := false;
        if joinreg2 then reg2valid := false;
        adjustregcount(i, refcount);
        end;
  end {joinlabelx} ;

procedure pseudolabelx;

{ Define a pseudo-code label.  This is the basic label definition routine.
}


  begin
    definelabel(pseudoinst.oprnds[1]);
  end {pseudolabelx} ;

procedure defforindexx(sgn, { true if signed induction var }
                       lit: boolean { true if constant starter value } );

{ Define a for-loop induction variable's starting value. There are two
  cases - a global register induction variable and a stack induction
  variable. The stack case will actually delay pushing the variable
  until we are inside the loop body.  In many cases the push is not
  needed at all.
}


  begin {defforindexx}
    saveactivekeys;
    address(right);

    if lit then
      begin
      settemp(len, immediate_oprnd(pseudoinst.oprnds[1], false));
      left := tempkey
      end
    else
      begin
      lock(right);
{ DRB
      unpackshrink(left, len);
}
      address(left);
      unlock(right);
      end;

    keytable[key].signed := sgn;

    { Allocate a register unless this is a permanently assigned register
      variable.  If target <> 0, we must preserve the running index in
      the actual variable, if not, we'll issue a "savekey" in "fortopx"
      to save the running index on the stack.  Often, this can later be
      deleted as with any other stack temp, making register-only loops
      quite common.
    }

    forsp := forsp + 1;
    with forstack[forsp], keytable[key] do
      begin
      nonvolatile := target <> 0;
      globalreg := (keytable[right].oprnd.mode = register) and
                   (keytable[right].oprnd.reg >= lastreg);
    if not globalreg then
      begin
      settemp(long, reg_oprnd(getreg));
      setkeyvalue(tempkey);    {destroys signed field}
      keytable[key].regsaved := true;
      if nonvolatile then
        begin
        keytable[right].validtemp := true;

        { DRB something similar for long offsets for aarch64 }
        { if this "nonvolatile" variable is greater than 32KB from the
          frame base and we're in 68K mode, it will actually be relative
          to some volatile A register.  In this case, we need to force
          an extra reference to it so that the stack copy will be preserved
          and restored via the enter/exitloop mechanism.  It will be
          dereferenced in fortopx and should be a NOP in other cases.
        }
        rereference(right);

        keytable[key].properreg := right;
        end;
      end
    else setkeyvalue(right);

    keytable[key].signed := sgn;

    { We make it long if it's free, or if it might be used as an index.
    }
    originalreg := oprnd.reg;
    litinitial := lit;
    forkey := key;
    firstclear := true;
    savedlen := len;
    initval := pseudoinst.oprnds[1];
    end;

    gensimplemove(left, key);

    dontchangevalue := 0;

  end {defforindexx} ;

procedure fortopx(signedbr, unsignedbr: insts { proper exit branch });

{ Start a for loop, top or bottom.  Branch arguments determine if we
  are going up or down.  If we have constant limits we do not generate a
  cmp/brfinished pair at this point. If the induction var is on the
  stack we will force storage of the original loaded register for the
  value onto the stack after the comparison (if there is one).
}

  var
    branch: insts;
    regkey: keyindex; {descriptor of for-index register}


  begin {fortopx}
    with forstack[forsp] do
      begin
      if keytable[forkey].signed then branch := signedbr
      else branch := unsignedbr;
      pseudolabelx;
      settemp(long, reg_oprnd(originalreg));
      regkey := tempkey;
      keytable[regkey].len := savedlen;

      if target <> 0 then
        begin
        makeaddressable(target);
{ DRB
        shrink(target, keytable[forkey].len);
}
        loadreg(target, regkey);
        gen2(buildinst(cmp, savedlen = long, false), regkey, target);
        genbr(branch, pseudoinst.oprnds[2]);
        end;

      if nonvolatile and not globalreg
      then gensimplemove(regkey, keytable[forkey].properreg)
      else
        begin
        keytable[forkey].regsaved := false;
        savekey(forkey);
        end;

      enterloop;

      { see defforindexx for an explaination of this }
      if nonvolatile and not globalreg then
        dereference(keytable[forkey].properreg);
      end;

  end {fortopx} ;

procedure forbottomx(improved: boolean; { true if cmp at bottom }
                     incinst, { add or sub }
                     signedbr, unsignedbr: insts {branch to top});

{ Finish a for loop. If improved is true, we inc/dec and compare at
  this point. If improved is false, we inc/dec and branch to comparison
  at the top of the loop. We pop off induction variable to save a word
  if the loop is finished. The code at the top of the loop will re-push
  the value if we are not finished.
}

  var
    sgn: boolean;
    needcompare: boolean; {need to generate a comparison at end of loop}
    branch: insts;
    maxvalue: unsigned; {"cmp" instruction works if limit value < maxvalue}
    i: 1..4; {DRB: induction var limited by 32-bit integers}
    byvalue: unsigned; { BY value (always "1" for Pascal) }


  begin {forbottom}
    byvalue := len;
    context[contextsp].lastbranch := context[contextsp].first;

    with forstack[forsp] do
      begin
      sgn := keytable[forkey].signed;
      dereference(forkey);
      if sgn then branch := signedbr
      else branch := unsignedbr;
      with keytable[forkey], oprnd do
        begin
        maxvalue := 127;
        for i := 2 to max(word, len) do maxvalue := maxvalue * 256 + 255;
        if not sgn then maxvalue := maxvalue * 2 + 1;
        if not regvalid or (mode <> register) or (reg <> originalreg) then
          begin
          settemp(long, reg_oprnd(originalreg));
          keytable[properreg].tempflag := true;
          gensimplemove(properreg, tempkey);
          forkey := tempkey;
          if loopoverflow = 0 then
            loopstack[loopsp].regstate[originalreg].killed := false;
          end;
        end;
      keytable[forkey].len := savedlen;
      restoreloopx;

      { The following tests determine how we detect the last iteration through
        the loop when the initial and final values are both constant.  We add
        or subtract the step value then compare with the final value, and loop
        if we've not passed by the final value.  Normally, we issue a compare
        instruction, but if the add or subtract causes overflow (or carry, in
        the unsigned case) the compare won't work. On the bright side, not
        only does the compare not work but is is not needed, and a simple
        branch on no overflow (or carry) is sufficient.

        Below, "needcompare" is set true if overflow (carry) will not occur
        when we "pass over" the final value, in which case we'll issue the
        compare.
      }

      {DRB prevent ifinite loops at 8, 16, 32 bit boundaries}
      with keytable[target].oprnd, pseudoinst do
        begin
        if improved then
          if incinst = add then
            needcompare := (unsignedint(maxvalue - imm_value) >= byvalue)
                           or (unsignedint(maxvalue - initval)
                               mod byvalue < unsignedint(maxvalue - imm_value)) 
          else
            if sgn then
              needcompare := (unsignedint(imm_value + maxvalue + 1) >=
                             byvalue) or
                             (initval mod byvalue < imm_value + maxvalue + 1)
            else needcompare := (unsignedint(imm_value) >= byvalue) or
                                (unsignedint(initval) mod
                                 byvalue < imm_value)
        else needcompare := false;
        end;

      settemp(long, immediate_oprnd(byvalue, false)); { "for" step for Modula-2 }
      gen3(buildinst(incinst, len = long, true), forkey, forkey, tempkey);

      if needcompare then
        begin
        address(target);
        if tempkey = lowesttemp then compilerabort(interntemp);
        tempkey := tempkey - 1;
        keytable[tempkey] := keytable[target];
        target := tempkey;

        { Change comparisons against 1 to be comparisions against 0.
        }

        { DRB: later if it makes sense
        with keytable[target].oprnd do
          if offset = 1 then
            begin
            if incinst = sub then
              begin
              offset := 0;
              if sgn then branch := bgt else branch := bhi;
              end;
            end
          else if offset = -1 then
            if sgn and (incinst = add) then
              begin
              offset := 0;
              branch := blt;
              end;
         }

          with keytable[forkey], oprnd do
            begin
            gen2(buildinst(cmp, len = long, false), forkey, target);
            genbr(branch, pseudoinst.oprnds[1]);
            end;
          end {if needcompare}
        else if sgn then genbr(bvc, pseudoinst.oprnds[1])
        else if incinst = sub then
          genbr(bcs, pseudoinst.oprnds[1]) 
          else genbr(bcc, pseudoinst.oprnds[1])
      end; {with forstack[forsp]}

    if not needcompare then dereference(target);

    pseudoinst.oprnds[1] := pseudoinst.oprnds[2];
    forsp := forsp - 1;
    joinlabelx;
    context[contextsp].lastbranch := context[contextsp].first;
  end {forbottomx} ;


procedure shiftintx(backwards: boolean);

{ Shift the operand by the distance given in oprnds[2].
}

  var
    shiftfactor: integer; {amount to shift}
    shiftinst: insts; {either asl, asr, or lsr}
    knowneven: boolean; {true if result is known to be even.  Left shifts will
                         always give an even result; we can't tell for right
                         shifts. }


  begin {shiftintx}
    addressboth;
    settargetorreg;
    lock(key);
    loadreg(left, right);
{
    unpackshrink(left, len);
    lock(left);
    unpackshrink(right, word);
    unlock(left);
}
    shiftinst := lslinst;
    if keytable[right].oprnd.mode = immediate then
      begin
      shiftfactor := keytable[right].oprnd.imm_value;
      knowneven := shiftfactor > 0;
      if shiftfactor < 0 then backwards := not backwards;
      shiftfactor := abs(shiftfactor);
      settemp(len, immediate_oprnd(shiftfactor, false));
      right := tempkey;
      end
    else
      loadreg(right, left);
    unlock(key);
    if backwards then
      if keytable[left].signed then shiftinst := asrinst
      else shiftinst := lsrinst;
    gen3(buildinst(shiftinst, len = long, false), key, left, right);
    keytable[key].signed := keytable[left].signed;
  end {shiftintx} ;


{shared by add, sub, mul (so far)}

procedure integerarithmetic(inst: insts {simple integer inst} );

{ Generate code for a simple binary, integer operation (add, sub, etc.)
}

  begin {integerarithmetic}
    {unpkshkboth(len);}
    addressboth;
    settargetorreg;
    lock(key);
    loadreg(left, right);
    if (inst in [mul, sdiv, udiv]) or (keytable[right].oprnd.mode <> immediate) then
      loadreg(right, left);
    gen3(buildinst(inst, len = long, false), key, left, right);
    unlock(key);
    keytable[key].signed := signedoprnds;
  end {integerarithmetic} ;

procedure unaryint(inst: insts);

{ Generate an operator such a neg that has only one source operand,
  which must be in a register.  Generally these are aliases for
  generalized instructions such as sub, with one operand being the
  zero register.
}


  begin {incdec}
{    unpackshrink(left, len);}
    settargetorreg; 
    lock(key);
    address(left);
    loadreg(left, 0);
    unlock(key);
    gen2(buildinst(inst, len = long, false), key, left);
    keytable[key].signed := keytable[left].signed;
  end {incdec} ;

procedure compintx;

{DRB cinv doesn't work with al!}
  begin {compintx}
{    unpackshrink(left, len);}
    settargetorreg; 
    lock(key);
    address(left);
    loadreg(left, 0);
    unlock(key);
    gen2(buildinst(mvn, len = long, false), key, left);
    keytable[key].signed := keytable[left].signed;
  end {compintx};

procedure incdec(inst: insts {add, sub} );

{ Generate add/sub #1, left.  Handles compbool, incint and decint pseudoops.
}


  begin {incdec}
{    unpackshrink(left, len);}
    settargetorreg; 
    lock(key);
    address(left);
    loadreg(left, 0);
    unlock(key);
    settemp(len, immediate_oprnd(1, false));
    gen3(buildinst(inst, len = long, false), key, left, tempkey);
    keytable[key].signed := keytable[left].signed;
  end {incdec} ;

procedure cmpintptrx(signedbr, unsignedbr: insts {branch on result});

{ Compare scalars or pointers in keytable[left] and keytable[right].
  Keytable[key] is set by setbr to the appropriate branch.
}

  var
    brinst: insts; {the actual branch to use}


  begin {cmpintptrx}
    addressboth;
{ DRB
    if keytable[left].signed = keytable[right].signed then
      len := min(len, max(bytelength(left), bytelength(right)));
    if len = 3 then len := 4;
}

    { Shrinking operands is only safe if the sign is set back to the original
      sign for that length.  The field "signlimit" provides that function.
    }
    {unpkshkboth(len);}

    if signedoprnds then brinst := signedbr
    else brinst := unsignedbr;

    loadreg(left, right);
    loadreg(right, left);
    gen2(buildinst(cmp, len = 4, false), left, right);
    setbr(brinst, nomode_oprnd);
  end {cmpintptrx} ;



procedure cmplitintx(signedbr, unsignedbr: insts {branch instructions});

{ Generate comparison with a literal integer.  If this is zero and left is in
  a general register, we can look backwards for the instruction that set it and
  change it to its "s" form if it has one (DRB: later)

  (DRB: also packingmod from the 68K is interesting because we should be able
   to do similar if a packed field is on a byte, word, or long boundary)
}

  var
    packingmod: shortint;
    i: insts;

  begin
    address(left);
    loadreg(left, 0);
    if (right = 0) and (signedbr in [beq, bne]) then
      if signedbr = beq then
        setbr(cbz, keytable[left].oprnd)
      else
        setbr(cbz, keytable[left].oprnd)
    else
      begin
      settemp(len, immediate_oprnd(right, false));
      gen2(buildinst(cmp, len = long, false), left, tempkey);
      if keytable[left].signed then
        setbr(signedbr, nomode_oprnd)
      else
        setbr(unsignedbr, nomode_oprnd);
      end
  end {cmplitintx} ;



procedure divintx;

{ Generate signed or unsigned divisiion.  This will be followed by
  a getquo or getmod operator or both.  This more or less emulates
  older machines where integer divide instruction divided a two-register
  dividend with a one word divisor,  returning both a quotient and
  remainder.  Aarch64 only divides a single register dividend and
  doesn't return a remainder, but it can be easily generated using
  msub, which we do if we know we will use it later.

  This pseudoinst can only have a refcount of one or two, the latter
  case only if both the quotient and remainder are necessary.  If these
  have been detected as CSEs they, not the divint, will have the
  corresponding refcounts.
}

  var
    r: regindex;

  begin {divintx}
    {unpkshkboth(len);}
    addressboth;
    loadreg(left, right);
    loadreg(right, left);
    if (pseudobuff.op = getrem) or (pseudoinst.refcount = 2) then
      begin
      lock(right);
      lock(left);
      end;
    settargetorreg;
    if signedoprnds then
      gen3(buildinst(sdiv, len = long, false), key, left, right)
    else
      gen3(buildinst(udiv, len = long, false), key, left, right);
    keytable[key].signed := signedoprnds;
    if (pseudobuff.op = getrem) or (pseudoinst.refcount = 2) then
      begin
      if pseudoinst.refcount = 2 then
        begin
        lock(key);
        settemp(len, reg_oprnd(getreg));
        gen4(buildinst(msub, len = long, false), tempkey, key, right, left); 
        unlock(key);
        adjustregcount(key, -pseudoinst.refcount);
        keytable[key].oprnd.mode := tworeg;
        keytable[key].oprnd.reg2 := keytable[tempkey].oprnd.reg;
        adjustregcount(key, pseudoinst.refcount);
        end
      else
        gen4(buildinst(msub, len = long, false), key, key, right, left); 
      unlock(right);
      unlock(left);
      end;
  end {divintx} ;

procedure getquox;

{ Quotient is always left in the reg field generated by divintx,
  so we'll ignore the tworeg case.
}

  begin {getquox}
    address(left);
    setvalue(reg_oprnd(keytable[left].oprnd.reg));
  end {getquox} ;

procedure getremx;

{ Remainder will be in reg field of generated by divintx if the quotient
  is not needed, or reg2 if both quotient and remainder are used.
}

  begin {getremx}
    address(left);
    if keytable[left].oprnd.mode = tworeg then
      setvalue(reg_oprnd(keytable[left].oprnd.reg2))
    else
      setkeyvalue(left);
  end {getremx} ;


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
    keytable[key].oprnd := immediate_oprnd(pseudoinst.oprnds[1], false);
  end {dointx} ;


{
procedure dofptrx;

{ Access a constant function pointer.  The procref is in oprnds[1].
}


  begin {dofptrx}
    keytable[key].access := valueaccess;
    keytable[key].len := pseudoinst.len;
    keytable[key].signed := false;
    keytable[key].oprnd.m := proccall;
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
        reg2 := 0;
        flavor := float;

        if len = long then {double precision}
          if mc68881 then
            begin
            m := immediatelong;
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
            m := labeltarget;
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
  opernds[1].  This is relative to gp for level 1, relative to fp
  for the current level, and relative to sl for level-1.  For other
  levels, generate an indirect from the pointer contained in the 
  target operand and offet relative to that.
}

  var
    reg: regindex; {reg for indirect reference}


  begin
    keytable[key].access := valueaccess;
    with keytable[key], oprnd do
      begin
      if ownflag then
        begin
        write('own data not yet implemented');
        compilerabort(inconsistent);
        end
      else if left = 0 then
        begin
        write('origin data not yet implemented');
        compilerabort(inconsistent);
        end
      else if left = 1 then
        setvalue(index_oprnd(unsigned_offset, gp, 0))
      else if left = level then
        setvalue(index_oprnd(unsigned_offset, fp, 2 * long))
      else if left = level - 1 then setvalue(index_oprnd(unsigned_offset, sl, 2 * long))
      else
        begin
        address(target);
        settemp(long, index_oprnd(unsigned_offset, keytable[target].oprnd.reg, 0));
        settemp(long, reg_oprnd(getreg));
        gensimplemove(tempkey + 1, tempkey);
        setvalue(index_oprnd(unsigned_offset, keytable[tempkey].oprnd.reg, 2 * long));
        tempkey := tempkey + 2;
        end;
      len := long;
      end;
  end {dolevelx} ;

procedure dostructx;

begin {dostructx}
  settemp(long, reg_oprnd(getreg));
  settemp(long, labeltarget_oprnd(rodatalabel, false, left));
  gen2(buildinst(adrp, true, false), tempkey + 1, tempkey);
  keytable[tempkey].oprnd.lowbits := true;
  gen3(buildinst(add, true, false), tempkey + 1, tempkey + 1, tempkey);
  setvalue(index_oprnd(unsigned_offset, keytable[tempkey+1].oprnd.reg, 0));
end {dostructx} ;

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
    context[1].first := nil;
    context[1].last := nil;
    context[1].savedstackoffset := stackoffset;
    context[1].savedstackcounter := stackcounter;
    context[1].keymark := lastkey + 1;
    context[0] := context[1];
    lastfpreg := maxreg - target;
    lastreg := sl - left - 1;
    firstreg := 0;
    firstfpreg := 0;
    lineoffset := pseudoinst.len;

    if (blockref = 0) and (switchcounters[mainbody] > 0) then
      begin
      p := newnode(bssnode);
      p^.bsssize := globalsize;
      end;

    with proctable[blockref] do
      begin
      if intlevelrefs then
        begin
        settemp(long, reg_oprnd(sl));
        settemp(long, index_oprnd(unsigned_offset, sl, 0));
        for i := 1 to levelspread - 1 do
          begin
          gen2(buildinst(ldr, true, false), tempkey + 1, tempkey);
          end;
        end;
      end;
    p := newnode(textnode);
    p := newnode(proclabelnode);
    p^.proclabel := blockref;
    codeproctable[blockref].proclabelnode := p;

    if (blockref = 0) and (switchcounters[mainbody] > 0) then
      begin
      settemp(long, reg_oprnd(gp));
      settemp(long, labeltarget_oprnd(bsslabel, false, 0));
      gen2(buildinst(adrp, true, false), tempkey + 1, tempkey);
      keytable[tempkey].oprnd.lowbits := true;
      gen3(buildinst(add, true, false), tempkey + 1, tempkey + 1, tempkey);
      regused[gp] := true;
      end;
  end {blockcodex} ;

procedure putblock;

{ After all code has been generated for a block, this procedure generates
  cleanup code, calls the various peep-hole optimization
  routines, and finally outputs the macro code.
}

  var
    i: regindex; {induction var for scanning registers}
    blockcost: integer; {max bytes allocated on the stack}
    spoffset: integer; {size of stack save area}
    p, p1: nodeptr;
    savetempkey, fptemp, sptemp, linktemp, spoffsettemp,
    saveregtemp, saveregoffsettemp, spadjusttemp: keyindex;
    regcost, fpregcost: integer; {bytes allocated to save registers on stack}
    regoffset, fpregoffset: array [regindex] of integer; {offset for each reg}
    fpregssaved : array [regindex] of boolean;
    regssaved : array [regindex] of boolean;
    reg: regindex; { temp for dummy register }
    prepost: boolean; {if pre/post index modes can be used}

  begin {putblock}

    { save procedure symbol table index }


    { delete unnecessary register saves
    }

    processregsaves;

    finalizestackoffsets(firstnode, lastnode, maxstackoffset);
    while stackcounter < stackbase do
      begin
      if keytable[stackcounter].refcount > 0 then
        begin
        writeln('stackcounter: ', stackcounter, ' refcount: ', keytable[stackcounter].refcount);
        break;
        end;
      stackcounter := stackcounter + 1;
      end;
    if stackcounter < stackbase then
      compilerabort(undeltemps);

    { eventually peephole optimizations happen now }

    { We only save registers x19 ... and we do this indexing
      negatively off the fp to make sure the index is in range.
     }
    regcost := 0;
    for i := pr + 1 to sp do
      if regused[i] then
        begin
        regcost := regcost + long;
        regoffset[i] := -regcost;
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

    savetempkey := tempkey;
    settemp(long, reg_oprnd(link));
    linktemp := tempkey;
    settemp(long, reg_oprnd(sp));
    sptemp := tempkey;
    settemp(long, reg_oprnd(fp));
    fptemp := tempkey;
    blockcost := blksize + regcost + maxstackoffset + long * 2;
    blockcost := (blockcost + (2 * long - 1)) and - (2 * long);
    settemp(long, immediate_oprnd(blockcost, false));
    spadjusttemp := tempkey;
    spoffset := regcost + maxstackoffset;
    settemp(long, index_oprnd(unsigned_offset, sp, spoffset));
    spoffsettemp := tempkey;
    settemp(long, index_oprnd(signed_offset, fp, 0));
    saveregoffsettemp := tempkey; 
    settemp(long, reg_oprnd(0));
    saveregtemp := tempkey;

    { set up the frame for this block }

    prepost := (spoffset = 0) and (blockcost < 256);
    p1 := codeproctable[blockref].proclabelnode;

    if prepost then
      begin
      keytable[spoffsettemp].oprnd.mode := pre_index;
      keytable[spoffsettemp].oprnd.index := -blockcost;
      end
    else
      begin
      p1 := newinsertafter(p1, instnode);
      gen3p(p1, buildinst(sub, true, false), sptemp, sptemp, spadjusttemp);
      end;

    p1 := newinsertafter(p1, instnode);
    gen3p(p1, buildinst(stp, true, false), linktemp, fptemp, spoffsettemp);

    p1 := newinsertafter(p1, instnode);
    settemp(long, immediate_oprnd(spoffset, false));
    gen3p(p1, buildinst(add, true, false), fptemp, sptemp, tempkey);

    { procedure exit code. Restore callee-saved registers, link and frame pointer
      registers, and shrink stack.
    } 

    {for i := pr + 1 to sl - 1 do}
    for i := pr + 1 to sp do
      if regused[i] then
        begin
        keytable[saveregtemp].oprnd.reg := i;
        keytable[saveregoffsettemp].oprnd.index := regoffset[i];
        p1 := newinsertafter(p1, instnode);
        gen2p(p1, buildinst(str, true, false), saveregtemp, saveregoffsettemp);
        gen2(buildinst(ldr, true, false), saveregtemp, saveregoffsettemp);
        regoffset[i] := -regcost;
        end;

    if prepost then
      begin
      keytable[spoffsettemp].oprnd.mode := post_index;
      keytable[spoffsettemp].oprnd.index := blockcost;
      end;

    gen3(buildinst(ldp, true, false), linktemp, fptemp, spoffsettemp);

    if not prepost then
      gen3(buildinst(add, true, false), sptemp, sptemp, spadjusttemp);

    geninst(nil, buildinst(ret, false, false), 0);

    tempkey := savetempkey;

    { write output code }
    if switcheverplus[outputmacro] then putcode.putcode;

  end { putblock } ;

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
      for i := 0 to lastreg do
        begin
        if (registers[i] <> 0) and (i <> pr) then
          anyfound := true;
        if fpregisters[i] <> 0 then anyfound := true;
        end;

      if anyfound then
        begin
        write('Found registers with non-zero use counts');
        compilerabort(inconsistent); { Display procedure name }

        for i := 0 to lastreg do
          if (registers[i] <> 0) and (i <> pr) then
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
  end {blockentryx} ;

procedure regtargetx;

{ Set up a register target.
}


  begin {regtargetx}
    regparam_target := pseudoinst.key;
    setvalue(reg_oprnd(left));
    regused[left] := true;
    if left > firstreg then
        firstreg := left;
  end {regtargetx} ;

procedure regtempx;

{ Generate a reference to a local variable permanently assigned to a
  general register.

  Currently they are assigned to callee-saved registers, but leaf
  routines could allocate them to scratch registers

}


  begin
    address(left);
    setvalue(reg_oprnd(sl - pseudoinst.oprnds[3]));
    regused[sl - pseudoinst.oprnds[3]] := true;
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

{ Just temporary hacks }

procedure movintptrx;

  begin {movintptrx}
    lock(right);
    addressdst(left);
    unlock(right);
    lock(left);
    address(right);
    unlock(left);
    gensimplemove(right, left);
    savedstkey(left);
    setallfields(left);
  end {movintptrx};

procedure movlitintx;

  var
    p: nodeptr;

  begin
    addressdst(left);
    settemp(len, immediate_oprnd(right, false));
    gensimplemove(tempkey, left); 
    savedstkey(left);
    setallfields(left);
  end;

procedure pshintptrx;

  begin {pshintptrx}
    addressdst(left);
    gensimplemove(left, key);
  end {pshintptrx};

procedure movemultiple;

begin {movemultiple}
  if regmoveok(len) then movintptrx
  else
    begin
    saveactivekeys;
    addressboth;
    firstreg := 3;
    settemp(long, immediate16_oprnd(len, 0));
    settemp(long, reg_oprnd(2));
    gensimplemove(tempkey + 1, tempkey);
    keytable[tempkey].oprnd.reg := 0;
    genmoveaddress(left, tempkey);
    keytable[tempkey].oprnd.reg := 1;
    genmoveaddress(right, tempkey);
    markscratchregs;
    settemp(long, libcall_oprnd(libcmemcpy));
    gen1(buildinst(bl, false, false), tempkey);
    firstreg := 0;
    end;
end; {movemultiple}

procedure pushmultiple;

begin {pushmultiple}
  if regmoveok(len) then pshintptrx
  else
    begin
    saveactivekeys;
    address(left);
    markscratchregs;
    firstreg := 3;
    settemp(long, immediate16_oprnd(len, 0));
    settemp(long, reg_oprnd(2));
    gensimplemove(tempkey + 1, tempkey);
    keytable[tempkey].oprnd.reg := 0;
    genmoveaddress(key, tempkey);
    keytable[tempkey].oprnd.reg := 1;
    genmoveaddress(left, tempkey);
    settemp(long, libcall_oprnd(libcmemcpy));
    gen1(buildinst(bl, false, false), tempkey);
    firstreg := 0;
    end;
end; {pushmultiple}

procedure regparamx;

var o: oprndtype;

begin {regparamx}
  setvalue(reg_oprnd(target));
  regused[target] := true;
  if left <> 0 then
    begin
    address(left);
    with keytable[left].oprnd do
      settemp(long, index_oprnd(unsigned_offset, reg, index + right));
    gensimplemove(key, tempkey);
    setkeyvalue(tempkey);
    end;
end {regparamx};

procedure indxx;

{ Index the address reference in oprnds[1] (left) by the constant offset
  in oprnds[2].  The result ends up in "key".
}


  begin {indxx}
    if right = 0 then
      begin
      setallfields(left);
      dereference(left);
      end
    else
      begin
      address(left);

{ DRB this doesn't really work as we don't check for oprnd alignment,
  the range of the index, etc etc.  Good enough for preliminary testing.
}
      case keytable[left].oprnd.mode of
        reg_offset:
          begin
          settemp(long, reg_oprnd(getreg));
          genmoveaddress(left, tempkey);
          setvalue(index_oprnd(signed_offset, keytable[tempkey].oprnd.reg, right));
          end;
        signed_offset, unsigned_offset:
          begin
          setkeyvalue(left);
          keytable[key].len := long; {unnecessary?}
          keytable[key].oprnd.index := keytable[key].oprnd.index + right;
          end
      end
{
    eventually needs to work with the results of aindx and also register
    params the contain short records.

    else if keytable[left].oprnd.mode = register
      then setkeyvalue(left);
}
    end
  end {indxx} ;

procedure indxindrx;

{ Indirect reference operator
}

  begin {indxindrx}
    address(left);
    loadreg(left, 0);
    setvalue(index_oprnd(unsigned_offset, keytable[left].oprnd.reg, 0));
  end {indxindrx};

procedure aindxx;

{ Generate code for an array access.  Oprnds[1] is the base address
  of the array and oprnds[2] is the index expression.  The index expression
  is adjusted by earlier passes for any offset changes due to the range
  check algorithm.  The result is a pointer to the array element.  The length
  field is the scale factor.
}

  var
    extend: reg_extends;

  begin {aindxx}
    addressboth;
    lock(left);
{    with keytable[right] do
      if not packedaccess and not signed and (len = word) then
        unpack(right, long)
      else unpack(right, word);
}

    if keytable[right].oprnd.mode <> register then
      begin
      settemp(keytable[right].len, reg_oprnd(getreg));
      gensimplemove(right, tempkey);
      changevalue(right, tempkey);
      end;
    unlock(left);
 
    { A register indexed by zero will happen whenever an array is passed
      by reference.
    }
    if (keytable[left].oprnd.mode in [signed_offset, unsigned_offset]) and
      (keytable[left].oprnd.index = 0) then
      settemp(long, reg_oprnd(keytable[left].oprnd.reg))
    else
      begin
      lock(right);
      settemp(long, reg_oprnd(getreg));
      genmoveaddress(left, tempkey);
      settemp(long, index_oprnd(unsigned_offset, keytable[tempkey].oprnd.reg, 0));
      changevalue(left, tempkey);
      unlock(right);
      end;

    case keytable[right].len of
      1: extend := xtb;
      2: extend := xth;
      4: extend := xtw;
      8: extend := xtx;
      otherwise compilerabort(inconsistent);
    end;

    setvalue(reg_offset_oprnd(keytable[tempkey].oprnd.reg, keytable[right].oprnd.reg, bits(len),
                          extend, keytable[right].signed));                         
    keytable[key].len := long; {The front end changed the length because of
                                index scaling}
  end {aindxx} ;

procedure addrx;

  begin {addrx}
    address(left);
    lock(left);
    settargetorreg; 
    unlock(left);
    genmoveaddress(left, key);
  end {addrx};

procedure loopholefnx;

{ Generate code for a loophole function.  This actually generates code
  only in the cases where the argument is not in a register and must
  be widened.
}


  begin
{
    unpackshrink(left, len);
}

    if (len > keytable[left].len) and
       (keytable[left].oprnd.mode <> register) then
      begin
      setvalue(reg_oprnd(getreg));
      gensimplemove(left, key);
      end
    else
      setallfields(left);
    keytable[key].signed := (pseudoinst.oprnds[2] = 0);
  end; {loopholefnx}


procedure makestacktarget;

{ Create a slot on the stack for the current key

  Code checks length of the temp, if it is longer than
  long * 2 then we know it is not being pushed as a
  parameter.  In which case we can reuse an existing slot
  if one is available.

  A true kludge.
  
}

 var
   stackkey: keyindex;

  begin {makestacktarget}
    if paramlist_started then stackkey := newtemp(len)
    else stackkey := stacktemp(len);
    keytable[stackkey].tempflag := true;
    keytable[key].regsaved := true;
    keytable[key].properreg := stackkey;
    setkeyvalue(stackkey);
  end {makestackstarget} ;

procedure stacktargetx;

{ Sets up a key to be used as a target for code generation when the actual
  target is being pushed on the stack.  This makes targeting work with
  temps being generated.

  The sequence is:

        stacktarget     skey
        expression code
        push            skey

  Long value parameter pushes are yanked from the parameter list, so the
  kludge that assumes we're in a parameter list is faulty.  However, a
  parameter list or routine call is coming up soon, so this is harmless.

}


  begin
    if not paramlist_started then
      saveactivekeys; {since no makeroom was called for this parameter list}
    makestacktarget;
    paramlist_started := true;
    dontchangevalue := dontchangevalue + 1;
  end {stacktargetx} ;

procedure makeroomx;

begin {makeroomx}
  saveactivekeys;
end {makeroomx};

procedure callroutinex(s: boolean {signed function value} );

{ Generate a call to a user procedure. There are two possibilies:  if
  target is non-zero, then keytable[left] is a procedure parameter,
  and we call the routine by loading the static link register with the
  passed environment pointer and call the routine.  If target is 0, we
  are calling an explicit routine, the left'th procedure (named Pleft).
  Proctable contains interesting information as to whether or not the
  procedure is external.

  We use the offset1 field of the proccall node to indicate how
  many "movl (A4),A4" instructions to use on entry to the called
  routine.  This causes the generated routine's address to be offset by
  - (offset1 * word).

  We might have to reverse parameters on the stack ...
}

  var
    linkreg: boolean; {true if we build a static link}
    levelhack: integer; {if linkreg then we are going up levelhack levels}
    savetempkey: keyindex; {to restore tempkey when we are done}
    slkey: keyindex; {tempkey holding static link descriptor}
    framekey: keyindex; {tempkey holding address of base of current frame}
    param: integer; {parameter count for creating unix standard list}
    notcopied: 0..1; {1 if last parameter was already the right size}
    i: keyindex; {"from" key for copying parameters}

  const
    reverse_params = false; { true if nonpascal parameters are to be reversed
                              here, false if front-end does it. }

  begin {callroutinex}
    paramlist_started := false; {reset the switch}

    markscratchregs;

    firstreg := 0;
    firstfpreg := 0;

    savetempkey := tempkey;
    {frame pointers in the aarch64 standard calling sequence form a linked
     list.
    }
    settemp(long, reg_oprnd(fp));
    framekey := tempkey;

    settemp(long, reg_oprnd(sl));
    slkey := tempkey;

    levelhack := 0;
    notcopied := 0;

    if pseudoinst.oprnds[3] <= 0 then
      begin

      { direct call }
      linkreg := proctable[left].intlevelrefs and
                 (proctable[left].level > 2);

      if linkreg then
        begin
        regused[sl] := true;
        levelhack := level - proctable[left].level;
        if levelhack < 0 then
          gensimplemove(framekey, slkey);
        end;
      settemp(long, proccall_oprnd(left, max(0, levelhack)));
      gen1(buildinst(bl, false, false), tempkey);
      end
    else
      begin
      { proc/func parameter }
      end;

    if linkreg and ((pseudoinst.oprnds[3] > 0) or (level > 2) and
       (levelhack <> 0)) then
      begin
      settemp(long, index_oprnd(signed_offset, fp, staticlinkoffset));
      gensimplemove(tempkey, slkey);
      end;

    tempkey := savetempkey;

    { for stack parameters }
    dontchangevalue := dontchangevalue - 1;

    { later need to deal with x0/x1 pairs.
    }
     if proctable[left].realfunction then
       setvalue(fpreg_oprnd(0))
    else if (len <= long) then
      setvalue(reg_oprnd(0));

  end {callroutinex} ;


{ Case statement generation.

  The general scheme is to generate a case branch followed directly by
  as many caseelt's as needed.  Tying a caseelt to the code for that case
  is done by the labels generated
}

procedure caseerrx;

  {we have one and only one job to do, and we do it well }

  begin {caseerrx}
    settemp(long, libcall_oprnd(libcasetrap));
    gen1(buildinst(bl, false, false), tempkey);
  end {caseerrx};

procedure casebranchx;

{ Generate code for a case branch.  The pseudoinstruction field have the
  following meanings:

  target:       Case expression

  len:          Default label

  refcount:          0, no error check; 1, default label is error

  oprnds[1]:    Lower bound of cases

  oprnds[2]:    Upper bound of cases

  The code generated is:

     ;move selection expression into Dn
             sub.w   #lower,Dn       ;skew to range 0..(upper-lower)
             cmpi.w  #(upper-lower),Dn       ;range test
     if "otherwise" exists, or no error checking (refcount = 0) then:
             bls.?   <otherwiselimb> ;condition = (C+Z); short/long branch
     else no "otherwise" and error checking on (refcount = 1):
             bhi.s   templabel       ;condition = not(C+Z)
             jsr     caseerror       ;"case selector matches no label"
         templabel:                  ;target of short branch around error
     ;fi
             add.w   Dn,Dn           ;make word address
             move.w  6(PC,Dn.w),Dn   ;fetch 16-bit offset, reusing Dn
             jmp     2(PC,Dn.w)      ;dispatch to selected case limb
     table:  <word offsets of form "caselimb - table">
    t: keyindex; {case expression}
}

  var
    tablelabel: unsigned; { label of the branch table}
    baselabel: unsigned; { label of the first instruction after the case branch }
    p: nodeptr;
    scratchreg: regindex;
    scratch: keyindex; { for arithmetic on case expression }
    addressreg: regindex; { for address calcs }
    addresskey: keyindex; { temp key referencing addressreg }
    default: integer; {default label}
    errordefault: boolean; {true if error label defines error}

begin {casebranchx}

  errordefault := keytable[key].refcount <> 0;
  keytable[key].refcount := 0; {so we can loadreg etc }
  default := len;

  address(target);
  scratchreg := getreg;
  settemp(word, reg_oprnd(scratchreg));
  scratch := tempkey;
  lock(scratch);
  gensimplemove(target, scratch);
  settemp(long, immediate_oprnd(left, false));
  gen3(buildinst(sub, false, false), scratch, scratch, tempkey);
  settemp(long, immediate_oprnd(right - left, false));
  gen2(buildinst(cmp, false, false), scratch, tempkey);
  if errordefault then
    begin
    genbr(bls, newlabel);
    definelabel(default);
    caseerrx;
    definelabel(lastlabel + 1);
    end
  else genbr(bhi, default);;

  tablelabel := newlabel;
  addressreg := getreg;
  settemp(long, reg_oprnd(addressreg));
  addresskey := tempkey;
  settemp(long, labeltarget_oprnd(tablelabel, false, 0));
  gen2(buildinst(adrp, true, false), addresskey, tempkey);
  keytable[tempkey].oprnd.lowbits := true;
  gen3(buildinst(add, true, false), addresskey, addresskey, tempkey);

  baselabel := newlabel; {must be last temp label for caseeltx}
  settemp(word, reg_offset_oprnd(addressreg, scratchreg, 2, xtw, false));
  gen2(buildinst(ldr, false, false), scratch,tempkey);
  settemp(long, labeltarget_oprnd(baselabel, false, 0));
  gen2(buildinst(adr, true, false), addresskey, tempkey);
  settemp(long, extend_reg_oprnd(scratchreg, xtw, 2, true));
  gen3(buildinst(add, true, false), scratch, addresskey, tempkey);
  gen1(buildinst(br, true, false), scratch);
  definelabel(baselabel);
  unlock(scratch);

  { now initiate the case element table }
  p := newnode(rodatanode);
  p^.labelno := tablelabel;

end {casebranchx} ;

procedure caseeltx;

{ Generate oprnds[2] references to label oprnds[1].
  These will be placed in the constant psect.
}

  var
    i: integer; {induction var}
    p: nodeptr; {for switching back to text}


  begin {caseeltx}
    for i := 1 to pseudoinst.oprnds[2] do
      genlabeldelta(lastlabel + 1, pseudoinst.oprnds[1]);
    if pseudobuff.op <> caseelt then
      p := newnode(textnode);
  end; {caseeltx}

procedure jumpx(lab: integer {label to jump to});

{ Generate an unconditional branch to "lab".  The only non-obvious thing here
  is linking the jump into the list of branch links

  Note that all branches to a particular label are linked through the
  brnodelink field of the label node.
}

  var
    p: brlinkptr; {for searching list of branch links}
    found: boolean; {for stopping search}


  begin
    genbr(b, pseudoinst.oprnds[1]);

    { DRB:stuff for later tail merging which we might not even
      want to do for arm64 
      p := firstbr;
      found := false;
      while not found and (p <> nil) do
        if p^.l = lab then found := true
        else p := p^.nextbr;
      if not found and
          not switcheverplus[debugging] and (tailmerging in genset) then
        begin
        new(p);
        p^.l := lab;
        p^.nextbr := firstbr;
        p^.n := 0;
        firstbr := p;
        end;
      if p <> nil then
        begin
        lastptr^.brnodelink := p^.n;
        p^.n := lastnode - 1;
        end;
      end};
  end {jumpx} ;

procedure jumpcond(inv: boolean {invert the sense of the comparision});

{ Used to generate a jump true or jump false on a condition.  If the key is
  not already a condition, it is forced to a "bne", as it is a boolean
  variable.
}

  var
    labeltarget: keyindex;
    b: insts;

  begin
    address(right);
    settemp(long, labeltarget_oprnd(pseudoinst.oprnds[1], false, 0));
    labeltarget := tempkey;
    if keytable[right].access = branchaccess then
      b := keytable[right].brinst
    else
      begin
      b := cbz;
      loadreg(right, 0);
      end;
    if inv then b := invert[b];
    if (b = cbz) or (b = cbnz) then
      gen2(buildinst(b, keytable[right].len = long, false), right, labeltarget)
    else gen1(buildinst(b, false, false), labeltarget);
    context[contextsp].lastbranch := lastnode;
  end {jumpcond} ;

{ These are awful in that a top level compare can be collapsed into a
  single csel ...
}

procedure createfalsex;

{ Create false constant prior to conversion of comparison to value.
}


  begin {createfalsex}
    settargetorreg;
    settemp(len, immediate_oprnd(0, false));
    gensimplemove(tempkey, key);
  end {createfalsex} ;


procedure createtruex;

{ Create the value 'true'.
}


  begin {createtruex}
    address(left);
    setallfields(left);
    settemp(len, immediate_oprnd(1, false));
    gensimplemove(tempkey, key);
  end {createtruex} ;



procedure codeone;

{ Routine called by directly by travrs to generate code for one
  pseudoop for big compiler version.
}

  begin {codeone}
    key := pseudoinst.key;
    len := pseudoinst.len;
    left := pseudoinst.oprnds[1];
    right := pseudoinst.oprnds[2];
    target := pseudoinst.oprnds[3];
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
      copyaccess: copyaccessx;
      clearlabel: clearlabelx;
      savelabel: savelabelx;
      restorelabel: restorelabelx;
      joinlabel: joinlabelx;
      pseudolabel: pseudolabelx;
{
      pascallabel: pascallabelx;
      pascalgoto: pascalgotox;
}
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
{
      forupchk: forcheckx(true);
      fordnchk: forcheckx(false);
      forerrchk: forerrchkx;
}
      casebranch: casebranchx;
      caseelt: caseeltx;
      caseerr: caseerrx;
      dostruct: dostructx;
{
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
      regparam: regparamx;
      regtarget: regtargetx;
      regtemp: regtempx;
{
      ptrtemp: ptrtempx;
      realregparam: realregparamx;
      realtemp: realtempx;
}
      indxindr: indxindrx;
      indx: indxx;
      aindx: aindxx;
{
      pindx: pindxx;
      paindx: paindxx;
}
      createfalse: createfalsex;
      createtrue: createtruex;
{
      createtemp: createtempx;
      jointemp: jointempx;
}
      addr: addrx;
{
      setinsert: setinsertx;
      inset: insetx;
}
      movint, returnint, movptr, returnptr, returnfptr: movintptrx;
      movlitint, movlitptr: movlitintx;
{
      movreal, returnreal: movrealx;
      movlitreal: movlitrealx;
}
      movstruct, returnstruct: movemultiple;
      movset: movemultiple;
{
      movstr: movstrx;
      movcstruct: movcstructx;
      addstr: addstrx;
}
      addint: integerarithmetic(add);
      subint, subptr: integerarithmetic(sub);
      mulint: integerarithmetic(mul);
      stddivint: divintx;
      divint: divintx;
      getquo: getquox;
      getrem: getremx;
      shiftlint: shiftintx(false);
      shiftrint: shiftintx(true);
      negint: unaryint(neg);
      incint: incdec(add);
      decint: incdec(sub);
{
      orint: integerarithmetic(orinst);
      andint: integerarithmetic(andinst);
      xorint: xorintx;
      addptr: addptrx;
      compbool: incdec(add, true);
}
      compint: compintx;
{
      addreal: realarithmeticx(true, libfadd, libdadd, fadd);
      subreal: realarithmeticx(false, libfsub, libdsub, fsub);
      mulreal: realarithmeticx(true, libfmult, libdmult, fmul);
      divreal: realarithmeticx(false, libfdiv, libddiv, fdiv);
      negreal: negrealx;
      addset: setarithmetic(orinst, false);
      subset: setarithmetic(andinst, true);
      mulset: setarithmetic(andinst, false);
      divset: setarithmetic(eor, false);
}
      stacktarget: stacktargetx;
      makeroom: makeroomx;
      callroutine: callroutinex(true);
      unscallroutine: callroutinex(false);
{
      sysfnstring: sysfnstringx;
      sysfnint: sysfnintx;
      sysfnreal: sysfnrealx;
      castreal: castrealx;
      castrealint: castrealintx;
      castint, castptr: castintx;
}
      loopholefn, castptrint, castintptr, castfptrint, castintfptr:
	loopholefnx;
{
      sysroutine: sysroutinex;
      chrstr: chrstrx;
      arraystr: arraystrx;
      flt: fltx;
}
      pshint, pshptr: pshintptrx;
{
      pshfptr: pshfptrx;
      pshlitint: pshlitintx;
      pshlitptr, pshlitfptr: pshlitptrx;
      pshlitreal: pshlitrealx;
      pshreal: pshx;
      pshaddr: pshaddrx;
      pshstraddr: pshstraddrx;
      pshproc: pshprocx;
      pshstr: pshstrx;
}
      pshstruct, pshset: pushmultiple;
{
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
}
      jump: jumpx(pseudoinst.oprnds[1]);
      jumpf: jumpcond(true);
      jumpt: jumpcond(false);
{

      eqreal: cmprealx(beq, libdeql, fbngl);
      neqreal: cmprealx(bne, libdeql, fbgl);
      lssreal: cmprealx(blt, libdlss, fblt);
      leqreal: cmprealx(ble, libdlss, fble);
      geqreal: cmprealx(bge, libdgtr, fbge);
      gtrreal: cmprealx(bgt, libdgtr, fbgt);
}

      eqint, eqptr, eqfptr: cmpintptrx(beq, beq);
      neqint, neqptr: cmpintptrx(bne, bne);
      leqint, leqptr: cmpintptrx(ble, bls);
      geqint, geqptr: cmpintptrx(bge, bhs);
      lssint, lssptr: cmpintptrx(blt, blo);
      gtrint, gtrptr: cmpintptrx(bgt, bhi);
{
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
}
      eqlitint, eqlitptr: cmplitintx(beq, beq);
      neqlitint, neqlitptr: cmplitintx(bne, bne);
      leqlitint: cmplitintx(ble, bls);
      geqlitint: cmplitintx(bge, bhs);
      lsslitint: cmplitintx(blt, blo);
      gtrlitint: cmplitintx(bgt, bhi);
{

      eqset: cmpstructx(beq);
      neqset: cmpstructx(bne);
      geqset: cmpsetinclusion(left, right);
      leqset: cmpsetinclusion(right, left);

      postint: postintptrx(false);
      postptr: postintptrx(true);
      postreal: postrealx;

      ptrchk: ptrchkx;
      definelazy: definelazyx;
}
      restoreloop: restoreloopx;
      { C only }
      startreflex: dontchangevalue := dontchangevalue + 1;
      endreflex: dontchangevalue := dontchangevalue - 1;
{
      cvtrd: cvtrdx;
      cvtdr: cvtdrx; { SNGL function }
      dummyarg: dummyargx;
      dummyarg2: dummyarg2x;
      openarray: openarrayx;
}
      saveactkeys: saveactivekeys;
      otherwise
        begin
        {writeln('Not yet implemented: ', ord(pseudoinst.op): 1);
        compilerabort(inconsistent);}
        end;
      end;

    if key > lastkey then lastkey := key;

    with keytable[key] do
      if refcount + copycount > 1 then savekey(key);

{
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
    if switcheverplus[test] then
      begin
      dumppseudo(macfile);
      if keytable[key].first <> nil then
        write_nodes(keytable[key].first, keytable[key].last);
{
      dumpstack;
}
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

    bsslabel := newlabel;
    rodatalabel := newlabel;

    invert[beq] := bne;     invert[bne] := beq;     invert[blt] := bge;
    invert[bgt] := ble;     invert[bge] := blt;     invert[ble] := bgt;
    invert[blo] := bhs;     invert[bhi] := bls;     invert[bls] := bhi;
    invert[bhs] := blo;     invert[bvs] := bvc;     invert[bvc] := bvs;
    invert[b] := nop;       invert[cbz] := cbnz;    invert[cbnz] := cbz;

    { Front end doesn't do this for deeply historical reasons but in Linux
      the main program's just an external procedure.
    }
    proctable[0].externallinkage := true;

    labelnextnode := false;
    labeltable[0].nodelink := nil;

    {Now initialize file variables}

    curstringblock := 0;
    nextstringfile := 0;
    level := 0;
    fileoffset := 0;
    formatcount := 0;
    filenamed := false;

    keytable[0].validtemp := false;
    keytable[0].oprnd := nomode_oprnd;

    lastnode := nil;
    firstnode := nil;

    testing := switcheverplus[test] and switcheverplus[outputmacro];

    if switcheverplus[outputmacro] then initmac;

    stackcounter := keysize - 1; {fiddle consistency check}
    stackbase := keysize - 1;

    if peeping then for i := 0 to maxpeephole do peep[i] := 0;

  end {initcode} ;

procedure exitcode;

  var
    p, p1: nodeptr;

  begin {exitcode}
    p := firstnode;
    while p <> nil do
    begin
      p1 := p^.nextnode;
      dispose(p);
      p := p1;
    end
  end {exitcode};
end.
