val sign : priv:bytes -> msg:string -> string

val verify : pub:bytes -> msg:string -> signature:string -> bool

val show : bytes -> string

val load : string -> bytes option

val import : cipher:string -> pass:string -> bytes option

val export : priv:bytes -> pass:string -> string

val generate : unit -> bytes

val derive : bytes -> bytes

val address : bytes -> string
