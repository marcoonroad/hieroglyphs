open Core_bench.Bench
module Rsa = Nocrypto.Rsa
module Alg = Rsa.PSS (Nocrypto.Hash.SHA256)

let generate () = ignore (Rsa.generate 1024)

let priv = Rsa.generate 1024

let derive () = ignore (Rsa.pub_of_priv priv)

let signing () =
  "RSA PSS signed message."
  |> Cstruct.of_string
  |> Alg.sign ~key:priv
  |> Cstruct.to_string
  |> ignore


let signature =
  "RSA PSS signing message"
  |> Cstruct.of_string
  |> Alg.sign ~key:priv
  |> Cstruct.to_string


let pub = Rsa.pub_of_priv priv

let verification () =
  "RSA PSS signing message"
  |> Cstruct.of_string
  |> Alg.verify ~key:pub ~signature:(Cstruct.of_string signature)
  |> ignore


(*** test cases ***************************************************************)
let __generation =
  let name = "rsa pss/sha256 1024 bits --- private key generation" in
  Test.create ~name generate


let __derivation =
  let name = "rsa pss/sha256 1024 bits --- public key derivation" in
  Test.create ~name derive


let __signing =
  let name = "rsa pss/sha256 1024 bits --- message signing" in
  Test.create ~name signing


let __verification =
  let name = "rsa pss/sha256 1024 bits --- signature verification" in
  Test.create ~name verification


let suite = [__generation; __derivation; __signing; __verification]
