module List = Core.List

let sign ~priv ~msg =
  msg
  |> Utils.indexed_keys
  |> Utils.replace_index ~matrix:priv
  |> List.reduce_exn ~f:Utils.concat_hashes
