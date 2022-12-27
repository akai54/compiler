type ident = string

module type Parameters = sig
  type value
end

module Values = struct
  type value = Void | Int of int | Bool of bool | Str of string
end

module Syntax = struct
  type expr =
    | Value of { value : Values.value; pos : Lexing.position }
    | Call of { func : ident; args : expr list; pos : Lexing.position }
    | Var of { name : ident; pos : Lexing.position }
end

module V1 = struct
  type value = Void | Int of int | Bool of bool | Str of string
end

module V2 = struct
  type value = Void | Int of int | Bool of bool | Str of string
end

module IR (P : Parameters) = struct
  type expr = Value of P.value | Call of ident * expr list | Var of ident
end
