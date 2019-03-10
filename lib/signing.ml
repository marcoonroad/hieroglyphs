module List = Core.List

let digest_to_string bytes = Utils.bytes_to_string @@ Hash.digest_bytes bytes

let sign ~priv ~msg =
  (* yeah, I know that it's really bad smell code *)
  let priv' = Utils.generate_pieces ~digest:Hash.digest_bytes priv in
  let ver_key =
    List.map priv' ~f:digest_to_string
    |> List.reduce_exn ~f:Utils.concat_hashes
  in
  let ver_text =
    msg
    |> Utils.indexed_keys
    |> Utils.replace_index ~matrix:priv'
    |> List.map ~f:Utils.bytes_to_string
    |> List.reduce_exn ~f:Utils.concat_hashes
  in
  ver_text ^ "\n" ^ ver_key
