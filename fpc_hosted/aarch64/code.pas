unit code;

interface

uses config, hdr, t_c, hdrc, utils, putcode;

procedure code;

procedure codeone;

procedure initcode;

procedure exitcode;

implementation

var regparamindex: integer;

procedure gensimplemove(var after: nodeptr; src: keyindex; dst: keyindex); forward;

procedure loadreg(var k: keyindex; other: keyindex); forward;

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
          condf: write(f, 'condf': 15);
          condt: write(f, 'condt': 15);
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

{ Weird bitmask patters for aarch64 are handled by the following
  two functions shamelessly lifted from Free Pascal.  
}

function first_set_bit(i: cardinal): integer;

{ Return the index of the first set bit in i, counting from bit 0, which is
  the rightmost bit on this machine.

  Weird return value of 255 is for compatibility with Free Pascal's BsfWord.
}

  var
    count: integer;
begin
  count := 0;
  while (i <> 0) and not odd(i) do
    begin
    count := count + 1;
    i := i div 2;
    end;
  if i = 0 then first_set_bit := 255
  else first_set_bit := count;  
end;

function is_bitmask(d: cardinal; size: integer): boolean;

{ Returns true if d can be represented by an aarch64's innovative 2-bit 
  immr:imms bitmask implementation.  We needn't convert the constant to
  that format because the assembler will do it for us, and Free Pascal,
  like us, only emits assembly output.

  This will only work for 32-bit integers and 32-bit masks at the moment.
}

  var
     pattern, checkpattern: cardinal;
     patternlen, maxbits, replicatedlen: integer;
     rightmostone, rightmostzero, checkbit, secondrightmostbit: longint;
  begin
    is_bitmask := false;
    maxbits := 32;

    { patterns with all bits 0 or 1 cannot be represented this way, which
      makes sense because the result of an "and" or "or" operation with
      those masks is known at compile time.
    }

    if (d = 0) or (d = $FFFFFFFF) then
      exit
    else
    begin

    { "The Logical (immediate) instructions accept a bitmask immediate value
      that is a 32-bit pattern or a 64-bit pattern viewed as a vector of
      identical elements of size e = 2, 4, 8, 16, 32 or, 64 bits. Each
      element contains the same sub-pattern, that is a single run of
      1 to (e - 1) set bits from bit 0 followed by zero bits, then
      rotated by 0 to (e - 1) bits." (ARMv8 ARM)

      Rather than generating all possible patterns and checking whether they
      match our constant, we check whether the lowest 2/4/8/... bits are
      a valid pattern, and if so whether the constant consists of a
      replication of this pattern. Such a valid pattern has the form of
      either (regexp notation)
        * 1+0+1*
        * 0+1+0* }

    patternlen:=2;
    while patternlen<=maxbits do
      begin
        { try lowest <patternlen> bits of d as pattern }
        if patternlen<>64 then
          pattern:=qword(d) and ((qword(1) shl patternlen)-1)
        else
          pattern:=qword(d);
        { valid pattern? If it contains too many 1<->0 transitions, larger
          parts of d cannot be a valid pattern either }
        rightmostone:=first_set_bit(pattern);
        rightmostzero:=first_set_bit(not(pattern));
        { pattern all ones or zeroes -> not a valid pattern (but larger ones
          can still be valid, since we have too few transitions) }
        if (rightmostone<patternlen) and
           (rightmostzero<patternlen) then
          begin
            if rightmostone>rightmostzero then
              begin
                { we have .*1*0* -> check next zero position by shifting
                  out the existing zeroes (shr rightmostone), inverting and
                  then again looking for the rightmost one position }
                checkpattern:=not(pattern);
                checkbit:=rightmostone;
              end
            else
              begin
                { same as above, but for .*0*1* }
                checkpattern:=pattern;
                checkbit:=rightmostzero;
              end;
            secondrightmostbit:=first_set_bit(checkpattern shr checkbit)+checkbit;
            { if this position is >= patternlen -> ok (1 transition),
              otherwise we now have 2 transitions and have to check for a
              third (if there is one, abort)

              first_set_bit returns 255 if no 1 bit is found, so in that case it's
              also ok
              }
            if secondrightmostbit<patternlen then
              begin
                secondrightmostbit:=first_set_bit(not(checkpattern) shr secondrightmostbit)+secondrightmostbit;
                if secondrightmostbit<patternlen then
                  exit;
              end;
            { ok, this is a valid pattern, now does d consist of a
              repetition of this pattern? }
            replicatedlen:=patternlen;
            checkpattern:=pattern;
            while replicatedlen<maxbits do
              begin
                { douplicate current pattern }
                checkpattern:=checkpattern or (checkpattern shl replicatedlen);
                replicatedlen:=replicatedlen*2;
              end;
            if qword(d)=checkpattern then
              begin
                { yes! }
                is_bitmask:=true;
                exit;
              end;
          end;
        patternlen:=patternlen*2;
      end;
  end;
end;

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

{we handle quite a large number of machine operands and abstract
 operands}

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

function imm16_oprnd(imm16_value: bits16; imm16_shift: unsigned): oprndtype;

  var
    o:oprndtype;

  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := imm16;
    o.imm16_value := imm16_value;
    o.imm16_shift := imm16_shift;
    imm16_oprnd := o;
  end;

function imm12_oprnd(imm12_value: bits12; imm12_shift: boolean): oprndtype;

  var
    o:oprndtype;

  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := imm12;
    o.imm12_value := imm12_value;
    o.imm12_shift := imm12_shift;
    imm12_oprnd := o;
  end;

function immbitmask_oprnd(bitmask_value: unsigned): oprndtype;

  var
    o:oprndtype;

  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := immbitmask;
    o.bitmask_value := bitmask_value;
    immbitmask_oprnd := o;
  end;


function shift_reg_oprnd(reg: regindex; reg_shift: reg_shifts;
                         shift_amount: bits6): oprndtype;

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

