let ps = Printf.sprintf

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

type dctv = Asciiz of string
type dcl = label * dctv

let fmt_reg = function V0 -> "$v0" | A0 -> "$a0" | SP -> "$sp" | RA -> "$ra"
let fmt_addr = function Lbl l -> l

let fmt_instr = function
  | Li (r, i) -> ps "  li %s, %d" (fmt_addr r) i
  | La (r, a) -> ps "  la %s, %s" (fmt_addr r) (fmt_addr a)

let fmt_dir = function Asciiz s -> ps ".asciiz \"%s\"" s

let emit oc asm =
  Printf.fprintf oc ".text\n.globl main\nmain:\n";
  List.iter (fun i -> Printf.fprintf oc "%s\n" (fmt_instr i)) asm.text;
  Printf.fprintf oc "  syscall\n  jr $ra\n";
  Printf.fprintf oc "\n.data\n";
  List.iter (fun (l, d) -> Printf.fprintf oc "%s: %s\n" l (fmt_dir d)) asm.data
