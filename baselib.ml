module Env = Map.Make (String)

let label = Env.empty
let _types_ = Env.of_seq (List.to_seq [])
let builtins = []
