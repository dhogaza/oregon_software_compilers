

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

  begin
    p := firstnode;
    while p <> nil do
    begin
      p1 := p^.next_node;
      dispose(p);
      p := p1;
    end
  end {exitcode};
     
end.
