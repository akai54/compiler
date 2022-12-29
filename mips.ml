let ps = Printf.sprintf

type reg = V0 | A0 | SP | RA | FP
type label = string
type addr = Lbl of label | Reg of reg | Mem of reg * int

type instr =
  | Addi of reg * reg * int
  | La of reg * addr
  | Li of reg * int
  | Lw of reg * addr
  | Move of reg * reg
  | Jr of addr
  | Jal of label

type dctv = Asciiz of string
type dcl = label * dctv
type asm = { text : instr list; data : dcl list }

let fmt_reg = function
  | V0 -> "$v0"
  | A0 -> "$a0"
  | SP -> "$sp"
  | RA -> "$ra"
  | FP -> "$fp"

let fmt_addr = function
  | Lbl l -> l
  | Reg l -> fmt_reg l
  | Mem (r, off) -> ps "%d(%s)" off (fmt_reg r)

let fmt_dir = function Asciiz s -> ps ".asciiz \"%s\"" s

let fmt_instr mips_instr =
  match mips_instr with
  | Addi (result, resv, to_add) ->
      ps "  addi %s, %s, %d" (fmt_reg result) (fmt_reg resv) to_add
  | Li (r, i) -> ps "  li %s, %d" (fmt_reg r) i
  | La (r, addr) -> ps "  la %s, %s" (fmt_reg r) (fmt_addr addr)
  | Lw (r, addr) -> ps "  lw %s %s" (fmt_reg r) (fmt_addr addr)
  | Jr lbl -> ps "  jr %s" (fmt_addr lbl)
  | Move (rd, rs) -> ps "  move %s, %s" (fmt_reg rd) (fmt_reg rs)
  | Jal lbl -> ps "  jal %s" lbl

let emit oc asm =
  Printf.fprintf oc ".text\n.globl main\nmain:\n";
  List.iter (fun i -> Printf.fprintf oc "%s\n" (fmt_instr i)) asm.text;
  Printf.fprintf oc "  move $a0, $v0\n  li $v0, 1\n  syscall\n  jr $ra\n";
  Printf.fprintf oc "\n.data\n";
  List.iter (fun (l, d) -> Printf.fprintf oc "%s: %s\n" l (fmt_dir d)) asm.data
