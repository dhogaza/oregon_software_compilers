{[b+,l+]}

{ NOTICE OF COPYRIGHT AND OWNERSHIP OF SOFTWARE:

  Copyright (C) 1984 Oregon Software, Inc.
  All Rights Reserved.

  This program is the property of Oregon Software.  The program or
  parts of it may be copied and used only as provided under a signed
  license agreement with Oregon Software.  Any support purchased from 
  Oregon Software does not apply to user-modified programs.  All copies 
  of this program must display this notice and all copyright notices. 

  Release version: 0045  Level: 1  Date: 21-Nov-1990 15:19:24
  Processor: ~processor~
  System: ~system~

  Machine dependent routines for analys.

 Last modified by KRIS on 21-Nov-1990 15:19:24
 Purpose:
Update release version for PC-VV0-GS0 at 2.3.0.1

}

{ Machine Dependent Routines for Analys

  The routines in this section are highly machine dependent, and
  new versions will probably be required for each different
  target or host machine.
}

unit mda;

interface

uses config, hdr, utils, hdra, a_t;

function initialblocksize(blocklevel: levelindex): addressrange;

{ determines the offset from the fp for the first variable }

function paramalloc(paramptr, typeptr: entryptr): allockind;

{ Determine which type of register a param can be allocated to,
  if any.
}

procedure initregparams(var regparams: regparamstype);

{ Initialize the bookkeeping structure used to track allocation of
  register params.
}

procedure alloc(align: alignmentrange; {variable alignment}
                length: addressrange; {length of variable}
                var spacesize: addressrange; {size of data space}
                var varloc: addressrange; {loc of new variable}
                var overflowed: boolean {true if size overflowed} );

{ Allocate space for a single unpacked variable or field.

  A single field of length "length", with alignment "align",
  is added to the end of a data space which already had
  "spacesize" addressing units allocated.  The address of the
  newly allocated field is returned in "varloc", and "spacesize"
  is updated to include the new field.}

procedure allocparam(paramptr: entryptr; {the param we are allocating}
                     align: alignmentrange; {param alignment}
                     length: addressrange; {length of param}
                     var paramsize: addressrange; {if passed on stack}
                     var blocksize: addressrange; {for regparam mapped to local var}
                     var regparams: regparamstype; {track regparams}
                     var overflowed: boolean {parameter list is too big});

{ Allocate space or a register for a single parameter.
}

procedure allocfunction(procptr: entryptr;
                        var blocksize: addressrange);

{ Function return values are allocated in local variable storage and allowed to
  be register candidates.  If the function is not a real function and the
  size is greater than two 64-bit registers can hold, then it is allocated
  as special regiater parameter 8, with refparam set.

  We also set regid to note which register this should be returned in, and
  how many of them.
}

procedure allocpacked(align: alignmentrange; {variable alignment}
                      length: addressrange; {length of variable}
                      var spacesize: addressrange; {size of data space}
                      var varloc: addressrange; {loc of new variable}
                      var overflowed: boolean; {true if size overflowed}
                      var unusedspace: boolean {space skipped} );

{ Allocate space for a single packed field.

  A single field of length "length", with alignment "align",
  is added to the end of a data space which already had
  "spacesize" addressing units allocated.  The address of the
  newly allocated field is returned in "varloc", and "spacesize"
  is updated to include the new field.  "Unusedspace" is set
  if some space was left due to the allocation strategy.  This
  can be used to modify earlier fields for better access if
  desired.
}


procedure getallocdata(form: entryptr; {type being allocated}
                       varkind: nametype; {type of field or var}
                       packedresult: boolean; {result goes in packed field}
                       spacelen: addressrange; {space consumed so far}
                       var fieldlen: addressrange; {size to allocate}
                       var fieldalign: alignmentrange; {alignment for alloc}
                       var maxalign: alignmentrange {max alignment so far} );

