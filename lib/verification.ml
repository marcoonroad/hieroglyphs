module String = Core.String
module List = Core.List
module Option = Core.Option
module Defer = Utils.Defer

let __verify_at ~digest ~list (position, opening) =
  let commitment = Defer.force @@ List.nth_exn list position in
  let hash = digest opening in
  hash = commitment


let __verify_with ~matrix ~digest pairs =
  pairs
  |> List.map ~f:(__verify_at ~digest ~list:matrix)
  |> List.reduce_exn ~f:( && )


let digest = Utils.digest_hex_string

let delay_string_cast bytes = lazy (Utils.bytes_to_hex bytes)

let verify ~pub ~msg ~signature =
  try
    let parts = String.split signature ~on:'\n' in
    let ver_text = List.nth_exn parts 0 |> String.split ~on:':' in
    let ver_key_bytes =
      Option.value_exn (Serialization.load @@ List.nth_exn parts 1)
    in
    let ver_key = List.map ~f:delay_string_cast ver_key_bytes in
    let indexed_keys = Utils.indexed_keys msg in
    let proofs = List.zip_exn indexed_keys ver_text in
    let verified = __verify_with ~matrix:ver_key ~digest proofs in
    if verified
    then
      let fingerprint = Serialization.digest ver_key_bytes in
      fingerprint = Utils.bytes_to_hex pub
    else false
  with
  | _ ->
      false
