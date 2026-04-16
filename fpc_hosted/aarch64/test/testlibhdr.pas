{glibc}
procedure exit(code: integer); external;
procedure putchar(ch: char); external;

type lib_unsigned = 0..16#FFFFFFFF;

{defined here}
procedure putstring(a:packed array [l..h: integer] of char); external;
procedure putstringln(a:packed array [l..h: integer] of char); external;
procedure putint(i: integer); external;
procedure putintln(i: integer); external;
procedure puthex(i: lib_unsigned); external;
procedure puthexln(i: lib_unsigned); external;
procedure putbool(b: boolean); external;
procedure putboolln(b: boolean); external;
procedure putcharln(ch: char); external;
procedure putln; external;
procedure _p_caseerr; external;
