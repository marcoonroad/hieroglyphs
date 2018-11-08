type priv
type pub

val generate : unit -> priv
val derive : priv -> pub
val pair : unit -> priv * pub

val export : priv:priv -> pass:string -> string
val import : cipher:string -> pass:string -> priv option

val load : string -> pub option
val show : pub -> string
val address : pub -> string

val sign : priv:priv -> msg:string -> string
val verify : pub:pub -> msg:string -> signature:string -> bool