{ Extract allocation data for a field or variable.

  This routine determines the length and alignment requirements for a
  field, variable, or parameter.  This may not be exactly the same
  as the space required for the value, since the field may be accessed
  indirectly, or other limitations may apply.

  "Form" points to the type entry for this variable, and "varkind" gives
  the usage.  "Fieldlen" and "fieldalign" must be set to define the space
  to be allocated, and "maxalign" must be updated to the alignment for
  the entire data space.  "Packedresult" and "spacelen" are included for
  information.
}


function arraysizeof(f: entryptr; {form to get size of}
                     packedresult: boolean {set if packed } ): addressrange;

{ Returns the amount of storage needed to contain a value of the type
  specified by "f", with desired modifications to ease array accessing.

  "Packedresult" determines if the size is in bits or addressing units.
}


procedure packedstore(eltloc: addressrange; {rel address of this field}
                      eltsize: addressrange; {size of this field}
                      baseloc: addressrange; {rel address of first buffer}
                      val: integer; {value to pack}
                      var pbuf1, pbuf2: integer; {packed buffers}
                      var full: boolean {buffer 1 is full} );

{ This routine stores the value "val" as a packed field.  The field address,
  in bits is "eltloc".  The result is to be returned in two integer buffers
  "pbuf1" and "pbuf2", which should be otherwise undisturbed.  The boolean
  "full" is set when "pbuf1" is full, and should be written.  "Baseloc" is
  the address (in bits) of the start of "pbuf1"
}


function roundpackedsize(spacesize: addressrange; {rounded space}
                         packedresult: boolean {true if packed record} ):
 addressrange;

{ Round length of declared type to an even multiple of bitsperunit if
  the type is packed.  Used to simplify code generator, which wishes to
  use unit-move instructions for structure assignments.
}


procedure possibletemp(off: addressrange;
                       vartype: index;
                       debugrec: integer);

{
    Purpose:
      Determine if tha var at off is eligible for assignment to register

    Inputs:
      off: offset from local data area of the possible temp.
      vartype: symbol table index to the var's type identifier.
      debugrec: offset in the symbol file where var's allocation is
                described.

    Outputs:
      If conditions are met then file "locals" has record appended.

    Algorithm:
      Straight forward.

    Sideeffects:
      None

    Last Modified: 7/16/85

}

function forcealign(size: addressrange; {value to align}
                    alignment: addressrange; {requirement}
                    packedresult: boolean {size is in bits} ): addressrange;

{ Forces "size" to the next higher multiple of "alignment".
  Used to overcome limitations built into much contemporary hardware.
}

function lower(f: entryptr {form to check} ): integer;

{ Returns the lower bound of "f".  This is meaningful only for
  scalar types.
}

function upper(f: entryptr {form to check} ): integer;

{ Returns the upper bound of "f".  This is meaningful only for
  scalar types.
}

function bits(i: integer {value to find size of} ): integer;

{ Returns the number of bits needed to contain the value of i.
}

  var
    b: integer; {Accumulates number of bits}
    value: unsignedint; {Temp so can use a register and shift inst}

function sizeof(f: entryptr; {Form to get size of}
                packedresult: boolean {set if packed value} ): addressrange;

{ Returns the amount of storage needed to contain a value of the type
  specified by "f".  If "packedresult" is set, this is in bits, otherwise
  it is in addressing units.
}

function alignmentof(f: entryptr; {form to check}
                     packedresult: boolean {result is packed} ):
 alignmentrange;

{ Compute the alignment requirement of a type.  This function is needed
  strictly because the alignment of a subrange is kluged to the parent
  type to give better code generation on certain types of machines.  This
  kluge causes trouble with packed types, so is deleted if the result
  is to be used in a packed structure.
}

procedure fixupparamoffsets(endofdefs: boolean {last chance} );

{ Parameters are allocated before variables but are addressed
  relative to the frame pointer.  This means that after a variable-
  declaration-part is parsed the parameter offsets must be adjusted
  to reflect any new variables allocated in this block.

  "Fixupparamoffsets" scans the parameters and makes necessary adjustments
  to the offsets.

  This routine assumes that parameters are allocated name
  entries immediately following the block name entry.

  On the aarch64 architecture, we don't differentiate between linkage
  types here, assuming that all language processors follow the aarch64
  calling standard.
}

