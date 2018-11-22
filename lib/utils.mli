val _HASH_LENGTH : int

val _KEY_LENGTH : int

val to_hex : string -> string

val concat_hashes : string -> string -> string

val validate_key : string list -> string list option

val replace_index : matrix:string list -> int list -> string list

val indexed_keys : string -> int list

val verify_with :
     matrix:string list
  -> digest:(string -> string)
  -> (int * string) list
  -> bool

val pad : basis:int -> string -> Cstruct.t

val unpad : string -> string
