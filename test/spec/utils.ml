module String = Core.String
module Str = Re.Str
module Option = Core.Option
module Base64 = Nocrypto.Base64

let _HASH_LENGTH = 128

let _BYTES_LENGTH = 64

let regexp = Str.regexp "^[a-f0-9]+$"

let is_hash text =
  Str.string_match regexp text 0 && String.length text = _HASH_LENGTH


let is_blob_hash text = Cstruct.len text = _BYTES_LENGTH

let rec __split_cstruct_loop _LENGTH index splits blob =
  let position = index * _BYTES_LENGTH in
  let difference = _LENGTH - position in
  if difference <= 0
  then List.rev splits
  else
    let split = Cstruct.sub blob position _BYTES_LENGTH in
    let splits' = split :: splits in
    let index' = index + 1 in
    __split_cstruct_loop _LENGTH index' splits' blob


let __split_cstruct blob =
  let length = Cstruct.len blob in
  __split_cstruct_loop length 0 [] blob


let decode blob =
  let open Option in
  blob |> Cstruct.of_string |> Base64.decode >>| Cstruct.to_string


let split_signature signature =
  let signature' = Option.value_exn (decode signature) in
  let decoded = Cstruct.of_string signature' in
  let pieces = __split_cstruct decoded in
  pieces
