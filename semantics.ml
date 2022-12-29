open Ast
open Ast.Syntax

exception Error of string * Lexing.position

let analyze_value value =
  match value with
  | Syntax.Void -> V1.Void
  | Syntax.Bool b -> V1.Bool b
  | Syntax.Int n -> V1.Int n
  | Syntax.String v -> V1.String v

let analyze_expr expr _ =
  match expr with Syntax.Val v -> IR1.Val (analyze_value v.value)

let analyze parsed = analyze_expr parsed Baselib._types_
