{
  open Parser

  exception Error of char
  exception StrEndError
}

let num = ['0'-'9']
let alpha = ['a' - 'z' 'A' - 'Z']
let ident = alpha ( alpha | num | '_')*
let special = ('-' | '_')

rule token = parse
| eof             { Lend }
| [ ' ' '\t' ]    { token lexbuf }
| '\n'            { Lexing.new_line lexbuf; token lexbuf }
| num+ as n       { Lint (int_of_string n) }
| "true"          { Ltrue (true)}
| "false"         { Lfalse (false)}
| ';'             { Lsc }
| '='             { Leq }
| "var"           { Lvar }
| '"'             { Lstr (String.of_seq (List.to_seq (charseq lexbuf))) }
| _ as c          { raise (Error c) }
and charseq = parse
| eof { raise (StrEndError) }
| '"' { [] } 
| "\\n" { '\n' :: (charseq lexbuf) } 
| "\\t" { '\t' :: (charseq lexbuf) }
| "\\\\" { '\\' :: (charseq lexbuf) } 
| _ as c { c :: (charseq lexbuf) }
