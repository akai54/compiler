type ident = string

module type Parameters = sig
  type value
end

module Syntax = struct
  type values =
    | Bool of { value : bool; pos : Lexing.position }
    | Int of { value : int; pos : Lexing.position }
    | String of { value : string; pos : Lexing.position }

  type expr = Val of { value : values; pos : Lexing.position }
end

module V1 = struct
  type value = Bool of bool | Int of int | String of string
end

module V2 = struct
  type value = Bool of bool | Int of int | String of string
end

module IR (P : Parameters) = struct
  type expr = Bool of bool | Int of int | String of string
end

module IR1 = IR (V1)
module IR2 = IR (V2)
