open Nocrypto.Cipher_block.AES.ECB
module Option = Core.Option
module Base64 = Nocrypto.Base64

let encrypt msg ~pass =
  let key = of_secret (Hash.mine pass ~difficulty:5) in
  let result = encrypt ~key (Utils.pad ~basis:16 msg) in
  result |> Base64.encode |> Cstruct.to_string


let decrypt cipher ~pass =
  let key = of_secret (Hash.mine pass ~difficulty:5) in
  let result = cipher |> Cstruct.of_string |> Base64.decode in
  let open Option in
  result
  >>= fun msg ->
  msg |> decrypt ~key |> Cstruct.to_string |> Utils.unpad |> some