procedure forcememoryparam(varlev: levelindex; paramptr: entryptr);

{Register parameters must be assigned to the stack if it is referenced
 by a nested procedure.  
}

implementation

function initialblocksize(blocklevel: levelindex): addressrange;

{ determines the offset from the fp for the first variable }

begin {initialblocksize}
  initialblocksize := 2 * ptrsize;
end; {initialblocksize}

function paramalloc(paramptr, typeptr: entryptr): allockind;

{ Determine which type of register a param can be allocated to,
  if any.
}

  begin {paramclass}
    if typeptr^.typ in [reals, doubles] then paramalloc := realregparam
    else if paramptr^.length <= ptrsize then paramalloc := regparam
    else paramalloc := normalalloc;
  end; {paramclass}

function  allocparamoffset(var blocksize, length: addressrange; overflowed: boolean): addressrange;
  begin {allocparamoffset}
    allocparamoffset := blocksize;
    if maxlong - blocksize > length then
      blocksize := blocksize + forcealign(length, stackalign, false)
    else overflowed := true;
  end {allocparamoffset};

procedure forcememoryparam(varlev: levelindex; paramptr: entryptr);

{Register parameters must be assigned to the stack if it is referenced
 by a nested procedure.  
}

var overflowed: boolean;

begin
  with paramptr^ do
    if registercandidate then
      begin 
      registercandidate := false;
      offset := allocparamoffset(display[varlev].blocksize, length, overflowed);
      end;
end;

procedure fixupparamoffsets(endofdefs: boolean {last chance} );

{ Parameters are allocated before variables but are addressed
  relative to the frame pointer.  This means that after a variable-
  declaration-part is parsed the parameter offsets must be adjusted
  to reflect any new variables allocated in this block.

  "Fixupparamoffsets" scans the parameters and makes necessary adjustments
  to the offsets.

  This routine assumes that parameters are allocated name
  entries immediately following the block name entry.

  On the aarch64 architecture, we don't differentiate between linkage
  types here, assuming that all language processors follow the aarch64
  calling standard.
}

  var
    i: index; {induction var}
    t: index; {last parameter index}
    bn: index; {block name index}
    p: entryptr; {used for accessing procedure and parameters}
    newoffset: addressrange; {dummy to fix code gen bug on the PDP-11}
    runningparamsize: addressrange;

  begin {fixupparamoffsets}
    with display[level] do
      begin
      bn := blockname;
      if endofdefs then
        begin
        blocksize := forcealign(blocksize, stackalign, false);
        if level = 1 then
          ownsize := forcealign(ownsize, targetintsize, false);
        end;

      if bigcompilerversion then p := @(bigtable[bn]);
                              
      t := p^.paramlist;

      { aarch64 requires stack parameters be pushed in reverse order }
      { DRB gcc assigns addresses on the stack in left-right order but
        does evaluate the parameter list in reverse order }
      runningparamsize := blocksize + paramsize;
      i := bn + 1;
      while i <= t do
        begin
        if bigcompilerversion then p := @(bigtable[i]);
        if not p^.form then
          if p^.varalloc = normalalloc then
            begin
            p^.offset := p^.offset + blocksize;
{
             p^.offset := runningparamsize + blocksize -
                          forcealign(p^.length, stackalign, false);
             runningparamsize := runningparamsize - 
                                 forcealign(p^.length, stackalign, false);
}
            if p^.namekind in [procparam, funcparam] then
              i := p^.nextparamlink;
            end;
        i := i + 1;
        end;

      end {with display};
  end {fixupparamoffsets} ;

procedure initregparams(var regparams: regparamstype);

{ Initialize the bookkeeping structure used to track allocation of
  register params.
}

begin {initregparams}
  regparams.regparams := 0;
  regparams.realregparams := 0;
end {initregparams} ;

function alignmentof(f: entryptr; {form to check}
                     packedresult: boolean {result is packed} ):
 alignmentrange;

