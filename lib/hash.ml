let digest text =
  text |> Digestif.BLAKE2B.digest_string |> Digestif.BLAKE2B.to_hex


let rec __mining input pattern nonce =
  let length = Core.String.length pattern in
  let salt = Nocrypto.Numeric.Z.to_cstruct_be nonce in
  let message = Cstruct.append input salt in
  let result = Nocrypto.Hash.SHA256.digest message in
  let digest = Hex.show @@ Hex.of_cstruct result in
  let part = Core.String.sub ~pos:0 ~len:length digest in
  if pattern = part then result else __mining input pattern @@ Z.succ nonce


let mine ~difficulty text =
  let input = Cstruct.of_string text in
  let nonce = Z.zero in
  let pattern = Core.String.init difficulty ~f:(Core.const '0') in
  __mining input pattern nonce
