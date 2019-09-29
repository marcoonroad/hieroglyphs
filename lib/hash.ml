module Bytes = Core.Bytes

let rec __digest_string_steps count message =
  if count <= 0
  then message
  else
    let digest = Digestif.BLAKE2B.digest_string message in
    __digest_string_steps (count - 1) @@ Digestif.BLAKE2B.to_raw_string digest


let digest ?(steps = 1) text =
  text |> __digest_string_steps steps |> Hex.of_string |> Hex.show


let digest_bytes ~steps bytes =
  bytes |> Bytes.to_string |> __digest_string_steps steps |> Bytes.of_string


let __digest message = Nocrypto.Hash.SHA256.digest message

(* TODO: use scrypt KDF here *)
let rec __mining input pattern nonce =
  let length = Core.String.length pattern in
  let salt = Nocrypto.Numeric.Z.to_cstruct_be nonce in
  let message = Cstruct.append input salt in
  let result = __digest message in
  let digest = Hex.show @@ Hex.of_cstruct result in
  let part = Core.String.sub ~pos:0 ~len:length digest in
  if pattern = part then result else __mining input pattern @@ Z.succ nonce


let mine ~difficulty text =
  let input = Cstruct.of_string text in
  let nonce = Z.zero in
  let pattern = Core.String.init difficulty ~f:(Core.const '0') in
  __mining input pattern nonce
