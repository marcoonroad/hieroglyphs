module List = Core.List

let sign ~priv ~msg =
  (* yeah, I know that it's really bad smell code *)
  let priv = Utils.generate_pieces ~digest:Hash.digest_bytes priv in
  let priv = List.map priv ~f:Utils.bytes_to_string in
  msg
  |> Utils.indexed_keys
  |> Utils.replace_index ~matrix:priv
  |> List.reduce_exn ~f:Utils.concat_hashes
