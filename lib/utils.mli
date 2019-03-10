val _HASH_LENGTH : int

val _KEY_LENGTH : int

val is_hash : string -> bool

val to_hex : string -> string

val concat_hashes : string -> string -> string

val validate_key : string list -> string list option

val generate_pieces : digest:(bytes -> bytes) -> bytes -> bytes list

val replace_index : matrix:'a list -> int list -> 'a list

val indexed_keys : string -> int list

val verify_with :
     matrix:string list
  -> digest:(string -> string)
  -> (int * string) list
  -> bool

val pad : basis:int -> string -> Cstruct.t

val unpad : string -> string

val bytes_of_string : string -> bytes

val bytes_to_string : bytes -> string
