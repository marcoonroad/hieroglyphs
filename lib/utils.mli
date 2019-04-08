module Defer : sig
  val force : 'a Lazy.t -> 'a

  val bind : 'a Lazy.t -> f:('a -> 'b Lazy.t) -> 'b Lazy.t
end

val _HASH_LENGTH : int

val _KEY_LENGTH : int

val is_hash : string -> bool

val to_hex : string -> string

val concat_hashes : string -> string -> string

val validate_key : string list -> string list option

val generate_pieces : digest:(bytes -> bytes) -> bytes -> bytes Lazy.t list

val replace_index : matrix:bytes Lazy.t list -> int list -> string list

val indexed_keys : string -> int list

val verify_with :
     matrix:string Lazy.t list
  -> digest:(string -> string)
  -> (int * string) list
  -> bool

val pad : basis:int -> string -> Cstruct.t

val unpad : string -> string

val bytes_of_string : string -> bytes

val bytes_to_string : bytes -> string
