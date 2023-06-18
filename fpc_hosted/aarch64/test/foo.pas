{$nomain}
procedure exit(code: integer); external;
procedure putchar(ch: char); external;
procedure putstringln(a:packed array [l..h: integer] of char); external;

procedure _p_caseerr;
  begin
    putstringln('case error');
    exit(1);
  end;

