type ident = string

module type Parameters = sig
  type value
end

module Syntax = struct
  type expr =
    | Bool of { value : bool; pos : Lexing.position }
    | Int of { value : int; pos : Lexing.position }
    | String of { value : string; pos : Lexing.position }
end

module IR = struct
  type expr = Bool of bool | Int of int | String of string
end