{ Compute the alignment requirement of a type.  This function is needed
  strictly because the alignment of a subrange is kluged to the parent
  type to give better code generation on certain types of machines.  This
  kluge causes trouble with packed types, so is deleted if the result
  is to be used in a packed structure.
}

  begin {alignmentof}
    if packedresult = f^.bitaddress then alignmentof := f^.align
    else if packedresult then alignmentof := f^.align * bitsperunit
    else alignmentof := (f^.align + bitsperunit - 1) div bitsperunit;
  end {alignmentof} ;

procedure allocparam(paramptr: entryptr; {the param we are allocating}
                     align: alignmentrange; {param alignment}
                     length: addressrange; {length of param}
                     var paramsize: addressrange; {if passed on stack}
                     var blocksize: addressrange; {for regparam mapped to local var}
                     var regparams: regparamstype; {track regparams}
                     var overflowed: boolean {parameter list is too big});

{ Allocate space for a single parameter.  If it is a register parameter,
  assign the appropriate register as the regid.  We need both the memory
  location and register in this case as a variety of conditions force
  the register parameter to be assigned to the assigned address, notably
  use as a var parameter or access from a nested procedure.
}

  var
    typeptr: entryptr; 
    alloc: allockind;

  begin {allocparam}
    overflowed := false;
    typeptr := @(bigtable[paramptr^.vartype]);
    paramptr^.allocated := true;
    if (paramptr^.namekind in [varparam, varconfparam, confparam]) or
       (paramptr^.namekind = param) and (length > maxparambytes) and
       not (typeptr^.typ in [reals, doubles]) then
      begin
      paramptr^.length := ptrsize;
      paramptr^.refparam := true;
      end
    else paramptr^.length := length;
    alloc := paramalloc(paramptr, typeptr);
    if (alloc = realregparam) and
       (regparams.realregparams < maxrealregparams) then
      begin
      paramptr^.varalloc := realregparam;
      paramptr^.regid := regparams.realregparams;
      paramptr^.regcount := 1;
      paramptr^.offset := maxlong - paramptr^.regid - maxregparams - 1;
      regparams.realregparams := regparams.realregparams + 1;
      end
    else if (alloc = regparam) and (regparams.regparams < maxregparams) then
      begin
      paramptr^.varalloc := regparam;
      paramptr^.regid := regparams.regparams;
      paramptr^.regcount := 1;
      paramptr^.offset := maxlong - paramptr^.regid;
      regparams.regparams := regparams.regparams + 1;

      { If we allow structured types and sets to be left in registers, then
        the code generator must be prepared to access register bits when they
        are operands to indx, aindx, etc.  Eventually we'll do so for structs,
        at least, as that's part of the calling standard.
      }

      if (typeptr^.typ in [sets, fields, arrays, strings, conformantarrays]) and
         not paramptr^.refparam  then
        paramptr^.registercandidate := false;
      end
    else
      begin
      paramptr^.varalloc := normalalloc;
      paramptr^.offset := allocparamoffset(paramsize, paramptr^.length, overflowed);
      paramptr^.registercandidate := false; {might allow in the future}
      end;
  end {allocparam} ;

procedure alloc(align: alignmentrange; {variable alignment}
                length: addressrange; {length of variable}
                var spacesize: addressrange; {size of data space}
                var varloc: addressrange; {loc of new variable}
                var overflowed: boolean {true if size overflowed} );

{ Allocate space for a single unpacked variable or field.

  A single field of length "length", with alignment "align",
  is added to the end of a data space which already had
  "spacesize" addressing units allocated.  The address of the
  newly allocated field is returned in "varloc", and "spacesize"
  is updated to include the new field.
}

  begin
    spacesize := forcealign(spacesize, align, false);
    varloc := spacesize;
    if maxlong - spacesize > length then
      begin
      spacesize := spacesize + length;
      overflowed := false;
      end
    else overflowed := true;
  end; {alloc}

procedure allocfunction(procptr: entryptr;
                        var blocksize: addressrange);

