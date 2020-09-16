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
  (* let priv = ECC.generate () in *)
  ignore @@ ECC.sign ~priv ~msg:"Benchmark signing test."


let signature = ECC.sign ~priv ~msg:"Benchmark signed message."

let pub = ECC.derive priv

let verification () =
  let result = ECC.verify ~pub ~signature ~msg:"Benchmark signed message." in
  assert result


(*** test cases ***************************************************************)
let __generation =
  let name = "secp256k1 + sha256 hash ---- private key generation" in
  Test.create ~name generate


let __derivation =
  let name = "secp256k1 + sha256 hash ---- public key derivation" in
  Test.create ~name derive


let __signing =
  let name = "secp256k1 + sha256 hash ---- message signing" in
  Test.create ~name signing


let __verification =
  let name = "secp256k1 + sha256 hash ---- signature verification" in
  Test.create ~name verification


let suite = [__generation; __derivation; __signing; __verification]

let () = Nocrypto_entropy_unix.initialize ()
