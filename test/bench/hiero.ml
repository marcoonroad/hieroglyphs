open Core_bench.Bench
module Hg = Hieroglyphs

let generate () = ignore @@ Hg.generate ()

let priv = Hg.generate ()

let signing () =
  let priv = Hg.generate () in
  ignore @@ Hg.sign ~priv ~msg:"Benchmark signing test."


let derive () = ignore @@ Hg.derive priv

let sign ~priv ~msg =
  match Hg.sign ~priv ~msg with
  | None ->
      failwith "Expected a generated message signature!"
  | Some signature ->
      signature


let signature = sign ~priv ~msg:"Benchmark signed message."

let pub = Hg.derive priv

let verification () =
  ignore @@ Hg.verify ~pub ~signature ~msg:"Benchmark signed message."


let suite =
  [ Test.create
      ~name:"hieroglyphs + blake2b ------ private key generation"
      generate
  ; Test.create ~name:"hieroglyphs + blake2b ------ message signing" signing
  ; Test.create
      ~name:"hieroglyphs + blake2b ------ public key derivation"
      derive
  ; Test.create
      ~name:"hieroglyphs + blake2b ------ signature verification"
      verification ]
