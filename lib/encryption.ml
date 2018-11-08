open Nocrypto.Cipher_stream.ARC4

let encrypt msg ~pass =
  let key = of_secret (Cstruct.of_string pass) in
  let result = encrypt ~key (Cstruct.of_string msg) in
  Cstruct.to_string result.message

let decrypt cipher ~pass =
  let key = of_secret (Cstruct.of_string pass) in
  let result = decrypt ~key (Cstruct.of_string cipher) in
  Cstruct.to_string result.message
