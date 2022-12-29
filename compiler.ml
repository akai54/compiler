open Ast.IR2
open Ast.V2
open Mips
open Baselib
module Env = Map.Make (String)

let print_int = [ Move (A0, V0); Li (V0, 1) ]
let print_string = [ Li (V0, 4) ]

let compile_value v env =
  match v with
  | Void -> [ Li (V0, 0) ] @ print_int
  | Bool b -> [ Li (V0, if b then 1 else 0) ] @ print_int
  | Int n -> [ Li (V0, n) ] @ print_int
  | String d ->
      [ La (A0, Lbl (match Env.find d env with l -> l)) ] @ print_string

let compile_expr e env = match e with Val v -> compile_value v env

let compile (ir, data) =
  {
    text = Baselib.builtins @ compile_expr ir data;
    data =
      List.map (fun (l, s) -> (s, Asciiz l)) (List.of_seq (Env.to_seq data));
  }
