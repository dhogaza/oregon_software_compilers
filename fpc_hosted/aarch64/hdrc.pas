{[b+,l+]}

{ NOTICE OF COPYRIGHT AND OWNERSHIP OF SOFTWARE:

  Copyright (C) 1986 Oregon Software, Inc.
  All Rights Reserved.

  This program is the property of Oregon Software.  The program or
  parts of it may be copied and used only as provided under a signed
  license agreement with Oregon Software.  Any support purchased from 
  Oregon Software does not apply to user-modified programs.  All copies 
  of this program must display this notice and all copyright notices. 


  Release version: 0045  Level: 1
  Processor: ~processor~
  System: ~system~
  Flavor: ~flavor~
  MC68000 common code generator definitions.
 Last modified by KRIS on 21-Nov-1990 15:28:33
 Purpose:
Update release version for PC-VV0-GS0 at 2.3.0.1
}

unit hdrc;

interface

uses config, hdr, t_c;

const
  nodesperblock = codemaxnodeinblock; {nodes per physical file block - 1}

  {AARCH64 general register assignments}

  noreg = -1;
  sp = 32; {hardware stack pointer fake register}
  zero = 31; {sp encodes to this, too, but we'll differentiate}
  link = 30;
  fp = 29;
  ip0 = 16; {ip0 and ip1 reserved for linker}
  ip1 = 17;
  pr = 18; {platform register, can't touch}
  sr = 8; {structred return register}

  {possible data length values}

  bitsperbyte = 8; {packing factor}
  byte = 1; {generates inst.b}
  word = 2; {generates inst.w}
  long = 4; {generates inst.l}
  quad = 8; {for double reals}

  maxblockslow = lowcodeblocks; {number of blocks allocated in global area}

  undefinedaddr = 1; {impossible address flag}
  loopdepth = 10; { maximum number of nested loops optimized }

{ File variable status bits
}
  lazybit = 0; {buffer not lazy}
  eofbit = 1; {end of file true}
  eolnbit = 2; {end of line true}

{ constant definitions concerning peephole optimizations
}
  peeping = true; { enable statistical collection of peephole optimizers }
  maxpeephole = 16; { number of discrete peephole optimizations }
  diag_error = 0; {begin error data}
  diag_proc_p2 = 1; {begin procedure name for Pascal2}
  diag_func_p2 = 2; {begin function name for Pascal2}
  diag_prog_p2 = 3; {begin program name for Pascal2}
  diag_proc_m2 = 4; {begin procedure name for Modula2}
  diag_mod_m2  = 5; {begin function name for Modula2}
  diag_proc_c  = 6; {begin procedure name for C}

  maxerrs = 5;

{ Distinguished values of relocation used in Pascal
}
  unknown = 0; {unknown global relocation}
  global_section = - 1; {the global area}
  own_section = - 2; {the own area}
  min_section = - 2; {lowest of the above}

  maxstuffnodes = 39; {maximum number of nodes needed to stuff registers}
  prologuelength = 25; {maximum number of nodes in procedure prologue}

{ tab stops for macro file:
}
  opcolumn = 10;
  opndcolumn = 19;
  procnamecolumn = 27;
  nodecolumn = 45;

type

  regindex = -1..32; {possible register values}

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
    last_call  { must be last -- this one means nothing }
  );

  { AARCH64 instruction definitions }

  insttype = (none);

  oprnd_types = (dest_oprnd, oprnd2, ldstr_oprnd);
  oprnd2_modes = (register, shiftreg, extendreg, immediate, relative);
  ldstr_oprnd_modes = (ldstr_pre_index, ldstr_post_index, ldstr_immediate, ldstr_register, ldstr_literal);

  oprnd2_type = packed record
    reg: regindex;
    case oprnd2_mode: oprnd2_modes of
      shiftreg: (reg2: regindex);
    end;

  ldstr_oprnd_type = packed record
    basereg: regindex;
    case ldstr_oprnd_mode: ldstr_oprnd_modes of
      ldstr_pre_index, ldstr_post_index: (index: -128..127);
    end;

  oprnd_type =
    packed record
      case typ: oprnd_types of
        dest_oprnd, oprnd2: (oprn2: oprnd2_type);
	ldstr_oprnd: (ldstr_oprnd: ldstr_oprnd_type);
      end;

  pseudoset = set of pseudoop;

{ The instruction node ("node") is used to hold instructions generated and
  book-keeping data needed to keep track addressing as the stack is
  modified.  The actual code is emitted from the data in this node by
  "putmac" or "putobj".

  See the Program Logic Manual for an explanation of the uses of these fields
}

  nodeindex = 0..cnodetablesize; {used to reference a node by number}
  nodeptr = ^node; {used to reference the node contents}
  nodekinds = (instnode, oprndnode, labelnode, labeldeltanode, errornode, stmtref, datanode);

  operandrange = 0..4; {number of possible operands per inst}
  datarange = 0..63; {number of bytes or bits in possible operands}

  node =
    packed record
      tempcount: keyindex; {number of temps below this item. only valid if
                            branch node or stack dependant operand node}
      case kind: nodekinds of
        instnode:
          (inst: insttype;
           oprndcount: operandrange;
           labelled: boolean; {true if a label attached here}
           oprndlength: datarange; {number of bytes we operate on} );
        oprndnode:
          (oprnd: oprnd_type; {the actual operand, described above} );
        labelnode:
          (labelno: integer;
           stackdepth: integer; {used for aligning sp at branch}
           brnodelink: nodeindex; {used by mergebranchtails} );
        labeldeltanode:
          (tablebase: integer; {label number of base of casetable}
           targetlabel: integer; {label number of case branch target}
          );
        errornode: (errorno: integer; {error number} );
        datanode: (data: unsigned {long word constant data} );
    end;

  { The following are used to map nodes onto virtual memory blocks}

  nodeblockptr = ^nodeblock; {a block of nodes}

  nodeblock =
    record {holds the actual node data}
      case boolean of
        false: (physical: doublediskblock);
        true: (logical: array [0..nodesperblock] of node);
    end;

  blockmap =
    record {used to keep track of virtual blocks in memory}
      blkno: 0..128; {block index of data in buffer^}
      written: boolean; {block has been changed and must be written}
      lowblock: boolean; {this block allocated in global area}
      buffer: nodeblockptr; {buffer for a data block}
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

  keyx =
    packed record
      refcount, copycount: 0..maxrefcount; {reference info from pseudocode}
      len: integer; {length of this operand, from pseudocode}
      copylink: keyindex; {node we copied, if created by copyaccess op}
      access: accesstype; {type of entry}
      properreg: keyindex; {reference to non-volatile storage of oprnd.r}
      properindxr: keyindex; {ditto for oprnd.indxr}
      tempflag: boolean; {if a stack temp, set true when referenced}
      validtemp: boolean; {if a stack temp, set true when allocated}
      regsaved: boolean; {true if oprnd.r has been saved (in
                          keytable[properreg])}
      indxrsaved: boolean; {ditto for oprnd.indxr}
      regvalid: boolean; {true if oprnd.r field is valid, set false when
                          register is stepped on}
      indxrvalid: boolean; {ditto oprnd.indxr, not indxrvalid ->
                            indxrsaved}
      packedaccess: boolean; {true if length is bits, not bytes, and a
                              packed field is being accessed}
      joinreg: boolean; {true if regvalid should be set false upon next
                         joinlabel pseudoop}
      joinindxr: boolean; {ditto indxrvalid}
      signed: boolean; {true if operand contains signed data}
      signlimit: addressrange; {size for which this key is still signed}
      knowneven: boolean; {true if word or long instruction will work
                           here}
      high_word_dirty: boolean; {true if register contains the result of
                                 a 16-bit divide inst.}
      instmark: nodeindex; {set to first instruction of stream which
                            created value described in this record}
      oprnd: oprnd_type; {the machine description of the operand}
      brinst: insttype; {use this instruction for 'true' branch}
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
      n: nodeindex {node for that label}
    end;


{ Used in loopstack.
}
  regstate =
    packed array [regindex] of
      packed record
        stackcopy: keyindex; {descriptor of saved copy of register}
        reload: nodeindex; { index of instruction that restored copy }
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
  linknametype = packed array [1..maxprocnamelen] of char;

  fixupptr = ^fixupnode;
  fixuptype = (fixuplabel, fixupproc, fixupabs, fixupesdid);
  fixupnode =
    record
      fixuplink: fixupptr;
      fixupfileloc: addressrange; { location in relfile }
      fixupobjpc: addressrange;
      fixupaddr: addressrange; { relative address when found }
      fixuplen: 2..4; { word or long fixup -- for 68020 }
      case fixupkind: fixuptype of
        fixuplabel: (fixuplabno: integer);
        fixupproc: (fixupprocno: integer);
        fixupabs: ();
        fixupesdid: (vartabindex: integer); { index into vartable }
    end;

  esdrange = firstesd..lastesd;

  esdtype = (esdsupport, esdexternal, esdentry, esdload, esdglobal,
	     esddiag, esdcodestart, esdcodesize,
             esdcommon, esdbegin, esduse, esddefine, esdshrvar);

  esdtabentry =
    packed record
      case esdkind: esdtype of
        esdsupport: (suppno: libroutines); { support number }
        esdexternal, esdentry:
          (exproc: proctableindex); { index to proctable }
        esduse, esddefine: (vartabindex: integer); { index into vartable }
        esdload: (sect: section);
        esdglobal, esdcommon, esdbegin: (glbsize: addressrange);
        esddiag, esdcodestart, esdcodesize: ();
    end;

{ types to support formatted macro output:
}
  longname = packed array [1..max_string_len] of char;
  columnrange = 0..120;

  bits = 0..16; {counts bits in a word}

  objfileblock = 0..255;
  objfiletype = file of objfileblock;

  tempreltype = (externrel, forwardrel, backwardrel, textrel,
                 nonlocalrel, supportrel, commonrel, stackrel);

  tempreloffset = 0..5000; {max of proctablesize, maxsupport, maxnonlocal}

  tempnegoffset = 0..15; {offset in words for cross-level procedure calls}

  tempreloc = packed record
                treltype: tempreltype;
                treloffset: tempreloffset;
                tnegoffset: tempnegoffset;
                trellocn: addressrange;
              end;

  relfileblock = 0..maxusword;
  relfiletype = file of relfileblock;

  worddiskblock = packed array [0..worddiskbufsize] of 0..maxusword;
  wordstream = file of worddiskblock;

  { Putcode object types.
  }
  objtypes =
    (objnorm, { normal code word }
     objext, { external symbol reference }
     objforw, { forward ref--to be fixed up }
     objsup, { support call }
     objcom, { common reference }
     objoff, { offset -- can not be start of relocation group }
     objpic, { start of long pic relocation }
     objign, { word containing linker commands which usually follows
               objpic -- ignore for /test listing }
     objlong { reserve a longword -- must not be split across records }
    );
  objtypesx = array [objtypes] of 0..4;

var

  nextpseudofile: integer; {next byte in the current block of pseudofile}

  nokeydata: pseudoset; {pseudoops without key, length, refcount or copycount}
  oneoperand: pseudoset; {pseudoops with only one operand}

  nextlabel: labelindex; {next available entry in the label table}

  labelnextnode: boolean; {Mark the next node as labeled}

  lastnode: nodeindex; {last valid node (locally). New nodes go here}

  level: levelindex; {current block nesting levels}

  formatcount: integer; {number of field-width expressions in writearg}

  fileoffset: integer; {0 if default file for read/write, 2 if specified}

  labeltable: array [labelindex] of
      record {links label numbers to nodes, plus useful data}
        nodelink: nodeindex; {node being labeled}
        labno: integer; {label number}
        stackdepth: integer; {stack depth at this label}
        address: addressrange; {actual address of this label}
      end;

  lastsaved, savereginst, fpsavereginst, stuffreginst: nodeindex;
  blocklabelnode, linkentryinst, setupinst: nodeindex;
  lastptr: nodeptr;

  blockusesframe: boolean; {set to true in blockentryx if frame is used}

  paramsize, blksize: addressrange;

  aregisters: array [regindex] of integer; {usage count of address registers}
  dregisters: array [regindex] of integer; {usage count of data registers}
  fpregisters: array [regindex] of integer; {usage count of floating-point
                                             registers}
  stackcounter: keyindex; {key describing top of runtime stack}
  stackoffset: integer; {depth of runtime stack in bytes}
  aregused, dregused, fpregused: array [regindex] of boolean; {set if currently
                                                               used}

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
  piecesize: addressrange; {length of each data reference within structured
                            move}

  lastdreg, lastareg, lastfpreg: regindex; {last registers available for
                                            scratch use in this block}

  qualifiedinsts, {have ".length" attribute}
   shiftinsts, {lsl, etc}
   shortinsts, {instructions which make immediate operands cheap}
   immedinsts, monadicinsts, {subset of 1 operand instructions}
   dyadicinsts: set of insttype; {subset of 2 operand instructions}
  branches, fpbranches: set of insttype; {initialized to contain all branches}
  bitfieldinsts: set of insttype; {initialized to contain all bit field insts}

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
        nonvolatile: boolean; {must save index in "real" var}
        globaldreg: boolean; {non-volatile and was not a global dreg}
        savedlen: datarange; { original length of index variable }
        litinitial: boolean; {set true if initial value is constant}
        computedaddress: boolean; {we needed to address beyond 32K, so we used
                                   an A register to hold the address of the
                                   index variable}
        savedaddress: keyindex; {where we saved the A register}
        savedoprnd: oprnd_type;
        initval: integer; {initial value, if constant}
      end;

  forsp: 0..fordepth; {top of forstack}

  {context stack, tracks the context data from travrs}

  context: packed array [contextindex] of
      packed record
        clearflag: boolean; {set at first clearlabel pseudoop}
        keymark: keyindex; {first key entry for this context block}
        dbump: bumparray;
        { dbump[r] is set true if dregisters[r] > 0 at context entry}
        abump: bumparray;
        fpbump: bumparray; { floating-point regs }
        lastbranch: nodeindex; {set at each out-of-line branch}
        firstnode: nodeindex; {first instruction for this context block}
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
        savelastbranch: nodeindex; { value of lastbranch upon entry }
        savefirstnode: nodeindex; { value of firstnode upon entry }
        abump: bumparray;
        dbump: bumparray;
        fpbump: bumparray;
        aregstate: regstate;
        dregstate: regstate;
        fpregstate: regstate;
      end;

  maxstackdepth: addressrange; {maximum stack depth within program}

  oktostuff: boolean; {set false if register stuffing not allowed}

  keytable: keytabletype; {contains operand data}

  dontchangevalue: integer; { > 0, don't allow changevalue to work!}

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

  settargetused: boolean;  {set in setarithmetic and checked in movstruct to
                            prevent redundant set moves. }


  {virtual memory system variables}

  bignodetable: array [0..bigcnodetablesize] of node;
  lastblocksin: integer; {highest block actually used (auto sizing)}
  thrashing: boolean; {true if not all nodes fit in core}

  blocksin: array [1..cmaxblocksin] of blockmap; {map of blocks in core}

  blockslow: array [1..maxblockslow] of nodeblock; {blocks in global storage}

  { Modula2 specific variables }

  openarray_base: openarraynodeptr; { pointer to linked list of open array
                                      parameters. }
  main_import_offset: integer; {offset to add to main's import table entry}

  savedebinst: nodeindex; {debug instruction for fixup}
  profstmtcount: integer; {number of statements being profiled}

  highcode, currentpc: addressrange;
  sectionpc: array [section] of addressrange; { currentpc for this section}
  sectionno: array [section] of integer; {current section number}
  currentsect: section; { section for current code}

  totalputerr: integer; { total putmac errors in program }
  testing: boolean; { true if /test AND /macro }
  column: columnrange;
  sectiontail: string2; {contains .S or blanks}

  labelpc: addressrange; { object address of last-found label }
  found: boolean; { general boolean used to control search loops }

  lastobjpc: addressrange; { buffered objpc for intermediate file dump }

  fixuphead: fixupptr; { points to head of fixup list }
  fixuptail: fixupptr; { points to the last entry in the list }
  fixp: fixupptr; { temporary pointer into fixup list }

  esdtable: array [esdrange] of esdtabentry; { filled first-come, first-served
                                              }
  nextesd: esdrange; { next available entry in ESDtable }
  newesd: esdtabentry; { next argument for ESDtable insertions }
  esd: esdrange; { induction var for scanning ESD table }
  esdid: esdrange; { returns ESD index from ESD table searches }

  { buffers and counters to manage object file production }

  tempfilesize: addressrange; { total length in words of relfile }

  nextobjfile: - 1..255; { index into objfile buffer }
  nextrelfile: - 1..255; { index into relfile buffer }
  nextobjblk: integer; { Block number for seek }
  objbytecount: integer;

  nexttempbuffer: 0..32; { index into tempbuffer }
  nexttemprelocn: 0..32; { index into temprelocn }
  tempbuffer: array [0..31] of unsigned; {buffers constants and instructions}
  temprelocn: array [0..31] of boolean; {gets packed going into relfile}

  { Diagnostic code generation variables }

  nowdiagnosing: boolean; {generate diagnostic code for this block}
  everdiagnosing: boolean; {ever generated diagnostic code}
  lastdiagline: integer; {last line number reference generated}
  lastdiagpc: addressrange; {last pc reference generated}
  diaglenfix: fixupptr; {fixup for length of diag tables}
  codelenfix: fixupptr; {fixup for length of code}
  diagbitbuffer: unsigned; {holds diagnostic bits}
  nextdiagbit: bits; {next diagnostic bit to be filled in}
  commonesdid: esdrange; {kluge for common section (own)}

  macfile: text; {receives macro assembler image}
  objfile: objfiletype; {receives object image} {??}
  relfile: relfiletype; { array [0..255] of unsigned }
  diagfile: wordstream; {temporary diagnostics file}

  newobjectfmt: boolean; {if true generate new object types for long names}


implementation

end.
