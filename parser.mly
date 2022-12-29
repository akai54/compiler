%{
  open Ast.Syntax
  %}

%token <bool> Lbol
%token <bool> Ltrue
%token <bool> Lfalse
%token <int> Lint
%token <string> Lstr
%token Lvoid
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
| Lvoid {
    Void
}
| b = Lbol {
    Bool b
}
| n = Lint {
    Int n
    }
| s = Lstr {
    String s
}
