type priv
type pub = private string list

val generate : unit -> priv
val derive : priv -> pub
val pair : unit -> priv * pub

val export : priv:priv -> pass:string -> string
val import : cipher:string -> pass:string -> priv

val sign : priv:priv -> msg:string -> string
val verify : pub:pub -> msg:string -> signature:string -> bool
