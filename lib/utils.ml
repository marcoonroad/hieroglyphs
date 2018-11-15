module List = Core.List
module String = Core.String
module Char = Core.Char
module Int = Core.Int
module Str = Re.Str

(* 16 hex chars and 128 chars/string length for hash under hex string format *)
let _HASH_LENGTH = 128

let _HEX_SPACE = 16

let _KEY_LENGTH = _HEX_SPACE * _HASH_LENGTH

let regexp = Str.regexp "^[a-f0-9]+$"

let is_hash text =
  Str.string_match regexp text 0 && String.length text = _HASH_LENGTH


let validate_key list =
  let filtered = List.filter list ~f:is_hash in
  if List.length filtered = _KEY_LENGTH then Some list else None


let to_hex text = "0x" ^ text

let id x = x

let tag_index entries =
  let length = List.length entries in
  let indexes = List.init length ~f:id in
  List.zip_exn indexes entries


let calculate_index (position, key) = (position * _HEX_SPACE) + key

let index_at ~list position = List.nth_exn list position

let replace_index ~matrix pairs = pairs |> List.map ~f:(index_at ~list:matrix)

let verify_at ~digest ~list (position, hash) =
  let commitment = List.nth_exn list position in
  digest hash = commitment


let verify_with ~matrix ~digest pairs =
  pairs
  |> List.map ~f:(verify_at ~digest ~list:matrix)
  |> List.reduce_exn ~f:( && )


let concat_hashes left right = left ^ "-" ^ right

let indexed_keys msg =
  msg
  |> Hash.digest
  |> String.to_list
  |> List.map ~f:Char.to_string
  |> List.map ~f:to_hex
  |> List.map ~f:Int.of_string
  |> tag_index
  |> List.map ~f:calculate_index
