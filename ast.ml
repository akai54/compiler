type ident = string

module type Parameters = sig
  type value
end

module Syntax = struct
  type value = Void | Bool of bool | Int of int | String of string
  type expr = Val of { value : value; pos : Lexing.position }

  type instr =
    | DecVar of { name : string; pos : Lexing.position }
    | Assign of { var : string; expr : expr; pos : Lexing.position }

  type block = instr list
end

module V1 = struct
  type value = Void | Bool of bool | Int of int | String of string
end

module V2 = struct
  type value = Void | Bool of bool | Int of int | String of string
end

module IR (P : Parameters) = struct
  type expr = Val of P.value
end

module IR1 = IR (V1)
module IR2 = IR (V2)
