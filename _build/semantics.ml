open Ast
open Ast.IR
open Baselib
module Env = Map.Make (String)

exception Error of string * Lexing.position

(* fonctions d'aide à la gestion des erreurs *)

let expr_pos expr =
  match expr with
  | Syntax.Value v -> v.pos
  | Syntax.Var v -> v.pos
  | Syntax.Call c -> c.pos

let errt expected got pos =
  raise
    (Error
       ( Printf.sprintf "Expected %s => got %s"
           (string_of_type_t expected)
           (string_of_type_t got),
         pos ))

(* analyse sémantique *)

let analyze_value value =
  match value with Syntax.Bool b -> Bool b | Syntax.Int n -> Int n

let rec analyze_expr env typ_e expr =
  match expr with
  (*for value v*)
  | Syntax.Value v -> (
      let r = analyze_value v.value in
      match r with
      | Bool n ->
          if typ_e == Bool_t then Value r
          else raise (Error ("Expected Int => got Bool", v.pos))
      | Int n ->
          if typ_e == Int_t then Value r
          else raise (Error ("Expected Bool => got Int", v.pos))
      (*for var v*))
  | Syntax.Var v -> (
      match Env.mem v.name env with
      | true ->
          if typ_e == Env.find v.name env then Var v.name
          else errt typ_e (Env.find v.name env) v.pos
      | false -> raise (Error ("Unbound Var " ^ v.name, v.pos)))
  (*for call c*)
  | Syntax.Call c -> (
      match Env.find c.func _types_ with
      | Func_t (Int_t, _) ->
          if typ_e == Int_t then
            let args = List.map (analyze_expr env typ_e) c.args in
            Call (c.func, args)
          else errt typ_e Int_t c.pos
      | Func_t (Bool_t, _) ->
          if typ_e == Bool_t then
            let args = List.map (analyze_expr env typ_e) c.args in
            Call (c.func, args)
          else errt typ_e Bool_t c.pos
      | _ -> raise (Error ("Unexpected Error ", c.pos)))

let rec analyze_instr env instr =
  match instr with
  | Syntax.Decl d ->
      let nenv = Env.add d.name d.type_t env in
      (Decl d.name, nenv)
  | Syntax.Assign a -> (
      match Env.mem a.var env with
      | true ->
          let ae = analyze_expr env (Env.find a.var env) a.expr in
          (Assign (a.var, ae), env)
      | false -> raise (Error ("Unbound Var " ^ a.var, a.pos)))

let rec analyze_block env block =
  match block with
  | [] -> []
  | instr :: rest ->
      let ai, nenv = analyze_instr env instr in
      ai :: analyze_block nenv rest

let analyze parsed = analyze_block Env.empty parsed
