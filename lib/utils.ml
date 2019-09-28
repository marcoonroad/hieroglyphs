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

let bytes_of_hex string = Cstruct.to_bytes @@ Cstruct.of_hex string

let bytes_to_hex bytes = Hex.show @@ Hex.of_cstruct @@ Cstruct.of_bytes bytes

(* 16 hex chars and 128 chars/string length for hash under hex string format *)
let _HASH_LENGTH = 128

let _HEX_SPACE = 16

let _KEY_LENGTH = _HEX_SPACE * _HASH_LENGTH

let regexp = Str.regexp "^[a-f0-9]+$"

let is_hash text =
  Str.string_match regexp text 0 && String.length text = _HASH_LENGTH


let _int_to_cstruct number = lazy (Cstruct.of_string @@ string_of_int number)

let _hash_both ~digest prefix suffix =
  lazy (digest @@ Cstruct.to_bytes @@ Cstruct.append prefix suffix)


let generate_pieces ~digest random =
  let blob = Cstruct.of_bytes random in
  let nums = List.init _KEY_LENGTH ~f:_int_to_cstruct in
  List.map nums ~f:(Defer.bind ~f:(_hash_both ~digest blob))


let validate_key list =
  let filtered = List.filter list ~f:is_hash in
  if List.length filtered = _KEY_LENGTH then Some list else None


let with_hex_prefix text = "0x" ^ text

let calculate_index (position, key) = (position * _HEX_SPACE) + key

let index_at ~list position =
  bytes_to_hex @@ Defer.force @@ List.nth_exn list position


let replace_index ~matrix pairs = List.map pairs ~f:(index_at ~list:matrix)

let concat_hashes left right = left ^ ":" ^ right

let char_to_hex_int index char =
  let value = char |> Char.to_string |> with_hex_prefix |> Int.of_string in
  (index, value)


let chained_index index value = calculate_index @@ char_to_hex_int index value

let indexed_keys msg =
  msg |> Hash.digest |> String.to_list |> List.mapi ~f:chained_index


let nullchar = Char.of_int_exn 0

let pad ~basis msg =
  let length = String.length msg in
  let remainder = Int.( % ) length basis in
  let zerofill = String.make (basis - remainder) nullchar in
  Cstruct.of_string (msg ^ zerofill)


let nonzero char = char != nullchar

let unpad msg = String.filter ~f:nonzero @@ Cstruct.to_string msg

let digest_hex_string hex =
  hex
  |> Cstruct.of_hex
  |> Cstruct.to_bytes
  |> Hash.digest_bytes
  |> Cstruct.of_bytes
  |> Hex.of_cstruct
  |> Hex.show
