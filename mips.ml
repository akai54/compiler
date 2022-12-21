type reg = V0 | A0 | SP | RA
type label = string
type addr = Lbl of label | Mem of reg * int
