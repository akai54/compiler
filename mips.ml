let ps = Printf.sprintf

type reg = V0 | A0 | SP | RA
type label = string
type addr = Lbl of label | Reg of reg | Mem of reg * int

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
type asm = { text : instr list; data : dcl list }

let fmt_reg = function V0 -> "$v0" | A0 -> "$a0" | SP -> "$sp" | RA -> "$ra"

let fmt_addr = function
  | Lbl l -> l
  | Reg r -> fmt_reg r
  | Mem (r, o) -> ps "%d(%s)" o (fmt_reg r)

let fmt_dir = function Asciiz s -> ps ".asciiz \"%s\"" s

let fmt_instr = function
  | Addi (res, resv, rest) ->
      ps "  addi %s, %s, %d" (fmt_reg res) (fmt_reg resv) rest
  | La (r, addr) -> ps "  la %s, %s" (fmt_addr r) (fmt_addr addr)
  | Li (r, i) -> ps "  li %s, %d" (fmt_addr r) i
  | Lw (r, addr) -> ps "  lw %s %s" (fmt_addr r) (fmt_addr addr)
  | Move (rd, rs) -> ps "  move %s, %s" (fmt_reg rd) (fmt_reg rs)
  | Jr lbl -> ps "  jr %s" (fmt_addr lbl)
  | Jal lbl -> ps "  jal %s" lbl

let emit oc asm =
  Printf.fprintf oc ".text\n.globl main\nmain:\n";
  Printf.fprintf oc "  move $a0, $v0\n  li $v0, 1\n  syscall\n  jr $ra\n";
  Printf.fprintf oc "\n.data\n";
  List.iter (fun (l, d) -> Printf.fprintf oc "%s: %s\n" l (fmt_dir d)) asm.data
