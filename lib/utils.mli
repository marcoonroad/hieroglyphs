val cxor : Cstruct.t -> Cstruct.t -> Cstruct.t

val _HASH_LENGTH : int

val _BYTES_LENGTH : int

val is_hash : string -> bool

val with_hex_prefix : string -> string

val concat_hashes : string -> string -> string

val validate_key : string list -> string list option

val generate_pieces :
  digest:(steps:int -> bytes -> bytes) -> bytes -> bytes list

val replace_index :
     digest:(steps:int -> bytes -> bytes)
  -> matrix:bytes list
  -> (int * int) list
  -> string list

val indexed_keys : bytes -> (int * int) list

val pad_cstruct : int -> Cstruct.t -> Cstruct.t

val pad : basis:int -> string -> Cstruct.t

val unpad : Cstruct.t -> string

val bytes_of_hex : string -> bytes

val bytes_to_hex : bytes -> string

val _NULL_HASH : string

val _NULL_ADDRESS : string
