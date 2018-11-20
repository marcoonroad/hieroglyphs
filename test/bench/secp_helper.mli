type priv

type pub

val generate : unit -> priv

val derive : priv -> pub

val sign : priv:priv -> msg:string -> string

val verify : pub:pub -> msg:string -> signature:string -> bool
