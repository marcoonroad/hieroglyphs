open Core_bench.Bench
module Hg = Hieroglyphs

let generate ( ) =
  ( )
  |> Hg.generate
  |> ignore

let pair ( ) =
  ( )
  |> Hg.pair
  |> ignore

let priv = Hg.generate ( )

let signing ( ) =
  ignore (Hg.sign ~priv ~msg:"Benchmark signing test.")

let derive ( ) =
  priv
  |> Hg.derive
  |> ignore

let signature = Hg.sign ~priv ~msg:"Benchmark signed message."
let pub = Hg.derive priv

let verification ( ) =
  ignore (Hg.verify ~pub ~signature ~msg:"Benchmark signed message.")

let suite = [
  Test.create ~name:"private key generation" generate;
  Test.create ~name:"key pair generation"    pair;
  Test.create ~name:"message signing"        signing;
  Test.create ~name:"public key derivation"  derive;
  Test.create ~name:"signature verification" verification
]
