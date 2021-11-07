module List = Core.List

let raw_of_hex hex = Cstruct.to_string @@ Cstruct.of_hex hex

let sign ~priv:seed ~msg =
  let priv = Utils.generate_pieces ~prf:Hash.mac_bytes seed in
  msg
  |> Bytes.of_string
  |> Checksum.make_payload
  |> Utils.indexed_keys
  |> Utils.replace_index ~digest:Hash.digest_bytes ~matrix:priv
  |> List.map ~f:raw_of_hex
  |> List.reduce_exn ~f:Utils.concat_hashes
  |> Encoding.encode