{ Function return values are allocated in local variable storage and allowed to
  be register candidates.  If the function is not a real function and the
  size is greater than two 64-bit registers can hold, then it is allocated
  as special regiater parameter 8, with refparam set.

  We also set regid to note which register this should be returned in, and
  how many of them.  This is a kludge.
}

  var
    typeptr: entryptr;

  begin {allocfunction}
    typeptr := @(bigtable[procptr^.vartype]);
    procptr^.allocated := true;
    {if not (typeptr^.typ in [reals, doubles]) and
       procptr^,length >= 2 * ptrsize) then}
    if (typeptr^.typ in [sets, fields, arrays, strings, conformantarrays]) then
      begin
      procptr^.varalloc := regparam;
      procptr^.regid := 8;
      procptr^.refparam := true;
      procptr^.length := ptrsize;
      procptr^.offset := 0;
      end
    else
      begin

      { If we allow structured types and sets to be left in registers, then
        the code generator must be prepared to access register bits when they
        are operands to indx, aindx, etc.  Eventually we'll do so for structs,
        at least, as that's part of the calling standard.
      }

      procptr^.length := typeptr^.size;
      procptr^.varalloc := normalalloc;
      procptr^.offset := blocksize;
      blocksize := blocksize + procptr^.length;
      procptr^.registercandidate := true;
      procptr^.regid := 0;
      end;
  end; {allocfunction}

procedure allocpacked(align: alignmentrange; {variable alignment}
                      length: addressrange; {length of variable}
                      var spacesize: addressrange; {size of data space}
                      var varloc: addressrange; {loc of new variable}
                      var overflowed: boolean; {true if size overflowed}
                      var unusedspace: boolean {space skipped} );

{ Allocate space for a single packed field.

  A single field of length "length", with alignment "align",
  is added to the end of a data space which already had
  "spacesize" addressing units allocated.  The address of the
  newly allocated field is returned in "varloc", and "spacesize"
  is updated to include the new field.  "Unusedspace" is set
  if some space was left due to the allocation strategy.  This
  can be used to modify earlier fields for better access if
  desired.  

  ***M68000***
  Alignment is normally done bitwise, except when the resulting
  field will cross a word boundary, in which case it is advanced
  to the next boundary.  The alignment field is used only if the
  field will cross a byte boundary but not a bit boundary.  This
  is to make sure that no element of a packed array will split
  a byte boundary
}

  var
    newspace: addressrange; {updated value of spacesize}


  begin
    if spacesize mod bitsperunit + length > bitsperunit then
      if spacesize mod (packingunit * bitsperunit) + length >
         (packingunit * bitsperunit) then
        newspace := forcealign(spacesize, packingunit * bitsperunit, false)
      else newspace := forcealign(spacesize, align, false)
    else newspace := spacesize;
    unusedspace := newspace > spacesize;
    varloc := newspace;
    if maxlong - newspace > length then
      begin
      spacesize := newspace + length;
      overflowed := false;
      end
    else overflowed := true;
  end; {allocpacked}


procedure getallocdata(form: entryptr; {type being allocated}
                       varkind: nametype; {type of field or var}
                       packedresult: boolean; {result goes in packed field}
                       spacelen: addressrange; {space consumed so far}
                       var fieldlen: addressrange; {size to allocate}
                       var fieldalign: alignmentrange; {alignment for alloc}
                       var maxalign: alignmentrange {max alignment so far} );

{ Extract allocation data for a field or variable.

  This routine determines the length and alignment requirements for a
  field, variable, or parameter.  This may not be exactly the same
  as the space required for the value, since the field may be accessed
  indirectly, or other limitations may apply.

  "Form" points to the type entry for this variable, and "varkind" gives
  the usage.  "Fieldlen" and "fieldalign" must be set to define the space
  to be allocated, and "maxalign" must be updated to the alignment for
  the entire data space.  "Packedresult" and "spacelen" are included for
  information.
}


  begin
    fieldlen := sizeof(form, packedresult);
    if varkind in [param, varparam, confparam, varconfparam, procparam, funcparam, boundid] then
      fieldalign := stackalign
    else if packedresult and not (form^.typ in [arrays, fields]) and
            (spacelen mod (packingunit * bitsperunit) + fieldlen <=
            packingunit * bitsperunit) then
      fieldalign := 1
    else fieldalign := alignmentof(form, packedresult);
    if packedresult and (fieldlen <= packingunit * bitsperunit) and
       (spacelen mod bitsperunit + fieldlen > bitsperunit) then
      maxalign := max(maxalign, packingunit * bitsperunit)
    else if not packedresult and (fieldlen >= 2) then
      fieldalign := max(fieldalign, 2);
    maxalign := max(maxalign, fieldalign);
  end; {getallocdata}


