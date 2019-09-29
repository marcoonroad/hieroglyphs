module String = Core.String
module List = Core.List
module Option = Core.Option

let __compute_digest (cell, (_, value)) =
  Hash.digest_bytes ~steps:(255 - value) cell


let __compute_root cells pairs =
  List.zip_exn cells pairs
  |> List.map ~f:__compute_digest
  |> Serialization.digest


let verify ~pub ~msg ~signature =
  try
    let cells = Option.value_exn (Serialization.load signature) in
    let payload = Checksum.make_payload @@ Bytes.of_string msg in
    let pairs = Utils.indexed_keys payload in
    let root = __compute_root cells pairs in
    let fingerprint = Utils.bytes_to_hex pub in
    root = fingerprint
  with
  | _ ->
      false
