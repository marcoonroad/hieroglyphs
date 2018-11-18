let digest text =
  text |> Digestif.BLAKE2B.digest_string |> Digestif.BLAKE2B.to_hex


let sha256 text =
  text |> Digestif.SHA256.digest_string |> Digestif.SHA256.to_raw_string
