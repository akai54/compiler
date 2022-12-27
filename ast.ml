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

module IR (P : Parameters) = struct
  type expr = Value of P.value
end
