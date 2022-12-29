%{
  open Ast.Syntax
%}

%token <bool> Lbol
%token <bool> Ltrue
%token <bool> Lfalse
%token <int> Lint
%token <string> Lstr
%token Lvid
%token Lsc Lend Lvar Leq

%start prog

%type <Ast.Syntax.expr> prog

%%

prog:
| e = expr; Lend { e }
;

expr:
| v = value {
  Val { value = v ; pos = $startpos(v) }
}
;

value:
| n = Lint {
  Int n
}
| b = Lbol {
  Bool b
}
| s = Lstr {
  String s
}
