module List = Core.List

let sign ~priv:seed ~msg =
  let priv = Utils.generate_pieces ~digest:Hash.digest_bytes seed in
  msg
  |> Bytes.of_string
  |> Checksum.make_payload
  |> Utils.indexed_keys
  |> Utils.replace_index ~digest:Hash.digest_bytes ~matrix:priv
  |> List.reduce_exn ~f:Utils.concat_hashes
