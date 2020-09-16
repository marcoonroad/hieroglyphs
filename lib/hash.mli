val digest : ?steps:int -> string -> string

val digest_bytes : steps:int -> bytes -> bytes

val mine : difficulty:int -> string -> Cstruct.t

val hash_bytes_seq : bytes list -> Digestif.BLAKE2B.t

val same : Digestif.BLAKE2B.t -> Digestif.BLAKE2B.t -> bool

val mac : key:string -> string -> string

val mac_bytes : key:bytes -> bytes -> bytes
