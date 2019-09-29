val digest : ?steps:int -> string -> string

val digest_bytes : steps:int -> bytes -> bytes

val mine : difficulty:int -> string -> Cstruct.t
