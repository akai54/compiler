open Ast
open Baselib

let collect_constant_strings code =
  let counter = ref (-1) in
  let ccs_value v env =
    match v with
    | V1.Bool b -> (V2.Bool b, env)
    | V1.Int n -> (V2.Int n, env)
    | V1.String s -> (
        ( V2.String s,
          match Env.find_opt s env with
          | Some _ -> env
          | None ->
              incr counter;
              Env.add s ("str" ^ string_of_int !counter) env ))
  in
  let ccs_expr e env =
    match e with
    | IR1.Val v ->
        let v, ccs = ccs_value v env in
        (IR2.Val v, ccs)
  in
  ccs_expr code Baselib.label

let simplify code = collect_constant_strings code
