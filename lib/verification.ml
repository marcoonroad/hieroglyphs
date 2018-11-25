module String = Core.String
module List = Core.List

let digest message =
  message
  |> Cstruct.of_hex
  |> Cstruct.to_bytes
  |> Hash.digest_bytes
  |> Cstruct.of_bytes
  |> Hex.of_cstruct
  |> Hex.show


let verify ~pub ~msg ~signature =
  let pub = List.map ~f:Utils.bytes_to_string pub in
  let indexed_keys = Utils.indexed_keys msg in
  let hashes = String.split signature ~on:'-' in
  let proofs = List.zip_exn indexed_keys hashes in
  Utils.verify_with ~matrix:pub ~digest proofs
