type reg = V0 | A0 | SP | RA
type label = string
type addr = Lbl of label | Mem of reg * int

type instr =
  | Addi of reg * reg * int
  | La of addr * addr
  | Li of addr * int
  | Lw of addr * addr
  | Move of reg * reg
  | Jr of addr
  | Jal of label
