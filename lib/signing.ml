module List = Core.List
module Defer = Utils.Defer

let digest_to_string lazy_bytes =
  Utils.bytes_to_string @@ Hash.digest_bytes @@ Defer.force lazy_bytes


let sign ~priv ~msg =
  let priv' = Utils.generate_pieces ~digest:Hash.digest_bytes priv in
  let ver_key =
    List.map priv' ~f:digest_to_string
    |> List.reduce_exn ~f:Utils.concat_hashes
  in
  let ver_text =
    msg
    |> Utils.indexed_keys
    |> Utils.replace_index ~matrix:priv'
    |> List.reduce_exn ~f:Utils.concat_hashes
  in
  ver_text ^ "\n" ^ ver_key
