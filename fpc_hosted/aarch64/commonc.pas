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
    if firstnode = nil then
      firstnode := p;
    lastnode^.next_node := p;
    lastnode^.kind := kind;
    lastnode := p;
  end {newnode};

end.
