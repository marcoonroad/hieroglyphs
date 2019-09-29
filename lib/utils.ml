module List = Core.List
module String = Core.String
module Char = Core.Char
module Int = Core.Int
module Lazy = Core.Lazy
module Str = Re.Str
module Option = Core.Option
module Base64 = Nocrypto.Base64

module Defer = struct
  let force = Lazy.force_val

  let bind deferred ~f = lazy (force @@ f @@ force deferred)
end

let nullchar = Char.of_int_exn 0

let cxor = Nocrypto.Uncommon.Cs.xor

let bytes_of_hex string = Cstruct.to_bytes @@ Cstruct.of_hex string

let bytes_to_hex bytes = Hex.show @@ Hex.of_cstruct @@ Cstruct.of_bytes bytes

(* 16 hex chars and 128 chars/string length for hash under hex string format *)
let _HASH_LENGTH = 128

let _CHECKSUM_LENGTH = 2

let _BYTES_LENGTH = 64

let _KEYS_LENGTH = _BYTES_LENGTH + _CHECKSUM_LENGTH

let regexp = Str.regexp "^[a-f0-9]+$"

let is_hash text =
  Str.string_match regexp text 0 && String.length text = _HASH_LENGTH


let pad_cstruct size input =
  let padding = String.make size nullchar in
  let blob = Cstruct.to_string input in
  let padded = String.rev (padding ^ blob) in
  let strip = String.sub ~pos:0 ~len:size padded in
  Cstruct.of_string @@ String.rev strip


let _int_to_cstruct number =
  lazy
    ( pad_cstruct _BYTES_LENGTH
    @@ Nocrypto.Numeric.Z.to_cstruct_be
    @@ Z.of_int number )


let _hash_both ~digest prefix suffix =
  lazy (digest @@ Cstruct.to_bytes @@ cxor prefix suffix)


type digest = steps:int -> bytes -> bytes

(* random is our seed for the signing keys *)
(* TODO: use HMAC/BLAKE-MAC here for a perfect PRF *)
let generate_pieces ~(digest : digest) random =
  let digest' = digest ~steps:1 in
  let blob = Cstruct.of_bytes random in
  let nums = List.init _KEYS_LENGTH ~f:_int_to_cstruct in
  List.map nums ~f:(Defer.bind ~f:(_hash_both ~digest:digest' blob))


let validate_key list =
  let filtered = List.filter list ~f:is_hash in
  if List.length filtered = _KEYS_LENGTH then Some list else None


let with_hex_prefix text = "0x" ^ text

let index_at ~(digest : digest) ~list (position, code) =
  bytes_to_hex
  @@ digest ~steps:code
  @@ Defer.force
  @@ List.nth_exn list position


let replace_index ~(digest : digest) ~matrix pairs =
  List.map pairs ~f:(index_at ~digest ~list:matrix)


let concat_hashes left right = left ^ ":" ^ right

let chained_index index value = (index, Char.to_int value)

let indexed_keys payload =
  payload |> Bytes.to_string |> String.to_list |> List.mapi ~f:chained_index


let pad ~basis msg =
  let length = String.length msg in
  let remainder = Int.( % ) length basis in
  let zerofill = String.make (basis - remainder) nullchar in
  Cstruct.of_string (msg ^ zerofill)


let nonzero char = char != nullchar

let unpad msg = String.filter ~f:nonzero @@ Cstruct.to_string msg
