open Ast.IR
open Mips
open Baselib
module Env = Map.Make (String)

let rec compile_expr e = match e with Int n -> [ Li (V0, n) ]
let compile ir = { text = Baselib.builtins @ compile_expr ir; data = [] }