function arraysizeof(f: entryptr; {form to get size of}
                     packedresult: boolean {set if packed } ): addressrange;

{ Returns the amount of storage needed to contain a value of the type
  specified by "f", with desired modifications to ease array accessing.

  "Packedresult" determines if the size is in bits or addressing units.

  ***M68000***
  If the result is packed, and the size is greater than an addressing
  unit, the result is rounded up to an even unit.  If the size is not
  greater than an addressing unit, it is rounded up to an even power of
  two bits.
}

  var
    s: addressrange; {working value of size}
    s1: addressrange; {used to compute power of two size}


  begin
    s := sizeof(f, packedresult);
    if packedresult then
      if s > bitsperunit then s := sizeof(f, false) * bitsperunit
      else
        begin
        s1 := 1;
        while s > s1 do s1 := s1 * 2;
        s := s1;
        end
    else s := forcealign(s, alignmentof(f, false), false);
    if s <> 0 then arraysizeof := s
    else arraysizeof := 1;
  end {arraysizeof} ;


procedure packedstore(eltloc: addressrange; {rel address of this field}
                      eltsize: addressrange; {size of this field}
                      baseloc: addressrange; {rel address of first buffer}
                      val: integer; {value to pack}
                      var pbuf1, pbuf2: integer; {packed buffers}
                      var full: boolean {buffer 1 is full} );

{ This routine stores the value "val" as a packed field.  The field address,
  in bits is "eltloc".  The result is to be returned in two integer buffers
  "pbuf1" and "pbuf2", which should be otherwise undisturbed.  The boolean
  "full" is set when "pbuf1" is full, and should be written.  "Baseloc" is
  the address (in bits) of the start of "pbuf1"
}

  var
    mask: unsignedint; {masks off unwanted bits of "val"}
    i: addressrange; {induction variable}
    shiftdist: addressrange; {distance to shift value}


  begin
    if emitflag then {after errors, just stop}
      begin
      eltsize := min(eltsize, hostintsize * bitsperunit); { Prevents big
        loops! }
      mask := 1;
      for i := 2 to eltsize do mask := mask * 2 + 1;
      val := val and mask;
      shiftdist := eltloc - baseloc;
      full := false;
      while shiftdist >= hostintsize * bitsperunit do
        begin
        full := true;
        shiftdist := shiftdist - hostintsize * bitsperunit;
        end;
      for i := 1 to hostintsize * bitsperunit - shiftdist - eltsize do
        val := val * 2;
      if full then pbuf2 := pbuf2 + val
      else pbuf1 := pbuf1 + val;
      end;
  end; {packedstore}



function roundpackedsize(spacesize: addressrange; {rounded space}
                         packedresult: boolean {true if packed record} ):
 addressrange;

{Round length of declared type to an even multiple of bitsperunit if
 the type is packed.  Used to simplify code generator, which wishes to
 use unit-move instructions for structure assignments.
}


  begin
    if packedresult and (spacesize > packingunit * bitsperunit) then
      roundpackedsize := forcealign(spacesize, unitsize, true)
    else roundpackedsize := spacesize;
  end {roundpackedsize} ;




procedure possibletemp(off: addressrange;
                       vartype: index;
                       debugrec: integer);

