open Nocrypto.Cipher_stream.ARC4
module Option = Core.Option
module Base64 = Nocrypto.Base64

let encrypt msg ~pass =
  let key = of_secret (Cstruct.of_string pass) in
  let result = encrypt ~key (Cstruct.of_string msg) in
  result.message |> Base64.encode |> Cstruct.to_string


let decrypt cipher ~pass =
  let key = of_secret (Cstruct.of_string pass) in
  let result = cipher |> Cstruct.of_string |> Base64.decode in
  let open Option in
  result
  >>= fun msg ->
  let result = decrypt ~key msg in
  some (Cstruct.to_string result.message)
