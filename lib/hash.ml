let digest text =
  text
  |> Digestif.BLAKE2B.digest_string
  |> Digestif.BLAKE2B.to_hex
