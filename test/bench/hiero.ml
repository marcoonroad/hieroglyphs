open Core_bench.Bench
module Hg = Hieroglyphs__Keys

let generate () = ignore @@ Hg.generate ()

let priv = Hg.generate ()

let priv' = Hg.generate ()

let signing () =
  (* TODO: it's safe to sign the same message twice and many times, I should
     fix and cover that on the test specification *)
  ignore @@ Hg.sign ~priv:priv' ~msg:"Benchmark signing test."


let derive () = ignore @@ Hg.derive priv

let sign ~priv ~msg = Hg.sign ~priv ~msg

let signature = sign ~priv ~msg:"Benchmark signed message."

let pub = Hg.derive priv

let verification () =
  ignore @@ Hg.verify ~pub ~signature ~msg:"Benchmark signed message."


(*** test cases ***************************************************************)
let __generation =
  let name = "hieroglyphs + blake2b ------ private key generation" in
  Test.create ~name generate


let __signing =
  let name = "hieroglyphs + blake2b ------ message signing" in
  Test.create ~name signing


let __derivation =
  let name = "hieroglyphs + blake2b ------ public key derivation" in
  Test.create ~name derive


let __verification =
  let name = "hieroglyphs + blake2b ------ signature verification" in
  Test.create ~name verification


let suite = [__generation; __signing; __derivation; __verification]
