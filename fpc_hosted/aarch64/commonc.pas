unit commonc;

interface

uses config, hdr, utils, hdrc, t_c;

procedure newnode(kind: nodekinds);

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

end.
