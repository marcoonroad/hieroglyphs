open Core_bench.Bench
module Rsa = Nocrypto.Rsa
module Alg = Rsa.PSS(Nocrypto.Hash.SHA256)

let generate ( ) =
  ignore (Rsa.generate 1024)

let priv = Rsa.generate 1024

let derive ( ) =
  ignore (Rsa.pub_of_priv priv)

let suite = [
  Test.create ~name:"rsa pss 1024 bits private key generation" generate;
  Test.create ~name:"rsa pss 1024 bits public key derivation"  derive
]
