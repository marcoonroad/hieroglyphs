module String = Core.String
module List = Core.List
module Option = Core.Option

let digest message =
  message
  |> Cstruct.of_hex
  |> Cstruct.to_bytes
  |> Hash.digest_bytes
  |> Cstruct.of_bytes
  |> Hex.of_cstruct
  |> Hex.show


let verify ~pub ~msg ~signature =
  try
    let parts = String.split signature ~on:'\n' in
    let ver_text = List.nth_exn parts 0 |> String.split ~on:'-' in
    let ver_key_bytes =
      Option.value_exn (Serialization.load @@ List.nth_exn parts 1)
    in
    let ver_key = List.map ~f:Utils.bytes_to_string ver_key_bytes in
    let indexed_keys = Utils.indexed_keys msg in
    let proofs = List.zip_exn indexed_keys ver_text in
    let verified = Utils.verify_with ~matrix:ver_key ~digest proofs in
    if verified
    then
      let fingerprint = Serialization.digest ver_key_bytes in
      fingerprint = Utils.bytes_to_string pub
    else false
  with _ -> false
