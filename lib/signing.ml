module List = Core.List

let sign ~priv ~msg =
  let priv = List.map priv ~f:Utils.bytes_to_string in
  msg
  |> Utils.indexed_keys
  |> Utils.replace_index ~matrix:priv
  |> List.reduce_exn ~f:Utils.concat_hashes
