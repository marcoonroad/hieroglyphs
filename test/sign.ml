module Hg = Hieroglyphs

let __signing_and_verification ( ) =
  let msg1 = "Hello, World!" in
  let msg2 = "Bye bye, World!" in

  let (priv1, pub1) = Hg.pair ( ) in
  let (priv2, pub2) = Hg.pair ( ) in

  let sign1 = Hg.sign ~priv:priv1 ~msg:msg1 in
  let sign2 = Hg.sign ~priv:priv2 ~msg:msg2 in

  let resultA = Hg.verify ~pub:pub1 ~signature:sign1 ~msg:msg1 in
  let resultB = Hg.verify ~pub:pub2 ~signature:sign2 ~msg:msg2 in
  let resultC = Hg.verify ~pub:pub2 ~signature:sign1 ~msg:msg1 in
  let resultD = Hg.verify ~pub:pub1 ~signature:sign2 ~msg:msg2 in
  let resultE = Hg.verify ~pub:pub2 ~signature:sign2 ~msg:msg1 in
  let resultF = Hg.verify ~pub:pub1 ~signature:sign1 ~msg:msg2 in

  Alcotest.(check bool) "verification for public key 1, signature 1 and message 1 pass" true  resultA;
  Alcotest.(check bool) "verification for public key 2, signature 2 and message 2 pass" true  resultB;
  Alcotest.(check bool) "verification for public key 2, signature 1 and message 1 fail" false resultC;
  Alcotest.(check bool) "verification for public key 1, signature 2 and message 2 fail" false resultD;
  Alcotest.(check bool) "verification for public key 2, signature 2 and message 1 fail" false resultE;
  Alcotest.(check bool) "verification for public key 1, signature 1 and message 2 fail" false resultF

let suite = [
  "signing and verification must match", `Quick, __signing_and_verification
]