function extend_reg_oprnd(reg: regindex; reg_extend: reg_extends; extend_shift: bits3;
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

function reg_offset_oprnd(reg, reg2: regindex; shift: bits2;
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

function label_offset_oprnd(reg: regindex; labelno: integer; labeloffset: integer): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := reg;
    o.reg2 := noreg;
    o.mode := label_offset;
    o.labelno := labelno;
    o.lowbits := true;
    o.labeloffset := labeloffset;
    label_offset_oprnd := o;
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

function intconst_oprnd(i: integer): oprndtype;

  var
    o:oprndtype;
  begin
    o.reg := noreg;
    o.reg2 := noreg;
    o.mode := intconst;
    o.int_value := i;
    intconst_oprnd := o;
  end;

{that's all the operands that are available}

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
      regenoprnd := nomode_oprnd;
      end;
  end {setkeyentry};

function settemp(l: unsigned; o: oprndtype): keyindex;

{ Set up a temporary key entry with the given operand.  This has
  nothing to do with runtime temp administration.  It strictly sets up a key
  entry.  Negative key values are used for these temp entries, and they are
  basically administered as a stack using "tempkey" as the stack pointer.
}


  begin {settemp}
    if tempkey = lowesttemp then compilerabort(interntemp);
    tempkey := tempkey - 1;
    setkeyentry(tempkey, l, o);
    settemp := tempkey;
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
    sf: boolean;

  begin {ldrinst}
    case l  of
      byte: if s then inst := ldrsb else inst := ldrb;
      half: if s then inst := ldrsh else inst := ldrh;
      word: if s then inst := ldrsw else inst := ldr;
      long: inst := ldr;
      otherwise
        begin
        write('operand length ', l, ' given to ldrinst');
        compilerabort(inconsistent)
        end
    end;
    ldrinst := buildinst(inst, (l > word) or (inst = ldrsw), false);
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

function newnode(after: nodeptr; kind: nodekinds): nodeptr;

{ Allocate a new node after the given nodeptr and link it to list of nodes.
}

  var
    p: nodeptr;

  begin {newnode}
    new(p);
    p^.kind := kind;
    if after = lastnode then
      begin
        if lastnode = nil then
          firstnode := p
        else
          lastnode^.nextnode := p;
        p^.nextnode := nil;
        p^.prevnode := lastnode;

        { strategy here is that the nodes from first to last are
          those that created the current key value once we move to the next key,
          while the prevnode field allows us to more easily delete nodes
          attached to a key.
        }
    
        with keytable[key] do
          begin
          last := p;
          if first = nil then
            first := p;
          end;
      end
    else
      begin
      p^.nextnode := after^.nextnode;
      after^.nextnode := p;
      p^.prevnode := after;
      end;

    if after = lastnode then
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

{ newinsertfter not used but kept around just in case }

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

{ Generates the given operand in lastptr.

  Does nothing essentially so will probably disappear ...
}

  begin {genoprnd}

    with p^ do
      oprnds[i] := o;
  end {genoprnd} ;

{ Generate instructions.  Comes in two forms, one takes a pointer to the node the
  new instruction should follow, the other takes a pointer to the node to fill.  The
  latter simplifies code related to loop register reloads and possibly elsewhere.

  Might be able to simplify this later.
}

Procedure gen0p(p: nodeptr;
                i: insttype);

{ Generate a zero operand instruction
}

  begin {gen0p}
    geninst(p, i, 0);
  end {gen0p} ;

procedure gen0(var after: nodeptr;
               i: insttype);

{ Generate a zero operand instruction
}


  begin {gen0}
    after := newnode(after, instnode);
    gen0p(after, i);
  end {gen0} ;


Procedure gen1p(p: nodeptr;
                i: insttype;
                o1: keyindex);

{ Generate a single operand instruction
}

  begin {gen1p}
    geninst(p, i, 1);
    p^.oprnds[1] := keytable[o1].oprnd;
  end {gen1p} ;

procedure gen1(var after: nodeptr;
               i: insttype;
               o1: keyindex);

{ Generate a single operand instruction
}


  begin {gen1}
    after := newnode(after, instnode);
    gen1p(after, i, o1);
  end {gen1} ;


procedure gen2p(p: nodeptr;
                i: insttype;
                o1, o2: keyindex);

{ Generate a double operand instruction.
}


  begin {gen2p}
    geninst(p, i, 2);
    p^.oprnds[1] := keytable[o1].oprnd;
    p^.oprnds[2] := keytable[o2].oprnd;
  end {gen2p} ;


procedure gen2(var after: nodeptr;
               i: insttype;
               o1, o2: keyindex);

{ Generate a double operand instruction.
}


  begin {gen2}
    after := newnode(after, instnode);
    gen2p(after, i, o1, o2);
  end {gen2} ;

procedure gen3p(p: nodeptr;
                i: insttype;
                o1, o2, o3: keyindex);

{ Generate a triple operand instruction, using keytable[src/dst] as
  the two operands.
}


  begin {gen3p}
    geninst(p, i, 3);
    p^.oprnds[1] := keytable[o1].oprnd;
    p^.oprnds[2] := keytable[o2].oprnd;
    p^.oprnds[3] := keytable[o3].oprnd;
  end {gen3p} ;



procedure gen3(var after: nodeptr;
               i: insttype;
               o1, o2, o3: keyindex);

{ Generate a triple operand instruction.
}

  begin {gen3}
    after := newnode(after, instnode);
    gen3p(after, i, o1, o2, o3);
  end {gen3} ;


procedure gen4p(p: nodeptr;
                i: insttype;
                o1, o2, o3, o4: keyindex);

{ Generate a quadruple operand instruction.
}


  begin {gen4p}
    geninst(p, i, 4);
    p^.oprnds[1] := keytable[o1].oprnd;
    p^.oprnds[2] := keytable[o2].oprnd;
    p^.oprnds[3] := keytable[o3].oprnd;
    p^.oprnds[4] := keytable[o4].oprnd;
  end {gen4p} ;


procedure gen4(var after: nodeptr; i: insttype;
               o1, o2, o3, o4: keyindex);

{ Generate a quadruple operand instruction.
}


  begin {gen4}
    after := newnode(after, instnode);
    gen4p(after, i, o1, o2, o3, o4);
  end {gen4} ;

procedure genbr(inst: insts; labelno: integer);

  begin {genbr}
    gen1(lastnode, buildinst(inst, false, false),
         settemp(long, labeltarget_oprnd(labelno, false, 0)));
    context[contextsp].lastbranch := lastnode;
  end {genbr};

procedure gencomment(var after: nodeptr; comment: string);

  var
    p: nodeptr;

  begin {gencomment}
    p := newnode(after, commentnode);
    p^.comment := comment;
  end; {gencomment}

procedure genlabeldelta(var after: nodeptr; tablebase, targetlabel: integer);

  var
    p: nodeptr;

  begin {genlabeldelta}
    p := newnode(after, labeldeltanode);
    p^.tablebase := tablebase;
    p^.targetlabel := targetlabel;
  end; {genlabeldelta}

procedure genlongint(var after: nodeptr; value: unsigned; dst: regindex);

  var savedtempkey, regkey: keyindex;
    movinst: insts;

  begin
    savedtempkey := tempkey;
    regkey := settemp(long, reg_oprnd(dst));
    if is_bitmask(value, 32) then
      gen2(after, buildinst(mov, true, false), regkey,
           settemp(len, immbitmask_oprnd(value)))
    else
      begin
      movinst := movz;
      if (value and $FFFF) <> 0 then
        begin
        gen2(after, buildinst(movz, true, false),
             regkey,
             settemp(long, imm16_oprnd(value and $FFFF, 0)));
        movinst := movk;
        end;
      { mask it because eventually we'll handle 64 bit constants }
      if (value div $10000) and $FFFF <> 0 then
        gen2(after, buildinst(movinst, true, false),
             regkey,
             settemp(long, imm16_oprnd((value div $10000) and $FFFF, 16)));
      end;
    tempkey := savedtempkey;
  end;

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
      p := newnode(lastnode, labelnode);
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
         pre_index, post_index, abstract_offset, signed_offset, unsigned_offset:
           same := (index = oprnd.index);
         reg_offset: same := (shift = oprnd.shift) and
                             (extend = oprnd.extend) and
                             (signed = oprnd.signed);
         otherwise same := true;
         end;
      end;
    equivaddr := same;
  end {equivaddr} ;


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
          abstract_offset, signed_offset, unsigned_offset, label_offset:
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
        regenoprnd := nomode_oprnd;
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
      instmark := lastnode;
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
      keytable[key].regenoprnd := regenoprnd;
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
        p := p^.prevnode;
      until (p = nil) or
            (p = keytable[k].instmark);
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
  k := stackcounter;
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
        regenoprnd := nomode_oprnd;
        validtemp := true;
        regvalid := true;
        reg2valid := true;
        regsaved := false;
        reg2saved := false;
        packedaccess := false;
        refcount := 0;
        first := nil;
        last := nil;
        oprnd := index_oprnd(abstract_offset, sp, -stackoffset);
        end;
      end;
    newtemp := stackcounter;
  end {newtemp} ;


function newparamtemp(size: addressrange {size of temp to allocate} ): keyindex;

{ Create a new stack parameter temp. Temps are allocated from the top of the keys,
  while expressions are allocated from the bottom.

}

  begin {newparamtemp}
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
        regenoprnd := nomode_oprnd;
        validtemp := true;
        regvalid := true;
        reg2valid := true;
        regsaved := false;
        reg2saved := false;
        packedaccess := false;
        refcount := 0;
        first := nil;
        last := nil;
        oprnd := index_oprnd(abstract_offset, sp, paramoffset);
        end;
      end;
    paramoffset := paramoffset + size;
    newparamtemp := stackcounter;
  end {newparamtemp} ;

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
  but that turned out to be not necessary and somewhat wasteful of memory.
  However we might spill to caller-saved registers in the future and this
  code should handle that case with the addition of allocation code.
}

procedure addtempsave(k: keyindex; first, last: nodeptr);

  var
    p: tempsaveptr;

  begin {addtempsave}
    if k < stackcounter then
      begin
      writeln('attempting to add a stack save to a non-stack entry');
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
            if (r = reg) {and regvalid} then
              begin
              if regenoprnd.mode <> nomode then
                begin
                found := true;
                saved := true;
                savekey := i
                end
              else if keytable[properreg].validtemp and
                ((properreg >= stackcounter) or (properreg <= lastkey)) then
                begin
                found := true;
                savekey := properreg;
                saved := regsaved;
                end
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
      gen2(lastnode, buildinst(str, true, false),
               settemp(long, reg_oprnd(r)),
               savekey);
      addtempsave(savekey, lastnode, lastnode);
{
if switcheverplus[test] and (keytable[key].first <> nil) then
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

{procedure calls walk on all of the caller-saved general registers}

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
                ord((r > pr) and not regused[r]) * 2 + ord(r < ip0) +
                maxint * ord((r >= ip0) and (r <= pr));
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

{various keytable manipulation routines}

procedure savedstkey(k: keyindex);

  var
    p: nodeptr;
  begin
    with keytable[k],oprnd do
      if (mode = register) and regvalid and not regsaved and (reg >= firstreg) and
         (reg <= lastreg) and keytable[properreg].validtemp then
        begin
        gen2(lastnode, buildinst(str, true, false), k, properreg);
        addtempsave(properreg, lastnode, lastnode);
        regsaved := true;
        end;
  end;

procedure savekey(k: keyindex {operand to save} );

{ Save all volatile registers required by given key.
  unless we can regenerate it from the saved copy of the
  original operand.  We do this because save/restore to
  memory is more expensive than regenerating the operand
  with instructions like adp, add to registers like the
  frame pointer, mov/movk sequences etc.
}


  begin
    if k > 0 then
      with keytable[k] do
        if (access = valueaccess) and (regenoprnd.mode = nomode) then
          begin
          bumptempcount(k, -refcount);
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
                { don't reuse the temp slot we just allocated!}
                bumptempcount(k, refcount);
                properreg2 := savereg(reg2);
                bumptempcount(k, -refcount);
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
          if (refcount > 0) and not (regsaved and reg2saved)
          then savekey(i);
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


  begin {lock}
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

procedure lockboth;

  begin {lockboth}
    lock(left);
    lock(right);
  end {lockboth};

procedure unlockboth;

  begin {unlockboth}
    unlock(left);
    unlock(right);
  end {unlockboth};

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
  reg2valid. Makeaddressable reloads or regenerates the missing register(s)
  and clears the marked reg/reg2 status.
}

  var
    restorereg, restorereg2: boolean;
    i,t: keyindex;
    found: boolean;
    recallkey: keyindex;

  procedure recall_reg(regx: regindex; properregx: keyindex);

    { Unkill a general reg if possible.
    }
    begin
      with loopstack[loopsp] do
        if (thecontext = contextsp) and (loopoverflow = 0) and
           (thecontext <> contextdepth - 1) and
           equivaddr(regstate[regx].stackcopy, properregx) then
          begin
          regstate[regx].killed := false;
          context[contextsp].bump[regx] := true;
          end;
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
        if (mode = register) and
           (registers[keytable[regparam_target].oprnd.reg] = 1) then
          reg := keytable[regparam_target].oprnd.reg
        else
          reg := getreg;
        recall_reg(reg, properreg);
        if (mode = register) and (regenoprnd.mode <> nomode) then
          begin
          gen2(lastnode, buildinst(adrp, true, false),
               settemp(long, reg_oprnd(reg)),
               settemp(long, regenoprnd));
          gen2(lastnode, ldrinst(len, signed),
               settemp(len, reg_oprnd(reg)),
               settemp(long, label_offset_oprnd(reg, regenoprnd.labelno, regenoprnd.labeloffset)))
          end
        else if mode = label_offset then
          gen2(lastnode, buildinst(adrp, true, false),
               settemp(long, reg_oprnd(reg)),
               settemp(long, regenoprnd))
        else
          gen2(lastnode, buildinst(ldr, true, false),
               settemp(long, reg_oprnd(reg)),
               properreg);
        end;
      if restorereg2 then
        begin
        registers[reg] := registers[reg] + maxrefcount;
        oprnd.reg2 := getreg;
        registers[reg] := registers[reg] - maxrefcount;
        recall_reg(oprnd.reg2, properreg2);
        gen2(lastnode, buildinst(ldr, true, false),
             settemp(long, reg_oprnd(reg2)),
             properreg2);
        end;
      regvalid := true;
      reg2valid := true;
      joinreg := false;
      joinreg2 := false;
{
      regsaved := regsaved and keytable[properreg].validtemp;
      reg2saved := reg2saved and keytable[properreg2].validtemp;
}
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

{ If the destination is a volatile register, use it again but
  mark it unsaved so that future uses as a value outside the
  current context have a stack value to fall back on.

  Otherwise, do a regular makeaddressable on it.
}

  var
    i: keyindex;

  begin
    with keytable[k], oprnd do
      if (mode = register) then
        begin
        regvalid := true;
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
    }

    stackbase := keysize;
    stackcounter := stackbase;
    stackoffset := 0;
    maxstackoffset := 0;
    keytable[stackcounter].oprnd := index_oprnd(abstract_offset, sp, 0);

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
        regenoprnd := nomode_oprnd;
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

{ The pattern for the handle oprnd procedures when used to modify 
  previously generated code that needs modification, which is currently
  used to fix up stack offets once the maximum size of the stack is
  known looks something like (ldp/stp case):

  (looping from a block's first node to last node)
  after := firstnode^.prevnode;
  oprnds[3].index := oprnds[3].index + amount;
  handle_offset9_oprnd(after, true, ip0, oprnds[3]);
  firstnode := after^.nextnode;
  Thise pattern will work in post-generation peephole optimization and
  is currently used to fix up stack offsets at the end of a procedure/function
  block, modifying the previously generated negative stack values.

  The pattern for simply generated correct constants and offsets while
  generating code for pseudoinstructions looks like:

  gen3(lastnode, buildinst(ldp, true, false), savereg2temp, saveregtemp,
       settemp(long, index_oprnd(signed_offset, sp, -32)));
  handle_offset9_oprnd(lastnode^.prevnode, true, ip0, lastnode^.oprnds[3]);
}


procedure handle_offset9_oprnd(var after: nodeptr; ldpstp: boolean; tempreg: regindex;
                               var o: oprndtype);

{ Handle 9-bit offsets  It assumes that the operand passed in is set up
  for the case where the offset already fits.

  Should always be a negative offset unless ldpstp is true, but it will take
  awhile to fix everything up ...

  Further argument for an abstract index operand ala intconst that always has
  to be fixed up at some point, immdiately or after stack offset finalization.

}

var offset, minoffset, maxoffset, mask: integer;
  savetempkey, tempregkey, originalregkey, imm12key: keyindex;

begin {handle_offset9_oprnd}

  if ldpstp then
    begin
    minoffset := -512;
    maxoffset := 504;
    mask := $1FF;
    end
  else
    begin
    minoffset := -256;
    maxoffset := 255;
    mask := $FF;
    end;

  o.mode := signed_offset;
  offset := o.index;

  { see if we have to do anything kinky here }
  savetempkey := tempkey;
  tempregkey := settemp(long, reg_oprnd(tempreg));
  originalregkey := settemp(long, reg_oprnd(o.reg));
  imm12key := settemp(long, imm12_oprnd(0, false));
  if offset > maxoffset then
    if offset - maxoffset <= 4095 then
      begin
      keytable[imm12key].oprnd.imm12_value := offset - maxoffset;
      gen3(after, buildinst(add, true, false), tempregkey, originalregkey,
           imm12key);
      o.reg := tempreg; { key will index the tempreg } 
      o.index := maxoffset;
      end
    else if offset and ($FF000FFF - mask) = 0 then
      begin
      keytable[imm12key].oprnd.imm12_value := ($FFF000 and offset) div $1000;
      keytable[imm12key].oprnd.imm12_shift := true;
      gen3(after, buildinst(add, true, false), tempregkey, originalregkey,
           imm12key);
      o.reg := tempreg; { key will index the tempreg } 
      o.index := offset and mask;
      end
    else if offset and ($FFFF - mask) = 0 then
      begin
      gen2(after, buildinst(movz, true, false), tempregkey,
           settemp(long, imm16_oprnd(offset div $10000, 16)));
      gen3(after, buildinst(add, true, false), tempregkey, originalregkey, tempregkey);
      o.reg := tempreg; { key will index the tempreg } 
      o.index := offset and mask;
      end
    else
      begin
      genlongint(after, offset, tempreg);
      gen3(after, buildinst(add, true, false), tempregkey, originalregkey, tempregkey);
      o.mode := unsigned_offset;
      o.index := 0;
      o.reg := tempreg;
      end
  else if offset < minoffset then
    if -offset + minoffset <= 4095 then
      begin
      keytable[imm12key].oprnd.index := -offset + minoffset;
      gen3(after, buildinst(sub, true, false), tempregkey, originalregkey,
           imm12key);
      o.reg := tempreg; { key will index the tempreg } 
      o.index := minoffset;
      end
    else if -offset and ($FFFF - mask) = 0 then
      begin
      gen2(after, buildinst(movz, true, false), tempregkey,
           settemp(long, imm16_oprnd(-offset div $10000, 16)));
      gen3(after, buildinst(sub, true, false), tempregkey, originalregkey, tempregkey);
      o.reg := tempreg; { key will index the tempreg } 
      o.index := offset and mask;
      end
    else
      begin  
        genlongint(after, -offset, tempreg);
        gen3(after, buildinst(sub, true, false), tempregkey, originalregkey, tempregkey);
        o.mode := unsigned_offset;
        o.index := 0;
        o.reg := tempreg;
      end;
  tempkey := savetempkey;

end {handle_offset9_oprnd};

procedure handle_offset12_oprnd(var after: nodeptr; tempreg: regindex;
                                len: unsigned; var o: oprndtype);

{ Handle scaled 12-bit offsets  It assumes that the key passed in
  is set up for the case where the offset already fits.
}

var offset, maxoffset: unsignedint;
  savetempkey, tempregkey, originalregkey, imm12key: keyindex;

begin {handle_offset12_oprnd}

  { assert mode = abstract_offset }

  offset := o.index;
  maxoffset := 4095 * len;
  o.mode := unsigned_offset;

  { see if we have to do anything kinky here }
  if offset > maxoffset then
    begin
    savetempkey := tempkey;
    tempregkey := settemp(long, reg_oprnd(tempreg));
    originalregkey := settemp(long, reg_oprnd(o.reg));
    imm12key := settemp(long, imm12_oprnd(0, false));
    if (offset and $FF000000 = 0) then
      begin
      keytable[imm12key].oprnd.index := (($FFFFFF - maxoffset) and offset) div $1000;
      keytable[imm12key].oprnd.imm12_shift := true;
      gen3(after, buildinst(add, true, false), tempregkey, originalregkey,
           imm12key);
      o.reg := tempreg; { operand will index tempreg }
      o.index := offset and maxoffset;
      end
    else
      begin
      genlongint(after, offset, tempreg);
      o.mode := reg_offset;
      o.reg2 := tempreg;
      o.shift := 0;
      o.extend := xtx;
      o.signed := false;
      end;
    tempkey := savetempkey;
    end;

end {handle_offset12_oprnd};


procedure genldr(var after: nodeptr;
                 len: addressrange;
                 signed: boolean;
                 dst, src: keyindex);

  { gen a ldr instruction and fix offset field if necessary and possible.
    sp offsets are finalized after a routine has finished compilation.
  }

  begin {genldr}
    gen2(after, ldrinst(len, signed), dst, src);
    if (after^.oprnds[2].mode = abstract_offset) and
       (after^.oprnds[2].reg <> sp)  then
      if after^.oprnds[2].index > 0 then
        handle_offset12_oprnd(after^.prevnode, ip1, len, after^.oprnds[2])
      else
        handle_offset9_oprnd(after^.prevnode, false, ip1, after^.oprnds[2]);
  end {genldr};

procedure genstr(var after: nodeptr;
                 len: addressrange;
                 dst, src: keyindex);

  { gen a ldr instruction and fix offset field if necessary and possible.
    sp offsets are finalized after a routine has finished compilation.
  }

  begin {genstr}
    gen2(after, strinst(len), dst, src);
    if (after^.oprnds[2].mode = abstract_offset) and
       (after^.oprnds[2].reg <> sp)  then
      if after^.oprnds[2].index > 0 then
        handle_offset12_oprnd(after^.prevnode, ip1, len, after^.oprnds[2])
      else
        handle_offset9_oprnd(after^.prevnode, false, ip1, after^.oprnds[2]);
  end {genstr} ;

{ These procedures work on keytable entries, useful when generating code
  only.  The keytable entry that is returned must be used immediately because
  it might reference ip0.

  Eventually I may just generate the unresolved operands and just fix them up
  by walking the generated code.
}

procedure handle_bitmask(var k: keyindex);

{ Materializes an intconst into either a bitmask immediate or register }

  begin {handle_bitmask}
    with keytable[k].oprnd do
      if mode = intconst then
        if is_bitmask(int_value, 32) then
          k := settemp(len, immbitmask_oprnd(int_value))
        else
          begin
          genlongint(lastnode, int_value, ip0);
          k := settemp(len, reg_oprnd(ip0));
          end;
  end {handle_bitmask};

procedure handle_intconst12(var after:  nodeptr; var k: keyindex);

  { This is straightforward unless the integer constant won't fit in 12 bits, in
    which case we must generate some code.  We will do so after the node pointer
    passed to us as a parameter.
  }

  var
    newkey: keyindex;

  begin {handle_intconst12}
    with keytable[k].oprnd do
      if mode = intconst then
        if (int_value = 0) then
          k := settemp(len, reg_oprnd(zero))
        else if (int_value >= 0) and (int_value <= $FFF) then
          k := settemp(len, imm12_oprnd(int_value, false))
        else if ((int_value and $FFF) = 0) and (int_value <= $FFF000) then
          k := settemp(len, imm12_oprnd(int_value div $1000, true))
        else if ((int_value and $F000 = 0) and (int_value <= $FFFFFF)) then
          begin
            gen2(after, buildinst(movz, true, false),
                 settemp(len, reg_oprnd(ip0)),
                 settemp(len, imm16_oprnd((int_value div $10000) and $FFFF, 16)));
            k := settemp(len, imm12_oprnd(int_value, false))
          end
        else
          begin
          genlongint(after, int_value, ip0);
          k := settemp(len, reg_oprnd(ip0));
          end;
  end {handle_intconst12};

procedure handle_intconst16(var after: nodeptr; var k: keyindex; r: regindex);

  { Given an abstract intconst operand, materialize it into either
    a sixteen bit immedate operand with optional shift or the full value in
    r.  This will generally be passed the value of ip0 or ip1 and used
    immediately.

    Only handles 16 and 32 bit values currently.
  }

  var
    val: unsigned;

  begin {handle_intconst16}
    with keytable[k].oprnd do
      if mode = intconst then
      begin
        val := int_value;
        if (val and $FFFF0000) = 0 then
          k := settemp(len, imm16_oprnd(val, 0))
        else
          begin
          k := settemp(len, reg_oprnd(r));
          if is_bitmask(val, 32) then
            gen2(lastnode, buildinst(mov, false, false), k, 
                 settemp(len, immbitmask_oprnd(val)))
          else
            genlongint(after, val, keytable[k].oprnd.reg);
          end
      end
  end {handle_intconst16};

procedure gensimplemove(var after: nodeptr; src: keyindex; dst: keyindex);

  { move a simple item from the src to dst, currently just values that
    aren't in a floating-point register.
  }

  var
    i: insts;
    ip0temp: keyindex;

  begin {gensimplemove}
    if (keytable[src].oprnd.mode = intconst) and
       (keytable[src].oprnd.int_value = 0) then
      src := settemp(len, reg_oprnd(zero));
    if (keytable[dst].oprnd.mode = register) and
       (keytable[src].oprnd.mode = intconst) then
      handle_intconst16(after, src, keytable[dst].oprnd.reg)
    else handle_intconst16(after, src, ip0);
    if not equivaddr(src, dst) then
      if (keytable[dst].oprnd.mode = register) and
         ((keytable[src].oprnd.mode = register) or
          (keytable[src].oprnd.mode = imm16)) then
      gen2(after, buildinst(mov, true, false), dst, src)
    else if keytable[dst].oprnd.mode = register then
      genldr(after, keytable[src].len, keytable[src].signed, dst, src)
    else if keytable[src].oprnd.mode <> register then
      begin
      ip0temp := settemp(keytable[dst].len, reg_oprnd(ip0));
      if keytable[src].oprnd.mode = imm16 then
        gen2(after, buildinst(mov, keytable[dst].len = long, false), ip0temp, src)
      else
        genldr(after, keytable[src].len, keytable[src].signed, ip0temp, src);
      genstr(after, keytable[dst].len, ip0temp, dst);
      end
    else genstr(after, keytable[dst].len, src, dst);
  end {gensimplemove} ;

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

  var
    newkey: keyindex;

  begin {loadreg}
    if keytable[k].oprnd.mode <> register then
      begin
      lock(other);
      newkey := settemp(keytable[k].len, reg_oprnd(getreg));
      gensimplemove(lastnode, settemp(keytable[k].len, keytable[k].oprnd),
                    newkey);
      unlock(other);
      changevalue(k, newkey);
      end;
end {loadreg} ;

procedure prepareoprnd(var k: keyindex; { the key we're interested inn }
                       other: keyindex; { protect this key }
                       modes: oprnd_mode_set; { often only register }
                       bitmask: boolean { if true, allowed intconst must be a bitmask,
                                          otherwise allowed intconst must be an imm12,
                                          otherwise we load it into a register });

  { If the key isn't of one of the given modes, load it into a register.

    This key is often (but not always) the right operand of
    a pseudo instruction, such as addint, andint, mulint, which have differing
    ideas as to what they'll allow as their second source operand.
  }

  begin {prepareoprnd}
    with keytable[k].oprnd do
      if not (mode in modes) then
        loadreg(k, other)
      else if mode = intconst then
{DRB?}
        handle_intconst12(lastnode, k)
      else loadreg(k, other)
  end {prepareoprnd};

function preparelitint(value: integer; other: keyindex): keyindex;

  { none of the lit pseudoops have a literal bitmask.
  }

  var
    newkey: keyindex;

  begin
    newkey := settemp(len, intconst_oprnd(value));
    handle_intconst12(lastnode, newkey);
    preparelitint := newkey;
  end;

procedure makeoffsetptr(var after: nodeptr; offset: integer; src,dst: regindex);

  var
    offsettemp, srctemp, dsttemp, savetempkey: keyindex;
    i: insts;

  begin {makeoffsetptr}
    if offset < 0 then
      begin
      i := sub;
      offset := -offset;
      end
    else i := add;
    savetempkey := tempkey;
    offsettemp := settemp(long, intconst_oprnd(offset));
    srctemp := settemp(long, reg_oprnd(src));
    dsttemp := settemp(long, reg_oprnd(dst));
    handle_intconst12(after, offsettemp);
    gen3(after, buildinst(i, true, false), dsttemp, srctemp, offsettemp);
    tempkey := savetempkey;
  end {makeoffsetptr};

procedure genmoveaddress(src, dst: keyindex);

{ Move the address of the src value to the destination value,
  which must be a general register.
}

  var
    labelkey: keyindex; {for label_offset}

  begin {genmoveaddress}
    if keytable[dst].oprnd.mode <> register then
      begin
      write('destination is not a register in genmoveaddress ');
      compilerabort(inconsistent);
      end;

    with keytable[src].oprnd do
      case mode of
      label_offset:
        begin
        labelkey := settemp(long, labeltarget_oprnd(labelno, true, labeloffset)); 
        gen3(lastnode, buildinst(add, true, false), dst, settemp(long, reg_oprnd(reg)), labelkey);
        end;
      labeltarget:
        begin
        gen2(lastnode, buildinst(adrp, true, false), dst, src);
        keytable[src].oprnd.lowbits := true;
        gen3(lastnode, buildinst(add, true, false), dst, dst, src);
        keytable[src].oprnd.lowbits := false;
        end;
      abstract_offset:
        if index <> 0 then
{should all register adjustments be made after generation?  This isn't working for
 sp which needs to be delayed. First peephole-though-not-quite-optimization?}
          if reg <> sp then
            makeoffsetptr(lastnode, index, reg, keytable[dst].oprnd.reg)
          else
            gen3(lastnode, buildinst(add, true, false), dst,
                 settemp(long, reg_oprnd(sp)),
                 settemp(long, imm12_oprnd(index, false)));
      reg_offset:
        begin
        gen3(lastnode, buildinst(add, true, false), dst,
             settemp(long, reg_oprnd(reg)),
             settemp(long, extend_reg_oprnd(reg2, extend, shift, signed)));
        end;
      otherwise
        begin
        write('bad operand in genmoveaddress key: ', src, ' mode: ', ord(mode));
        compilerabort(inconsistent);
        end;
      end;
  end; {genmoveaddress}

{ stack offset adjustment procedures }

procedure finalizestackoffsets(firstnode: nodeptr; lastnode: nodeptr;
                               amount, savedregspace: integer);

{ Flip the dummy negative offsets to the stack to positive offsets.  If a stack
  slot is close enough to fp we'll use it as the base register.  Since callee-saved
  registers aren't handled until after code for the block has been generated, we
  must take this into account using the savedregspace parameter.
}

  var
    stopnode, after, p: nodeptr;
    savetempkey, fixedtempkey: keyindex;
    i: integer;

  begin {finalizestackoffsets}
    stopnode := lastnode^.nextnode;
    while firstnode <> stopnode do
      begin
      with firstnode^ do
        if (kind = instnode) then
          if (inst.inst = add) and (oprnds[2].mode = register) and
             (oprnds[2].reg = sp) and (oprnds[3].mode = imm12) then
            begin
              if oprnds[3].imm12_value - savedregspace >= -4095 then
                begin
                inst.inst := sub;
                oprnds[2].reg := fp;
                oprnds[3].imm12_value := -(oprnds[3].imm12_value - savedregspace); 
                end
              else if oprnds[3].imm12_value + amount <= 4095 then
                oprnds[3].imm12_value := oprnds[3].imm12_value + amount
              else
                begin 
                after := firstnode;
                makeoffsetptr(after, oprnds[3].imm12_value + amount, sp,
                              oprnds[1].reg);
                deletenodes(firstnode, firstnode);
                firstnode := after;
                end
            end
          else
            begin
            if (oprnds[oprnd_cnt].mode = abstract_offset) and
               (oprnds[oprnd_cnt].reg = sp) then
              if inst.inst in [ldp, stp] then
                if oprnds[3].index - savedregspace >= -512 then
                  begin
                  oprnds[3].mode := signed_offset;
                  oprnds[3].reg := fp;
                  oprnds[3].index := oprnds[3].index - savedregspace;
                  end
                else
                  begin
                  after := firstnode^.prevnode;
                  oprnds[3].index := oprnds[3].index + amount;
                  handle_offset9_oprnd(after, true, ip0, oprnds[3]);
                  firstnode := after^.nextnode;
                  end
              else if inst.inst in [first_ls..last_ls] then
                if oprnds[2].index >= 0 then
                  oprnds[2].mode := unsigned_offset { assume < 4095 params }
                else if oprnds[2].index - savedregspace >= -256 then
                  begin
                  oprnds[2].mode := signed_offset;
                  oprnds[2].reg := fp;
                  oprnds[2].index := oprnds[2].index - savedregspace;
                  end
                else
                  begin
                  after := firstnode^.prevnode;
                  oprnds[2].index := oprnds[2].index + amount;
                  handle_offset12_oprnd(after, ip0, long, oprnds[2]);
                  firstnode := after^.nextnode;
                  end
                else
                  begin
                  write(macfile, 'finalizestackoffset load or store expected ');
                  write_inst(inst);
                  compilerabort(inconsistent);
                  end
            end;
      firstnode := firstnode^.nextnode;
      end;
  end {finalizestackoffsets};

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
              { DRB: temporary hack }
              if stackcopy >= stackcounter then
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
        r := settemp(long, reg_oprnd(0)); {dummy}
        for i := 0 to lastreg do
          with regstate[i] do
            if active then
              begin
              keytable[r].oprnd.reg := i;
              if (keytable[stackcopy].oprnd.mode = register) and
                 (keytable[stackcopy].regenoprnd.mode <> nomode) then
                begin
                gen2(lastnode,
                      buildinst(adrp, true, false), r,
                      settemp(long, keytable[stackcopy].regenoprnd));
                reloadfirst := lastnode;
                gen2(lastnode, ldrinst(keytable[stackcopy].len, keytable[stackcopy].signed),
                     r,
                     settemp(long, label_offset_oprnd(keytable[r].oprnd.reg,
                             keytable[stackcopy].regenoprnd.labelno,
                             keytable[stackcopy].regenoprnd.labeloffset)))
                end
              else if keytable[stackcopy].oprnd.mode = label_offset then
                begin
                gen2(lastnode,
                      buildinst(adrp, true, false), r,
                      settemp(long, labeltarget_oprnd(keytable[stackcopy].oprnd.labelno, false,
                                                      keytable[stackcopy].oprnd.labeloffset)));
                reloadfirst := lastnode;
                end
              else
                begin
                gen2(lastnode, ldrinst(long, true), r, stackcopy);
                reloadfirst := lastnode;
                end;
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
      keytable[key].validtemp := validtemp;
      keytable[key].packedaccess := packedaccess;
      keytable[key].regenoprnd := regenoprnd;

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

keytable[key].signed := keytable[left].signed; {AWFUL Free Pascal bug requires this}

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
        tempreg := settemp(long, reg_oprnd(0)); {dummy}

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
                  if (keytable[stackcopy].oprnd.mode = register) and
                     (keytable[stackcopy].regenoprnd.mode <> nomode) then
                    begin
                    gen2(lastnode, buildinst(adrp, true, false), tempreg,
                         settemp(long, keytable[stackcopy].regenoprnd));
                    gen2(lastnode, ldrinst(keytable[stackcopy].len, keytable[stackcopy].signed),
                         tempreg,
                         settemp(long, label_offset_oprnd(keytable[tempreg].oprnd.reg,
                                       keytable[stackcopy].regenoprnd.labelno,
                                       keytable[stackcopy].regenoprnd.labeloffset)))
                    end
                  else if keytable[stackcopy].oprnd.mode = label_offset then
                    gen2(lastnode, buildinst(adrp, true, false), tempreg,
                         settemp(long, keytable[stackcopy].regenoprnd))
                  else
                    gen2(lastnode, ldrinst(long, true), tempreg, stackcopy);
                  end;
                end
              else if reloadfirst <> nil then deletenodes(reloadfirst, reloadlast);
              { DRB: temporary hack }
              if stackcopy >= stackcounter then
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
                  gensimplemove(lastnode, stackcopy, tempreg);
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
{
    address(right);
}
    dereference(right);

    lock(right);
    if lit then
      left := settemp(len, intconst_oprnd(pseudoinst.oprnds[1]))
    else
      begin
{ DRB
      unpackshrink(left, len);
}
      address(left);
      end;

    lock(left);

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
    if globalreg then
      setkeyvalue(right)
    else
      begin
      setkeyvalue(settemp(long, reg_oprnd(getreg)));
      keytable[key].regsaved := true;
      if nonvolatile then
        if keytable[right].regenoprnd.mode <> nomode then
          keytable[key].regenoprnd := keytable[right].regenoprnd
        else
          begin
          keytable[right].validtemp := true;
          keytable[key].properreg := right;
          end;
      end;

    unlock(left);
    unlock(right);

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

    gensimplemove(lastnode, left, key);

    dontchangevalue := 0;
{
    rereference(key);
}
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
      regkey := settemp(long, reg_oprnd(originalreg));
      keytable[regkey].len := savedlen;

      if target <> 0 then
        begin
        makeaddressable(target);
{ DRB
        shrink(target, keytable[forkey].len);
}
        loadreg(target, regkey);
        gen2(lastnode, buildinst(cmp, savedlen = long, false), regkey, target);
        genbr(branch, pseudoinst.oprnds[2]);
        end;

      if nonvolatile and not globalreg
      then
        if keytable[forkey].regenoprnd.mode <> nomode then
          begin
          gen2(lastnode, buildinst(adrp, true, false),
               settemp(long, reg_oprnd(ip0)),
               settemp(long, keytable[forkey].regenoprnd));
          gen2(lastnode, strinst(keytable[forkey].len),
               regkey,
               settemp(long, label_offset_oprnd(ip0,
                             keytable[forkey].regenoprnd.labelno,
                             keytable[forkey].regenoprnd.labeloffset)))
          end
        else gensimplemove(lastnode, regkey, keytable[forkey].properreg)
      else
        begin
        keytable[forkey].regsaved := false;
        savekey(forkey);
        end;

      enterloop;

      { see defforindexx for an explaination of this }
{      if nonvolatile and not globalreg then}
{
        dereference(keytable[forkey].properreg);
}
{        dereference(forkey); }
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
    l: unsigned;
    needcompare: boolean; {need to generate a comparison at end of loop}
    branch: insts;
    maxvalue: unsigned; {"cmp" instruction works if limit value < maxvalue}
    i: 1..4; {DRB: induction var limited by 32-bit integers}
    byvalue: unsigned; { BY value (always "1" for Pascal) }
    finalvalue: integer; { if improved }
    k, newkey: keyindex;

  begin {forbottomx}
    byvalue := len;
    context[contextsp].lastbranch := context[contextsp].first;

    with forstack[forsp] do
      begin
      sgn := keytable[forkey].signed;
      dereference(forkey);
      l := keytable[forkey].len;
      if sgn then branch := signedbr
      else branch := unsignedbr;
    {  with keytable[forkey], oprnd do
        begin
}
        maxvalue := 127;
        for i := 2 to max(word, l) do maxvalue := maxvalue * 256 + 255;
        if not sgn then maxvalue := maxvalue * 2 + 1;
        if not keytable[forkey].regvalid or (keytable[forkey].oprnd.mode <> register) or
           (keytable[forkey].oprnd.reg <> originalreg) then
          begin
          if keytable[forkey].regenoprnd.mode <> nomode then
            begin
            makeaddressable(forkey);
            k := forkey;
            end
          else
            begin
            k := keytable[key].properreg;
            keytable[k].tempflag := true;  
            makeaddressable(k);
            end;
{ was dereference(forkey) here rather than above }
          newkey := settemp(long, reg_oprnd(originalreg));
          gensimplemove(lastnode, k, newkey);
          forkey := newkey;
          if loopoverflow = 0 then
            loopstack[loopsp].regstate[originalreg].killed := false;
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
      if improved then
        begin
        finalvalue := keytable[target].oprnd.int_value;
        if incinst = add then
         needcompare := (unsignedint(maxvalue - finalvalue) >= byvalue)
                         or (unsignedint(maxvalue - initval)
                             mod byvalue < unsignedint(maxvalue - finalvalue)) 
        else if sgn then
          needcompare := (unsignedint(finalvalue + maxvalue + 1) >= byvalue) or
                         (initval mod byvalue < finalvalue + maxvalue + 1)
        else needcompare := (unsignedint(finalvalue) >= byvalue) or
                             (unsignedint(initval) mod byvalue < finalvalue)
        end
      else needcompare := false;

        { DRB: for pascal always 1 }
      gen3(lastnode, buildinst(incinst, keytable[forkey].len = long, not needcompare),
           forkey, forkey, settemp(long, imm12_oprnd(byvalue, false)));

      if needcompare then
        begin

        { Change comparisons against 1 to be comparisions against 0.
        }

        if finalvalue = 1 then
          begin
          if incinst = sub then
            begin
            finalvalue := 0;
            if sgn then branch := bgt else branch := bhi;
            end;
          end
        else if sgn and (incinst = add) and (finalvalue = -1) then
          begin
          finalvalue := 0;
          branch := blt;
          end;

        gen2(lastnode, buildinst(cmp, keytable[forkey].len = long, false), forkey,
             preparelitint(finalvalue, forkey));
        genbr(branch, pseudoinst.oprnds[1]);
        end {if needcompare}
      else if sgn then genbr(bvc, pseudoinst.oprnds[1])
      else if incinst = sub then
        genbr(bcs, pseudoinst.oprnds[1]) 
        else genbr(bcc, pseudoinst.oprnds[1]);
      end; {with forstack[forsp]}

    dereference(target);
    forsp := forsp - 1;
    pseudoinst.oprnds[1] := pseudoinst.oprnds[2];
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
    if keytable[right].oprnd.mode = intconst then
      begin
      shiftfactor := keytable[right].oprnd.int_value;
      knowneven := shiftfactor > 0;
      if shiftfactor < 0 then backwards := not backwards;
      shiftfactor := abs(shiftfactor);
      { shift amount is encoded as immr:imms because the shifts
        are just an alias for a bitfield move.
      }
      right := settemp(len, immbitmask_oprnd(shiftfactor));
      end
    else
      loadreg(right, left);
    unlock(key);
    if backwards then
      if keytable[left].signed then shiftinst := asrinst
      else shiftinst := lsrinst;
    gen3(lastnode, buildinst(shiftinst, len = long, false), key, left, right);
    keytable[key].signed := keytable[left].signed;
  end {shiftintx} ;

procedure logicalarithmetic(inst: insts);

{ Generate code for a simple binary, logical integer operation (and, or, xor)
}

  begin {logicalarithmetic}
    {unpkshkboth(len);}
    addressboth;
    settargetorreg;
    lock(key);
    loadreg(left, right);
    if keytable[right].oprnd.mode = intconst then
      handle_bitmask(right)
    else if not (keytable[right].oprnd.mode in [register, shift_reg]) then
      loadreg(right, left);
    unlock(key);
    gen3(lastnode, buildinst(inst, len = long, false), key, left, right);
    keytable[key].signed := signedoprnds;
  end {logicalarithmetic} ;

procedure integermultiply;

{ Generate code for a simple binary, integer operation (add, sub, etc.)
}

  begin {integermultiply}
    {unpkshkboth(len);}
    addressboth;
    settargetorreg;
    lock(key);
    loadreg(left, right);
    loadreg(right, left);
    unlock(key);
    gen3(lastnode, buildinst(mul, len = long, false), key, left, right);
    keytable[key].signed := signedoprnds;
  end {integermultiply} ;

procedure integerarithmetic(inst: insts);

{ Generate code for a simple binary, integer operation (add, sub, etc.)
}

  begin {integerarithmetic}
    {unpkshkboth(len);}
    addressboth;
    settargetorreg;
    lock(key);
    loadreg(left, right);
    if keytable[right].oprnd.mode = intconst then
      handle_intconst12(lastnode, right)
    else if not (keytable[right].oprnd.mode in [register, shift_reg]) then
      loadreg(right, left);
    unlock(key);
    gen3(lastnode, buildinst(inst, len = long, false), key, left, right);
    keytable[key].signed := signedoprnds;
  end {integerarithmetic} ;

procedure unaryint(inst: insts);

{ Generate an operator such a neg that has only one source operand,
  which must be in a register.  Generally these are aliases for
  generalized instructions such as sub, with one operand being the
  zero register.
}


  begin {unaryint}
{    unpackshrink(left, len);}
    settargetorreg; 
    lock(key);
    address(left);
    loadreg(left, 0);
    unlock(key);
    gen2(lastnode, buildinst(inst, len = long, false), key, left);
    keytable[key].signed := keytable[left].signed;
  end {unaryint} ;

procedure compintx;

  begin {compintx}
{    unpackshrink(left, len);}
    address(left);
    loadreg(left, 0);
    settargetorreg; 
    gen2(lastnode, buildinst(movn, len = long, false), key, left);
    keytable[key].signed := keytable[left].signed;
  end {compintx};

procedure compboolx;

  begin {compboolx}
    address(left);
    loadreg(left, 0);
    gen2(lastnode, buildinst(cmp, false, false), left,
         settemp(long, imm12_oprnd(0, false)));
    settargetorreg; 
    gen2(lastnode, buildinst(cset, false, false), key,
                   settemp(0, cond_oprnd(eq)));
  end {compboolx};

procedure incdec(inst: insts {add, sub} );

{ Generate add/sub #1, left.  Handles incint and decint pseudoops.
}


  begin {incdec}
{    unpackshrink(left, len);}
    settargetorreg; 
    lock(key);
    address(left);
    loadreg(left, 0);
    unlock(key);
    gen3(lastnode, buildinst(inst, len = long, false), key, left,
         settemp(len, imm12_oprnd(1, false)));
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

    { Shrinking operands is only safe if the sign is set back to the original
      sign for that length.  The field "signlimit" provides that function.
    }
    {unpkshkboth(len);}

    if signedoprnds then brinst := signedbr
    else brinst := unsignedbr;

    loadreg(left, right);
    loadreg(right, left);
    gen2(lastnode, buildinst(cmp, len = 4, false), left, right);
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
    litkey: keyindex;

  begin
    address(left);
    loadreg(left, 0);
    if (pseudoinst.oprnds[2] = 0) and (signedbr in [beq, bne]) then
      if signedbr = beq then
        setbr(cbz, keytable[left].oprnd)
      else
        setbr(cbnz, keytable[left].oprnd)
    else
      begin
      if not keytable[left].signed or
         (pseudoinst.oprnds[2] >= 0) then
        i := cmp
      else
        begin
        i := cmn;
        pseudoinst.oprnds[2]:= -pseudoinst.oprnds[2];
        end;
      litkey := preparelitint(pseudoinst.oprnds[2], left);
      gen2(lastnode, buildinst(i, len = long, false), left, litkey);
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
      gen3(lastnode, buildinst(sdiv, len = long, false), key, left, right)
    else
      gen3(lastnode, buildinst(udiv, len = long, false), key, left, right);
    keytable[key].signed := signedoprnds;
    if (pseudobuff.op = getrem) or (pseudoinst.refcount = 2) then
      begin
      if pseudoinst.refcount = 2 then
        begin
        lock(key);
        gen4(lastnode, buildinst(msub, len = long, false),
             settemp(len, reg_oprnd(getreg)),
             key, right, left); 
        unlock(key);
        adjustregcount(key, -pseudoinst.refcount);
        keytable[key].oprnd.mode := tworeg;
        keytable[key].oprnd.reg2 := keytable[tempkey].oprnd.reg;
        adjustregcount(key, pseudoinst.refcount);
        { we only need to save the register which contains the result
          we need later, not for the following pseudoop
        }
        if pseudobuff.op = getquo then keytable[key].regsaved := true
        else keytable[key].reg2saved := true;
        end
      else
        gen4(lastnode, buildinst(msub, len = long, false), key, key, right, left); 
      unlock(right);
      unlock(left);
      end;
  end {divintx} ;

procedure getquox;

{ Quotient is always left in the reg field generated by divintx,
  so we'll ignore the tworeg case.
}

  begin {getquox}
    if keytable[left].oprnd.mode = tworeg then
      keytable[left].reg2valid := true;
    address(left);
    keytable[key].regsaved := keytable[left].regsaved;
    keytable[key].properreg := keytable[left].properreg; 
    setvalue(reg_oprnd(keytable[left].oprnd.reg));
  end {getquox} ;

procedure getremx;

{ Remainder will be in reg field of generated by divintx if the quotient
  is not needed, or reg2 if both quotient and remainder are used.
}

  begin {getremx}
    if keytable[left].oprnd.mode = tworeg then
      keytable[left].regvalid := true;
    address(left);
    if keytable[left].oprnd.mode = tworeg then
      begin
      keytable[key].reg2saved := keytable[left].reg2saved;
      keytable[key].properreg2 := keytable[left].properreg2; 
      setvalue(reg_oprnd(keytable[left].oprnd.reg2));
      end
    else
      setallfields(left);
  end {getremx} ;


procedure stmtbrkx;

{ Generate statement information for the macro file and later for gdb.
}

  var
    p: nodeptr;

  begin
    if firststmt = 0 then firststmt := pseudoinst.oprnds[1];
    p := newnode(lastnode, stmtnode);
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
    keytable[key].oprnd := intconst_oprnd(pseudoinst.oprnds[1]);
{
    context[contextsp].keymark := key;
}
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
{
    context[contextsp].keymark := key;
}
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
{
    context[contextsp].keymark := key;
}
  end {dorealx} ;
}

procedure dolevelx(ownflag: boolean {true says own sect def} );

{ Generate a reference to the data area for the level specified in
  opernds[1].  This is the global base label for level 1, relative to fp
  for the current level, and relative to sl for level-1.  For other
  levels, generate an indirect from the pointer contained in the 
  target operand and offet relative to that.
}

  var
    reg: regindex;

  begin
    keytable[key].access := valueaccess;
    with keytable[key], oprnd do
      begin
{
      if (left <= 1) or (left >= level - 1) then
        context[contextsp].keymark := key;
}
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
        setvalue(labeltarget_oprnd(bsslabel, false, 0))
      else if left = level then
        setvalue(index_oprnd(abstract_offset, fp, 0))
      else if left = level - 1 then
        setvalue(index_oprnd(abstract_offset, sl, 0))
      else
        begin
        address(target);
        reg := getreg;
        gensimplemove(lastnode, settemp(long, index_oprnd(abstract_offset,
                      keytable[target].oprnd.reg, -long)),
                      settemp(long, reg_oprnd(reg)));
        setvalue(index_oprnd(abstract_offset, reg, 0));
        end;
      len := long;
      end;
  end {dolevelx} ;

procedure dostructx;

  var
    labelkey, regkey: keyindex;

begin {dostructx}
  setvalue(labeltarget_oprnd(rodatalabel, false, pseudoinst.oprnds[1]));
end {dostructx} ;

{ DRB regtemp }
procedure blockcodex;

{ Generate code for the beginning of a block.

  If this is a procedure block, standard procedure entry code is generated.
}

  var
    i: integer; {general use induction variable}
    p: nodeptr;
    t1, t2: keyindex;

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
    lastreg := sl - left;
    firstreg := 0;
    firstfpreg := 0;
    lineoffset := pseudoinst.len;

    if (blockref = 0) and (switchcounters[mainbody] > 0) then
      begin
      p := newnode(lastnode, bssnode);
      p^.bsssize := globalsize;
      end;

    p := newnode(lastnode, textnode);

    with proctable[blockref] do
      begin
      if intlevelrefs then
        begin
        t1 := settemp(long, reg_oprnd(sl));
        t2 := settemp(long, index_oprnd(signed_offset, sl, -long));
        for i := 1 to levelspread - 1 do
          gen2(lastnode, buildinst(ldr, true, false), t1, t2);
        end;
      end;
    p := newnode(lastnode, proclabelnode);
    p^.proclabel := blockref;
    codeproctable[blockref].proclabelnode := p;

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
    savetempkey, fptemp, sptemp, linktemp, ip0temp, spoffsettemp,
    saveregtemp, savereg2temp, saveregoffsettemp, spadjusttemp: keyindex;
    regcost, regcount, fpregcost, fpregcount: integer;
    reglist, fpreglist:
      array [regindex] of
        record
        r: regindex;
        index: integer;
        end;
    regoffset, fpregoffset: array [regindex] of integer; {offset for each reg}
    fpregssaved : array [regindex] of boolean;
    regssaved : array [regindex] of boolean;
    reg: regindex; { temp for dummy register }
    prepost: boolean; {if pre/post index modes can be used}
    fplroprnd: oprndtype;

  begin {putblock}

    { todo save procedure symbol table index }

    processregsaves;

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
      The static link must be the first register saved if used.
     }
    regcost := 0;
    regcount := -1;
    for i := sp downto pr + 1 do
      if regused[i] then
        begin
        regcount := regcount + 1;
        regcost := regcost + long;
        with reglist[regcount] do
          begin
          index  := -regcost;
          r := i;
          end;
        end;

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
    linktemp := settemp(long, reg_oprnd(link));
    sptemp := settemp(long, reg_oprnd(sp));
    fptemp := settemp(long, reg_oprnd(fp));
    ip0temp := settemp(long, reg_oprnd(ip0));

    { fix this better }
    if level = 1 then
      blockcost := quad + regcost + maxstackoffset
    else
      blockcost := blksize + regcost + maxstackoffset;

    blockcost := (blockcost + (2 * long - 1)) and - (2 * long);

    finalizestackoffsets(firstnode, lastnode, maxstackoffset, regcost);

    spoffset := regcost + maxstackoffset;
    spoffsettemp := settemp(long, index_oprnd(unsigned_offset, sp, spoffset));
    saveregoffsettemp := settemp(long, index_oprnd(signed_offset, fp, 0));

    { for using STP/LDP to save callee-saved registers }
    saveregtemp := settemp(long, reg_oprnd(0));
    savereg2temp := settemp(long, reg_oprnd(0));

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
      makeoffsetptr(p1, -blockcost, sp, sp);
      handle_offset9_oprnd(p1, true, ip0, keytable[spoffsettemp].oprnd);
      end;

    gen3(p1, buildinst(stp, true, false), linktemp, fptemp, spoffsettemp);

    if (keytable[spoffsettemp].oprnd.reg <> sp) and
       (keytable[spoffsettemp].oprnd.index = 0) then
{ can this possibly work in all cases? }
      gen2(p1, buildinst(mov, true, false), fptemp,
           settemp(long, reg_oprnd(keytable[spoffsettemp].oprnd.reg)))
    else
      makeoffsetptr(p1, spoffset, sp, fp);

    { procedure exit code. Restore callee-saved registers, link and frame pointer
      registers, and shrink stack.
    } 

    i := 0;
    while i <= regcount do
      begin
      keytable[saveregtemp].oprnd.reg := reglist[i].r;
      if i = regcount then
        begin
        keytable[saveregoffsettemp].oprnd.index := reglist[i].index;
        gen2(p1, buildinst(str, true, false), saveregtemp, saveregoffsettemp);
        gen2(lastnode, buildinst(ldr, true, false), saveregtemp, saveregoffsettemp);
        i := i + 1;
        end
      else
        begin
        keytable[savereg2temp].oprnd.reg := reglist[i + 1].r;
        keytable[saveregoffsettemp].oprnd.index := reglist[i + 1].index;;
        { ordering important to make sure sl is in the right place if needed }
        gen3(p1, buildinst(stp, true, false), savereg2temp, saveregtemp,
             saveregoffsettemp);
        gen3(lastnode, buildinst(ldp, true, false), savereg2temp, saveregtemp,
             saveregoffsettemp);
        i := i + 2;
        end;
      end;

    if prepost then
      begin
      keytable[spoffsettemp].oprnd.mode := post_index;
      keytable[spoffsettemp].oprnd.index := blockcost;
      end
    else
      begin
      keytable[spoffsettemp].oprnd.mode := unsigned_offset;
      keytable[spoffsettemp].oprnd.reg := sp;
      keytable[spoffsettemp].oprnd.index := spoffset;
      handle_offset9_oprnd(lastnode, true, ip0, keytable[spoffsettemp].oprnd);
      end;

    gen3(lastnode, buildinst(ldp, true, false), linktemp, fptemp, spoffsettemp);

    if not prepost then
      makeoffsetptr(lastnode, blockcost, sp, sp);

    gen0(lastnode, buildinst(ret, false, false));
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
      blksize := oprnds[3];
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
    markreg(pseudoinst.oprnds[1]);
    setvalue(reg_oprnd(pseudoinst.oprnds[1]));
    regused[pseudoinst.oprnds[1]] := true;
    if pseudoinst.oprnds[1] > firstreg then
        firstreg := pseudoinst.oprnds[1];
  end {regtargetx} ;

procedure regtempx;

{ Generate a reference to a local variable permanently assigned to a
  general register.

  Currently they are assigned to callee-saved registers, but leaf
  routines could allocate them to scratch registers

}


  begin
    address(left);
    setvalue(reg_oprnd(lastreg + pseudoinst.oprnds[3]));
    regused[lastreg + pseudoinst.oprnds[3]] := true;
  end {regtempx} ;

procedure dovarx(s: boolean {signed variable reference} );

{ Defines the left operand as a variable reference and sets the
  result "key" to show this.

  This is used by the "dovar" and "dounsvar" pseudo-ops.
}


  begin
    dereference(left);
    setallfields(left);
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
    gensimplemove(lastnode, right, left);
    savedstkey(left);
    setallfields(left);
  end {movintptrx};

procedure movlitintx;

  var
    p: nodeptr;

  begin
    addressdst(left);
    gensimplemove(lastnode, settemp(len, intconst_oprnd(pseudoinst.oprnds[2])), left);
    savedstkey(left);
    setallfields(left);
  end;

procedure pshlitintptrx;

  begin
    gensimplemove(lastnode, settemp(len, intconst_oprnd(pseudoinst.oprnds[1])), key);
    dontchangevalue := dontchangevalue - 1;
  end;

procedure pshintptrx;

  begin {pshintptrx}
    address(left);
    gensimplemove(lastnode, left, key);
    dontchangevalue := dontchangevalue - 1;
  end {pshintptrx};

procedure movemultiple;

{ must handle very long operands as this craps out at
  65535 bytes at the moment.  Not that we really want
  to encourage moving such large structures.
}

var
  regkey: keyindex;

begin {movemultiple}
{
  if regmoveok(len) then movintptrx
  else
}
    begin
    saveactivekeys;
    addressboth;
    lockboth;
    firstreg := 3;
    regkey := settemp(long, reg_oprnd(2));
    gensimplemove(lastnode, settemp(long, intconst_oprnd(len)), regkey);
    keytable[regkey].oprnd.reg := 0;
    genmoveaddress(left, regkey);
    keytable[regkey].oprnd.reg := 1;
    genmoveaddress(right, regkey);
    markscratchregs;
    gen1(lastnode, buildinst(bl, false, false),
         settemp(long, libcall_oprnd(libcmemcpy)));
    firstreg := 0;
    unlockboth;
    end;
end; {movemultiple}

procedure pushmultiple;

  var
    regkey: keyindex;

begin {pushmultiple}
{
  if regmoveok(len) then pshintptrx
  else
}
    begin
    saveactivekeys;
    address(left);
    lock(left);
    firstreg := 3;
    regkey := settemp(long, reg_oprnd(2));
    gensimplemove(lastnode, settemp(long, intconst_oprnd(len)), regkey);
    keytable[regkey].oprnd.reg := 0;
    genmoveaddress(key, regkey);
    keytable[regkey].oprnd.reg := 1;
    genmoveaddress(left, regkey);
    markscratchregs;
    gen1(lastnode, buildinst(bl, false, false),
         settemp(long, libcall_oprnd(libcmemcpy)));
    firstreg := 0;
    unlock(left);
    end;
end; {pushmultiple}

procedure regparamx;

var
  o: oprndtype;
  saveparam: keyindex;

begin {regparamx}
if pseudoinst.oprnds[3] = 1 then regparamindex := key;
  setvalue(reg_oprnd(pseudoinst.oprnds[3]));
  regused[pseudoinst.oprnds[3]] := true;
  if left <> 0 then
    begin
    address(left);
    with keytable[left].oprnd do
      saveparam := settemp(long, index_oprnd(abstract_offset, reg,
                         index + pseudoinst.oprnds[2]));
    gensimplemove(lastnode, key, saveparam);
    setkeyvalue(saveparam);
    end;
end {regparamx};

procedure indxx;

{ Index the address reference in oprnds[1] (left) by the constant offset
  in oprnds[2].  The result ends up in "key".
}

  var
    newkey: keyindex;
    labelkey: keyindex;
    r: regindex;

  begin {indxx}
    if (pseudoinst.oprnds[2] = 0) and
        (keytable[left].oprnd.mode <> labeltarget) then
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
        labeltarget:
          {We would like to index the var with a label offset but one
           has to scale that by the length of the load or store operation.
           Need to study clang output.
          }
          begin
          r := getreg;
          newkey := settemp(long, reg_oprnd(getreg));
          labelkey := settemp(long,labeltarget_oprnd(keytable[left].oprnd.labelno,
                              false, keytable[left].oprnd.labeloffset + pseudoinst.oprnds[2]));
          keytable[key].regenoprnd := keytable[labelkey].oprnd;
          gen2(lastnode, buildinst(adrp, true, false), newkey, labelkey);
          keytable[labelkey].oprnd.lowbits := true;
          setvalue(label_offset_oprnd(r, keytable[labelkey].oprnd.labelno,
                                      keytable[labelkey].oprnd.labeloffset));
{DRB: hmmm ... }
          keytable[key].regsaved := true;
          end;
        reg_offset:
          begin
          newkey := settemp(long, reg_oprnd(getreg));
          genmoveaddress(left, newkey);
{DRB: handle long offsets }
          setvalue(index_oprnd(abstract_offset,
                   keytable[newkey].oprnd.reg, pseudoinst.oprnds[2]));
          keytable[key].regenoprnd.mode := nomode;
          end;
        abstract_offset:
          begin
          setkeyvalue(left);
          keytable[key].oprnd.index :=
            keytable[key].oprnd.index + pseudoinst.oprnds[2];
          if keytable[key].oprnd.reg in [sl, fp] then
            keytable[key].regenoprnd := keytable[key].oprnd;
          end;
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
    setvalue(index_oprnd(abstract_offset, keytable[left].oprnd.reg, 0));
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
    regkey, lefttemp: keyindex;

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
      regkey := settemp(keytable[right].len, reg_oprnd(getreg));
      gensimplemove(lastnode, right, regkey);
      changevalue(right, regkey);
      end;
    unlock(left);
 
    { A register indexed by zero will happen whenever an array is passed
      by reference.
    }
    if (keytable[left].oprnd.mode = abstract_offset) and
      (keytable[left].oprnd.index = 0) then
      lefttemp := settemp(long, reg_oprnd(keytable[left].oprnd.reg))
    else
      begin
      lock(right);
      regkey := settemp(long, reg_oprnd(getreg));
      genmoveaddress(left, regkey);
      lefttemp := settemp(long, index_oprnd(abstract_offset, keytable[regkey].oprnd.reg, 0));
      changevalue(left, lefttemp);
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
      gensimplemove(lastnode, left, key);
      end
    else
      setallfields(left);
    keytable[key].signed := (pseudoinst.oprnds[2] = 0);
  end; {loopholefnx}

procedure makestacktarget;

{DRB: obsolete?}
{ Create a slot on the stack for the current key

  Code checks length of the temp, if it is longer than
  long * 2 then we know it is not being pushed as a
  parameter.  In which case we can reuse an existing slot
  if one is available.

  A true kludge.

}


  begin {makestacktarget}
  end {makestackstarget} ;

procedure stacktargetx;

{ Sets up a key to be used as a target for code generation when the actual
  target is being pushed on the stack.  This makes targeting work with
  temps being generated.

  The sequence is:

        stacktarget     skey
        expression code
        push            skey

  If the target is for a parameter being pushed to the stack, oprnds[1] is 1,
  otherwise 0.  On this architecture, we are treating actual param pushes
  differently than targets pushed for other reasons.

  One example is long value parameter pushes which are yanked from the parameter
  list and pushed, with a pointer being passed to the routine.  The copy is
  necessary in case the routine modified the parameter value.

}

  var
    stackkey: keyindex;

  begin
    if pseudoinst.oprnds[1] = 1
      then stackkey := newparamtemp(len)
      else stackkey := newtemp(len);
    keytable[stackkey].tempflag := true;
    keytable[key].regsaved := true;
    keytable[key].properreg := stackkey;
    setkeyvalue(stackkey);
  end {stacktargetx} ;

procedure makeroomx;

begin {makeroomx}
  saveactivekeys;
  paramoffset := 0;
  dontchangevalue := dontchangevalue + 1;
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
    regparam_target := 0; {we are done filling params}

    markscratchregs;

    firstreg := 0;
    firstfpreg := 0;

    savetempkey := tempkey;
    {frame pointers in the aarch64 standard calling sequence form a linked
     list.
    }
    framekey := settemp(long, reg_oprnd(fp));

    slkey := settemp(long, reg_oprnd(sl));

    levelhack := 0;
    notcopied := 0;

    if pseudoinst.oprnds[3] <= 0 then
      begin

      { direct call }
      linkreg := proctable[pseudoinst.oprnds[1]].intlevelrefs and
                 (proctable[pseudoinst.oprnds[1]].level > 2);

      if linkreg then
        begin
        regused[sl] := true;
        levelhack := level - proctable[pseudoinst.oprnds[1]].level;
        if levelhack < 0 then
          gensimplemove(lastnode, framekey, slkey);
        end;
      gen1(lastnode, buildinst(bl, false, false),
           settemp(long, proccall_oprnd(pseudoinst.oprnds[1], max(0, levelhack))));
      end
    else
      begin
      { proc/func parameter }
      end;

    if linkreg and ((pseudoinst.oprnds[3] > 0) or (level > 2) and
       (levelhack <> 0)) then
      gensimplemove(lastnode, settemp(long, index_oprnd(signed_offset, fp, staticlinkoffset)), slkey);

    tempkey := savetempkey;

    { for stack parameters }
    dontchangevalue := dontchangevalue - 1;

    { later need to deal with x0/x1 pairs.
    }
    if proctable[pseudoinst.oprnds[1]].realfunction then
      setvalue(fpreg_oprnd(0))
    else if (len <= long) then
      setvalue(reg_oprnd(0));

    stackcounter := stackcounter + pseudoinst.oprnds[2];
    stackoffset := -keytable[stackcounter].oprnd.index;

  end {callroutinex} ;


{ Case statement generation.

  The general scheme is to generate a case branch followed directly by
  as many caseelt's as needed.  Tying a caseelt to the code for that case
  is done by the labels generated
}

procedure caseerrx;

  {we have one and only one job to do, and we do it well }

  begin {caseerrx}
    gen1(lastnode, buildinst(bl, false, false), settemp(long, libcall_oprnd(libcasetrap)));
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
    scratch, t1, t2: keyindex; { for arithmetic on case expression }
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
  scratch := settemp(word, reg_oprnd(scratchreg));
  lock(scratch);
  gensimplemove(lastnode, target, scratch);
  t1 := preparelitint(pseudoinst.oprnds[1], scratch);
  gen3(lastnode, buildinst(sub, false, false), scratch, scratch, t1);
  t1 := preparelitint(pseudoinst.oprnds[2] - pseudoinst.oprnds[1], scratch);
  gen2(lastnode, buildinst(cmp, false, false), scratch, t1);
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
  addresskey := settemp(long, reg_oprnd(addressreg));
  t1 := settemp(long, labeltarget_oprnd(tablelabel, false, 0));
  gen2(lastnode, buildinst(adrp, true, false), addresskey, t1);
  keytable[t1].oprnd.lowbits := true;
  gen3(lastnode, buildinst(add, true, false), addresskey, addresskey, t1);

  baselabel := newlabel; {must be last temp label for caseeltx}
  gen2(lastnode, buildinst(ldr, false, false), scratch,
       settemp(word, reg_offset_oprnd(addressreg, scratchreg, 2, xtw, false)));
  gen2(lastnode, buildinst(adr, true, false), addresskey,
       settemp(long, labeltarget_oprnd(baselabel, false, 0)));
  gen3(lastnode, buildinst(add, true, false), scratch, addresskey,
       settemp(long, extend_reg_oprnd(scratchreg, xtw, 2, true)));
  gen1(lastnode, buildinst(br, true, false), scratch);
  definelabel(baselabel);
  unlock(scratch);

  { now initiate the case element table }
  p := newnode(lastnode, rodatanode);
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
      genlabeldelta(lastnode, lastlabel + 1, pseudoinst.oprnds[1]);
    if pseudobuff.op <> caseelt then
      p := newnode(lastnode, textnode);
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
    labeltarget := settemp(long, labeltarget_oprnd(pseudoinst.oprnds[1], false, 0));
    if keytable[right].access = branchaccess then
      b := keytable[right].brinst
    else
      begin
      b := cbnz;
      loadreg(right, 0);
      end;
    if inv then b := invert[b];
    if (b = cbz) or (b = cbnz) then
      gen2(lastnode, buildinst(b, keytable[right].len = long, false), right, labeltarget)
    else gen1(lastnode, buildinst(b, false, false), labeltarget);
    context[contextsp].lastbranch := lastnode;
  end {jumpcond} ;

procedure cond(inv: boolean);

var
  c: conds;

begin {cond}
  address(left);
  settargetorreg;
  with keytable[left], oprnd do
    if access <> branchaccess then
      begin
      write('Conditional to value not branch access');
      compilerabort(inconsistent);
      end
    else
      if inv then c := condmap[invert[brinst]]
      else c := condmap[brinst];

  gen2(lastnode, buildinst(cset, false, false), key,
                 settemp(0, cond_oprnd(c)));

end {cond};

{ These are awful in that a top level compare can be collapsed into a
  single csel ... 
}

procedure createfalsex;

{ Create false constant prior to conversion of comparison to value.

  We have to save it now because we have an upcoming comparison.
}


  begin {createfalsex}
    settargetorreg;
    gensimplemove(lastnode, settemp(len, intconst_oprnd(0)), key);
    savekey(key);
  end {createfalsex} ;


procedure createtruex;

{ Create the value 'true'.
}


  begin {createtruex}
    addressdst(left);
    setallfields(left);
    gensimplemove(lastnode, settemp(len, intconst_oprnd(1)), key);
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

    { Dump pseudocode into macfile but don't gen code.
    }

    if switcheverplus[test] and not switcheverplus[outputmacro] then
      begin
      if pseudoinst.op = blockentry then
        begin
        writeln(macfile, '#');
        write(macfile, '# '); writeprocname(blockref); writeln(macfile);
        write(macfile, '#');
        end;
      dumppseudo(macfile);
      exit;
      end;

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
      condf: cond(true);
      condt: cond(false);
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
      addint, addptr:
        integerarithmetic(add);
      subint, subptr:
        integerarithmetic(sub);
      mulint: integermultiply;
      stddivint: divintx;
      divint: divintx;
      getquo: getquox;
      getrem: getremx;
      shiftlint: shiftintx(false);
      shiftrint: shiftintx(true);
      negint: unaryint(neg);
      incint: incdec(add);
      decint: incdec(sub);
      orint: logicalarithmetic(orinst);
      andint: logicalarithmetic(andinst);
      xorint: logicalarithmetic(eor);
      compint: compintx;
      compbool: compboolx;
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
      pshlitint, pshlitptr, pshlitfptr: pshlitintptrx;
{
      pshfptr: pshfptrx;
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
        dumppseudo(macfile);
        if switcheverplus[test] or switcheverplus[outputmacro] then
          closec;
        write('Not yet implemented');
        compilerabort(inconsistent);
        halt(); { compilerabort doesn't abort if test is enabled }
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
{
writeln(macfile, 'lastkey: ', lastkey, ' refcount: ', keytable[lastkey].refcount, ' keymark: ', context[contextsp].keymark);
}
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

    condmap[beq] := eq;     condmap[bne] := ne;     condmap[blt] := lt;
    condmap[bgt] := gt;     condmap[bge] := ge;     condmap[ble] := le;
    condmap[blo] := lo;     condmap[bhi] := hi;     condmap[bls] := ls;
    condmap[bhs] := hs;     condmap[bvs] := vs;     condmap[bvc] := vc;

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