{
    Purpose:
      Determine if tha var or function return value at off is eligible for
      assignment to register

    Inputs:
      off: offset from local data area of the possible temp.
      vartype: symbol table index to the var's type identifier.
      debugrec: offset in the symbol file where var's allocation is
                described.

    Outputs:
      If conditions are met then file "locals" has record appended.

    Algorithm:
      Straight forward.

    Sideeffects:
      None

    Last Modified: 9/12/86

}

  var
    f: entryptr; { for access to type id }
    localvar: localvartype; { for writing to file }


  begin {possibletemp}
    if tempvars < maxtrackvar then
      begin
      if bigcompilerversion then f := @(bigtable[vartype]);
      if (f^.typ in [reals, doubles]) or
         ((f^.typ in [bools, chars, ints, ptrs, scalars, subranges, sets]) and
         (f^.size <= defaultptrsize)) then
        begin
        tempvars := tempvars + 1;
        localvar.offset := off;
        localvar.typ := f^.typ;
        localvar.debugrecord := debugrec;
        write(locals, localvar);
        end;
      end;
  end {possibletemp} ;

function forcealign(size: addressrange; {value to align}
                    alignment: addressrange; {requirement}
                    packedresult: boolean {size is in bits} ): addressrange;

{ Forces "size" to the next higher multiple of "alignment".
  Used to overcome limitations built into much contemporary hardware.
}

  begin {forcealign}
    if packedresult then alignment := alignment * bitsperunit;
    if alignment > 1 then
      size := ((size + alignment - 1) div alignment) * alignment;
    forcealign := size;
  end {forcealign} ;

function lower(f: entryptr {form to check} ): integer;

{ Returns the lower bound of "f".  This is meaningful only for
  scalar types.
}


  begin {lower}
    with f^ do
      if typ = ints then lower := targetminint
      else if typ = subranges then lower := lowerord
      else lower := 0;
  end {lower} ;

function upper(f: entryptr {form to check} ): integer;

{ Returns the upper bound of "f".  This is meaningful only for
  scalar types.
}

  begin {upper}
    with f^ do
      case typ of
        ints: upper := targetmaxint;
        bools: upper := 1;
        chars: upper := charsetsize - 1;
        none: upper := 255;
        scalars: upper := lastord;
        subranges: upper := upperord;
        otherwise upper := targetmaxint
        end
  end {upper} ;



function bits(i: integer {value to find size of} ): integer;

{ Returns the number of bits needed to contain the value of i.
}

  var
    b: integer; {Accumulates number of bits}
    value: unsignedint; {Temp so can use a register and shift inst}


  begin {bits}
    if i < 0 then bits := targetintsize * bitsperunit
    else
      begin
      value := i;
      b := 1;
      while value > 1 do
        begin
        b := b + 1;
        value := value div 2;
        end;
      bits := b;
      end;
  end {bits} ;

function sizeof(f: entryptr; {Form to get size of}
                packedresult: boolean {set if packed value} ): addressrange;

{ Returns the amount of storage needed to contain a value of the type
  specified by "f".  If "packedresult" is set, this is in bits, otherwise
  it is in addressing units.
}

  var
    lowerf: integer; { temp holding lower(f) }
    magnitude: addressrange; {absolute value of max number of bits}


  begin {sizeof}
    if packedresult = f^.bitaddress then sizeof := f^.size
    else if packedresult then
      case f^.typ of
        chars, bools, scalars, subranges, none:
          begin
          if (targetmachine = iapx86) and (f^.size > wordsize) then
            sizeof := defaulttargetintsize * bitsperunit
          else
            begin
            lowerf := lower(f);
            if (lowerf < 0) then
              begin
              magnitude := max(abs(upper(f)), abs(lowerf + 1));
              if magnitude = 0 then sizeof := 1 {handles the case of -1..0}
              else sizeof := bits(magnitude) + 1; {the normal case}
              end
            else sizeof := bits(upper(f));
            end;
          end
        otherwise
          if maxlong div bitsperunit < f^.size then sizeof := maxlong
          else sizeof := f^.size * bitsperunit;
        end
    else sizeof := (f^.size + bitsperunit - 1) div bitsperunit;
  end {sizeof} ;

end.
