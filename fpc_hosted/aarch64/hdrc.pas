{[b+,l+]}

{ NOTICE OF COPYRIGHT AND OWNERSHIP OF SOFTWARE:

  Copyright (C) 1986 Oregon Software, Inc.
  All Rights Reserved.

  This program is the property of Oregon Software.  The program or
  parts of it may be copied and used only as provided under a signed
  license agreement with Oregon Software.  Any support purchased from 
  Oregon Software does not apply to user-modified programs.  All copies 
  of this program must display this notice and all copyright notices. 

  AArch64 common code generator definitions.
}

unit hdrc;

interface

uses config, hdr, t_c;

const

  {AARCH64 general register assignments}

  maxreg = 32;

  noreg = -1;
  sp = 32; {hardware stack pointer fake register}
  zero = 31; {sp encodes to this, too, but we'll differentiate}
  link = 30;
  fp = 29;
  gp = 28;
  sl = 27; {if needed for uplevel refs}
  ip0 = 16; {ip0 and ip1 reserved for linker}
  ip1 = 17;
  pr = 18; {platform register, can't touch}
  sr = 8; {structred return register}

  {possible data length values}

  bitsperbyte = 8; {packing factor}
  byte = 1; 
  short = 2;
  word = 4;
  long = 8;
  quad = 16;

  { front end puts out labels greater than zero }
  bsslabel = 0;

  maxblockslow = lowcodeblocks; {number of blocks allocated in global area}

  undefinedaddr = 1; {impossible address flag}
  loopdepth = 10; { maximum number of nested loops optimized }

  {special keys for building internal loops}

  loopsrc = - 3; {source descriptor}
  loopsrc1 = - 4; {second source descriptor (for three operand loops)}
  loopdst = - 5; {destination descriptor}
  loopcount = - 6; {loop counter descriptor}

{ File variable status bits
}
  lazybit = 0; {buffer not lazy}
  eofbit = 1; {end of file true}
  eolnbit = 2; {end of line true}

{ constant definitions concerning peephole optimizations
}
  peeping = true; { enable statistical collection of peephole optimizers }
  maxpeephole = 16; { number of discrete peephole optimizations }

  maxerrs = 5;

  max_oprnds = 4;

type

  regtypes = (general, floating);

  oprnd_range = 0 .. max_oprnds;

  regindex = -1..maxreg; {possible register values}

  regmask = packed array [regindex] of boolean;

  unsigned = 0..maxusint; {unsigned integer}
  longint = -maxint..maxint;
  uns_byte = 0..maxusbyte;
  uns_word = 0..maxusword;
  uns_long = 0..maxusint;

  string2 = packed array [1..2] of char;
  string4 = packed array [1..4] of char;
  string8 = packed array [1..8] of char;

  namestring = packed array [1..maxnamestring] of char;
  namestringindex = 0..maxnamestring;

  contextindex = 0..contextdepth; {used as index for context stack}
  bumparray = packed array [regindex] of boolean;

  labelindex = 0..labeltablesize; {index into the label table}

  tempindex = 0..keysize; {legal indices for a temp}
  forindex = 0..fordepth;


{ Support library routines
}

  libroutines = (
    first_call,  {must be first -- this one means nothing}
    libarctan,
    libbreak,
    libcap, { Modula-2 CAP function }
    libcasetrap,
    libcexit,
    libmexit, { Modula-2 only -- termination pt of main body }
    libcidiv,
    libcinit,
    libminit, { Modula-2 only -- Initialize main body }
    libclose,
    libcloseinrange,
    libconnect,
    libcopy,
    libcos,
    libcvtdr, { Pascal only -- convert double to single }
    libcvtrd, { Pascal only -- convert single to double }
    libdadd,
    libdarctan,
    libdcos,
    libddiv,
    libdefinebuf,
    libdelete,
    libdeletestr,
    libdeql,
    libdexp,
    libdf, { C only -- convert double to single }
    libdfloat, { double signed float }
    libdfloat_uns, { Pascal -- double unsigned float }
    libdgtr,
    libdispose,
    libdln,
    libdlss,
    libdmult,
    libdround,
    libdsin,
    libdsqr,
    libdsqrt,
    libdsub,
    libdswap,
    libdtime,
    libdtrunc,
    libdufloat, { C only -- double unsigned float }
    libexit,
    libexp,
    libfadd,
    libfcmp,
    libfd, { C only -- convert single to double }
    libfdiv,
    libffloat, { single signed float }
    libffloat_uns, { Pascal -- single unsigned float }
    libfiletrap,
    libfmult,
    libfree,
    libfround,
    libfsqr,
    libfsub,
    libftrunc,
    libfufloat, { C only -- single unsigned float }
    libget,
    libhalt, { Modula-2 HALT function }
    libidiv,
    libimult,
    libinitialize,
    libinsert,
    libioerror,
    libiostatus,
    libiotransfer, { Modula-2 IOTRANSFER function }
    libln,
    libmcopy1, { Modula-2 open array copy -- 1 byte case }
    libmcopy2, { Modula-2 open array copy -- 2 byte case }
    libmcopy4, { Modula-2 open array copy -- 4 byte case }
    libmcopymd,{ Modula-2 open array copy -- general case }
    libnew,
    libnewprocess, { Modula-2 NEWPROCESS function }
    libnoioerror,
    libpack,
    libpage,
    libpageo,
    libpointertrap,
    libpos,
    libprofilerdump,
    libprofilerinit,
    libprofilerstmt,
    libput,
    librangetrap,
    libreadchar,
    libreadchari,
    libreaddouble,
    libreaddoublei,
    libreadint,
    libreadinti,
    libreadln,
    libreadlni,
    libreadreal,
    libreadreali,
    libreadstring,
    libreadstringi,
    libreadxstring,
    libreadxstringi,
    librealloc,
    librename,
    libreset,
    librewrite,
    libscan, { Modula-2 SCAN function }
    libseek,
    libsin,
    libsqrt,
    libstrint0,
    libstrint1,
    libstrreal0,
    libstrreal1,
    libstrreal2,
    libstrdouble0,
    libstrdouble1,
    libstrdouble2,
    libstrovr,
    libsubscripttrap,
    libtell,
    libtime,
    libtransfer, { Modula-2 TRANSFER function }
    libunpack,
    libunsdiv,
    libunsmod,
    libunsmult,
    libvaldouble,
    libvalint,
    libvalreal,
    libwritebool,
    libwriteboolo,
    libwritechar,
    libwritecharo,
    libwritedouble1,
    libwritedouble1o,
    libwritedouble2,
    libwritedouble2o,
    libwriteint,
    libwriteinto,
    libwriteln,
    libwritelno,
    libwritereal1,
    libwritereal1o,
    libwritereal2,
    libwritereal2o,
    libwritestring,
    libwritestringo,
    libdebugger_init,
    libdebugger_entry,
    libdebugger_exit,
    libdebugger_goto,
    libdebugger_step, { Pascal Vdos pic only -- call for single step }
    libdbgtrap,
    libcmemcpy,
    last_call  { must be last -- this one means nothing }
  );

  { AARCH64 instruction definitions.  These include aliases supported by
    standard assembler/disassemblers which makes reading the generated
    code easier.
  }

  insts = (noinst, nop,

  {basic arithmetic instructions}
  first_a, add, sub, mul, madd, msub, sdiv, udiv, cmp, cmn, neg, last_a,

  {bit manipulation}
  cinv, mvn,
  {move instructions}

  first_mov, movz, mov, movn, last_mov,

  {load/store instruction}
  first_ls, ldr, ldrb, ldrh, ldrw, ldrsb, ldrsh, ldrsw, ldp,
  str, strb, strh, stp, last_ls, adrp,

  {branch instructions}

  first_b, b, bl, beq, bne, blt, bgt, ble, bge, bhi, bhs, blo, bls,
  bvc, bvs, cbz, cbnz, last_b,

  {miscellaneous instructions}

  lslinst, asrinst, lsrinst,

  ret);

  insttype = packed record
    inst: insts;
    sf: boolean; {true 64 bits, false 32 bits }
    s: boolean; {true sets flags for conditional branches }
  end;

  oprnd_modes = (nomode, register, fpregister, tworeg, shift_reg, extend_reg,
                 immediate, immediate16, relative, pre_index, post_index, signed_offset,
                 unsigned_offset, reg_offset, literal, labeltarget, proccall,
                 libcall, cond);

  conds = (al, eq, ne, gt, lt, le, ge, hi, hs, lo, ls, cc, cs, mi, pl,
           vs, vc);

  reg_extends = (xtb, xth, xtw, xtx);
  reg_shifts = (lsl, lsr, asr);

  imm2 = 0..3;
  imm3 = 0..7;
  imm6 = 0..63;
  imm12 = 0..4095;
  imm16 = 0..65535;

  oprndtype = packed record
    reg: regindex;
    reg2: regindex; {extra register if indexed & bitindexed}
    case mode: oprnd_modes of
      shift_reg: (reg_shift: reg_shifts;
                  shift_amount: imm6);
      extend_reg: (reg_extend: reg_extends;
                   extend_shift: imm3;
                   extend_signed: boolean); 
      immediate: (imm_value: imm12;
                  imm_shift: boolean);
      immediate16: (imm16_value: imm16;
                  imm16_shift: 0..48);
      pre_index, post_index, signed_offset, unsigned_offset: (index: integer);
      reg_offset: (shift: imm2; extend: reg_extends; signed: boolean);
      literal: (literal: integer);
      cond: (condition: conds);
      labeltarget: (labelno: unsigned; lowbits: boolean);
      proccall: (proclabelno: unsigned; entry_offset: integer);
      libcall: (libroutine: libroutines);
    end;

{ The instruction node ("node") is used to hold instructions generated and
  book-keeping data needed to keep track addressing as the stack is
  modified.  The actual code is emitted from the data in this node by
  "putmac" or "putobj".

  See the Program Logic Manual for an explanation of the uses of these fields
}

  nodeptr = ^node; {used to reference the node contents}
  nodekinds = (instnode, oprndnode, labelnode, labeldeltanode, errornode, stmtnode,
               datanode, labelrefnode, proclabelnode, bssnode);

  operandrange = 0..4; {number of possible operands per inst}
  datarange = 0..63; {number of bytes or bits in possible operands}

  node =
    packed record
      nextnode, prevnode: nodeptr;
      tempcount: keyindex; {number of temps below this item. only valid if
                            branch node or stack dependant operand node}
      case kind: nodekinds of
        instnode:
          (inst: insttype;
           labeled: boolean; {true if a label attached here}
           oprnd_cnt: 0..4;
           oprnds: array [1..max_oprnds] of oprndtype);
        labelnode:
          (labelno: unsigned;
           stackdepth: integer; {used for aligning sp at branch}
           brnodelink: nodeptr; {used by mergebranchtails} );
        labelrefnode:
          (labelefno: unsigned;
           lowbits: boolean; );
        labeldeltanode:
          (tablebase: integer; {label number of base of casetable}
           targetlabel: integer; {label number of case branch target}
          );
        errornode: (errorno: integer; {error number} );
        proclabelnode: (proclabel: unsigned);
        datanode: (data: unsigned {long word constant data} );
        stmtnode:
          (stmtno: unsigned; {statement number (for debugger)}
           sourceline: unsigned; {line number (for walkback)}
           filename: stringtableindex; {stringfile index of file name} );
        bssnode: (bsssize: addressrange; {for globals} );
    end;


{ Operand description data.

  As operations are passed from travrs the operands are represented by
  "keys".  Book-keeping of used keys is done in travrs to make sure that
  invalid keys are re-used at the proper time.

  Within the code generator, the data about each key is kept in a keytable,
  which in indexed by key number.  In addition to keys assigned by travrs
  there are temporary keys (negative) which are used internally by the
  code generator.  Runtime temporary locations are assigned keys from the
  top of the keytable by code, while travrs assigns them from the bottom.

  Each key contains data to describe and locate the actual operand.

  See the Program Logic Manual for further description of keys and their
  uses.
}

type
  accesstype = (noaccess, branchaccess, valueaccess);

  { Linked list used to track all saves to a particular stack entry in
    the keytable.

    Register params caused a new case to arise in the pseudocode where
    a register that's not a permanent regtemp can be the destination of a
    move.  If the register is killed at some point, future code has to
    refer to a stack copy of the contents.  The register can be saved in
    multiple contexts since parameters can be assigned to, which is untrue
    of registers allocated as the result of a computation.  Thus we need
    to track all such saves so that if the stack copy is never reloaded, we
    can delete it and all saves to it.
  }

  tempsaveptr = ^tempsave;
  tempsave =
    record
      nextsave: tempsaveptr;
      first, last: nodeptr;
    end;

  keyx =
    packed record
      refcount, copycount: unsigned; {reference info from pseudocode}
      len: unsigned; {length of this operand, from pseudocode}
      copylink: keyindex; {node we copied, if created by copyaccess op}
      access: accesstype; {type of entry}
      properreg: keyindex; {reference to non-volatile storage of oprnd reg}
      properreg2: keyindex; {reference to non-volatile storage of oprnd reg2}
      tempflag: boolean; {if a stack temp, set true when referenced}
      validtemp: boolean; {if a stack temp, set true when allocated}
      regsaved: boolean; {true if oprnd reg has been saved (in
                          keytable[properreg])}
      reg2saved: boolean; {true if oprnd reg2 has been saved (in
                          keytable[properreg2])}
      regvalid: boolean; {true if oprnd reg field is valid, set false when
                          register is stepped on}
      reg2valid: boolean; {true if oprnd reg2 field is valid, set false when
                          register is stepped on}
      packedaccess: boolean; {true if length is bits, not bytes, and a
                              packed field is being accessed}
      joinreg: boolean; {true if regvalid should be set false upon next
                         joinlabel pseudoop}
      joinreg2: boolean; {true if reg2valid should be set false upon next
                         joinlabel pseudoop}
      signed: boolean; {true if operand contains signed data}
      signlimit: addressrange; {size for which this key is still signed}
      knownword: boolean; {true if word or long instruction will work
                           here}
      first: nodeptr; {set to first node of stream which
                       created value described in this record}
      last: nodeptr; {set to the last node of the stream which
                      created this value}
      oprnd: oprndtype; {the machine description of the operand}
      brinst: insts; {use this instruction for 'true' branch}
      saves: tempsaveptr; {list of save operations if a stack temp}
    end;

  keytabletype = array [lowesttemp..keysize] of keyx;

{ As branches are generated, branch link elements are set up to keep track of
  all branches which point to the same node.  This is used in branch tail
  merging.
}

  brlinkptr = ^brlink; {to link them together}
  brlink =
    record {holds data on branch-label linkage}
      nextbr: brlinkptr; {next branch entry}
      l: integer; {label referenced}
      n: nodeptr {node for that label}
    end;


{ Used in loopstack.
}
  regstate =
    packed array [regindex] of
      packed record
        stackcopy: keyindex; {descriptor of saved copy of register}
        reload: nodeptr; { index of instruction that restored copy }
        active: boolean; {set true if active at loop entry}
        used: boolean; {set true if used within loop}
        killed: boolean; {set true if killed within loop}
      end;

  loopindex = 0..loopdepth; {used as index for loop stack}

  dataset = set of datarange; {bytes of data to be operated upon}

  { Error messages in putcode.
  }
  puterrortype = (endofnodes);

  { Open array data structure.  This is used by Modula2 to pass information
    from openarrayx in genblk to blockcodex in code.
  }
  openarraynodeptr = ^openarraynode;

  openarraynode =
    record
      nextnode: openarraynodeptr;
      dimensions: integer;
      element_length: integer;
      param_offset: integer;
    end;

  bytesize = 0..255;
  section = (codesect, diagsect, datasect); { code sections }
  supportrange = integer;

{ types to support formatted macro output:
}
  longname = packed array [1..max_string_len] of char;
  columnrange = 0..120;

  codeproctableentry =
    record
      proclabelnode: nodeptr;
    end;
var

  nextpseudofile: integer; {next byte in the current block of pseudofile}

  nextlabel: labelindex; {next available entry in the label table}

  labelnextnode: boolean; {Mark the next node as labeled}

  firstnode: nodeptr; {first node allocated by new}
  lastnode: nodeptr; {last node allocated by new}

  level: levelindex; {current block nesting levels}

  formatcount: integer; {number of field-width expressions in writearg}

  fileoffset: integer; {0 if default file for read/write, 2 if specified}

  labeltable: array [labelindex] of
      record {links label numbers to nodes, plus useful data}
        nodelink: nodeptr; {node being labeled}
        labno: integer; {label number}
        stackdepth: integer; {stack depth at this label}
        address: addressrange; {actual address of this label}
      end;

  lastsaved, savereginst, fpsavereginst, stuffreginst: nodeptr;
  blocklabelnode, linkentryinst, setupinst: nodeptr;

  blockusesframe: boolean; {set to true in blockentryx if frame is used}

  paramsize, blksize: addressrange;

  stackcounter: keyindex; {key describing top of runtime stack}
  stackbase: keyindex; {key describing the base of the runtime stack}
  stackoffset, maxstackoffset: integer;

  registers: array [regindex] of integer;
  fpregisters: array [regindex] of integer;

  regused, fpregused: array [regindex] of boolean; {set if currently used}

  lastreg, lastfpreg: regindex; {last registers available for
                                 scratch use in this block}

  firstreg, firstfpreg: regindex; {first registers currently available for scratch
                                   use in this block}
  lastkey: keyindex; {last key used by travrs at the moment}

  settarget: keyindex; {target of a set insert operation}

  filestkcnt: integer; {stackcounter value at point of setfile op}
  filenamed: boolean; {file was specified for read/write}

  adjustdelay: boolean; {if set, do not get rid of temps}
  firstsetinsert: boolean; {true if next setinsert pseudoop is first in line}
  popflag: boolean; {set true if current loop is popping stack}
  loopupflag: boolean; {set true if current loop is looping up}
  loopdownflag: boolean; {set true if current loop is looping down}
  loopdatalength: addressrange; {number of bytes being moved}

  len: integer; {length from current pseudo-instruction}
  left, right: keyindex; {oprnds[1] and oprnds[2] (left and right) from
                          pseudoinst}

  key: keyindex; {result key from pseudoinst}
  target: keyindex; {target value, often a key, from pseudoinst}
  tempkey: keyindex; {current temp key <0}

  firstbr: brlinkptr; {beginning of branch link data chain}

  forstack: packed array [forindex] of
      record
        forkey: keyindex; {keytable entry of index}
        firstclear: boolean; {set if next clear operation is first one (used
                              for special register handling done to optimize
                              for loop code template)}
        originalreg: regindex; {the register which contains the running value
                                of the index. Bottom of loop must restore if
                                intervening code has eaten the original
                                contents of this register}
        savedlen: datarange; { original length of index variable }
        litinitial: boolean; {set true if initial value is constant}
        savedoprnd: oprndtype;
        initval: integer; {initial value, if constant}
      end;

  forsp: 0..fordepth; {top of forstack}

  {context stack, tracks the context data from travrs}

  context: array [contextindex] of
      record
        keymark: keyindex; {first key entry for this context block}
        savedstackoffset: addressrange;
        savedstackcounter: keyindex;
        lastbranch: nodeptr; {set at each out-of-line branch}
        first, last: nodeptr; {first and last nodes for this context block}
        bump: bumparray;
        { bump[r] is set true if dregisters[r] > 0 at context entry}
        fpbump: bumparray; { floating-point regs }
        clearflag: boolean; {set at first clearlabel pseudoop}
      end;

  contextsp: contextindex; {top of mark stack (context pointer)}

  stringbase: addressrange; {start of string and constant data}
  constbase: addressrange; {start of constants for the current procedure}

  { Loop stack, used to restore registers at the bottom of loops }

  loopsp: loopindex; {top of loop stack}
  loopoverflow: integer; {keep track of loops we don't optimize}
  loopstack: array [loopindex] of
      record
        thecontext: contextindex;
        savelastbranch: nodeptr; { value of lastbranch upon entry }
        savefirstnode: nodeptr; { value of firstnode upon entry }
        regbump: bumparray;
        fpbump: bumparray;
        regstate: regstate;
        fpregstate: regstate;
      end;

  oktostuff: boolean; {set false if register stuffing not allowed}

  invert, fpinvert: array [insts] of insts; {for inverting sense of
                                                   branches}

  keytable: keytabletype; {contains operand data}

  dontchangevalue: integer; { > 0, don't allow changevalue to work!}

  mainsymbolindex: integer; {index of main prog data in the symbol file}
  firststmt: integer; {first statement in this procedure}
  lineoffset: integer; {difference between linenumber and file line number}

  pcerrortable: array [1..maxerrs] of puterrortype; { table of error codes }
  lineerrors: 0..maxerrs; {counter of errors in current line}

  peep: array[0..maxpeephole] of integer; {counts number of times each
        peephole optimization is applied; peep[0] counts total byte savings}

  { If "use_preferred_key" is true, then some of the lower code generator
    routines will use the key stored in "preferred_key" if possible.  This
    is similar to "target" but it is used in places where the front end
    does not give us a target.
  }
  use_preferred_key: boolean;
  preferred_key: keyindex;

  { Set 'paramlist_started' to true once the beginning of parameter list is
    found. The beginning is determined by a makeroom or a stacktarget. If
    stacktarget starts a parameter list then it will call saveactivekeys.
    This is needed because the front end is not generating makerooms for
    library calls.
  }
  paramlist_started: boolean;
  regparam_target: keyindex;

  settargetused: boolean;  {set in setarithmetic and checked in movstruct to
                            prevent redundant set moves. }


  { Modula2 specific variables }

  openarray_base: openarraynodeptr; { pointer to linked list of open array
                                      parameters. }
  main_import_offset: integer; {offset to add to main's import table entry}

  totalputerr: integer; { total putmac errors in program }
  testing: boolean; { true if /test AND /macro }
  column: columnrange;

  found: boolean; { general boolean used to control search loops }

  macfile: text; {receives macro assembler image}

  codeproctable: array [0..proctablesize] of codeproctableentry;

implementation

end.
