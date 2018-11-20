open Core_bench.Bench
module ECC = Secp_helper

let buffer_of_hex s =
  s |> Hex.of_string |> Hex.to_cstruct |> Cstruct.to_bigarray


let hex_of_bigarray bigarray =
  bigarray |> Cstruct.of_bigarray |> Hex.of_cstruct |> Hex.to_string


let generate () =
  let priv : ECC.priv = ECC.generate () in
  ignore priv


let priv = ECC.generate ()

let derive () =
  let pub : ECC.pub = ECC.derive priv in
  ignore pub


let signing () =
  let priv = ECC.generate () in
  ignore @@ ECC.sign ~priv ~msg:"Benchmark signing test."


let signature = ECC.sign ~priv ~msg:"Benchmark signed message."

let pub = ECC.derive priv

let verification () =
  let result = ECC.verify ~pub ~signature ~msg:"Benchmark signed message." in
  assert result


let suite =
  [ Test.create
      ~name:"secp256k1 + sha256 hash ---- private key generation"
      generate
  ; Test.create
      ~name:"secp256k1 + sha256 hash ---- public key derivation"
      derive
  ; Test.create ~name:"secp256k1 + sha256 hash ---- message signing" signing
  ; Test.create
      ~name:"secp256k1 + sha256 hash ---- signature verification"
      verification ]


let () = Nocrypto_entropy_unix.initialize ()
