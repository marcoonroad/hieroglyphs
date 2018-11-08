module Hg = Hieroglyphs

let __public_key_derivation ( ) =
  let priv = Hg.generate ( ) in
  let priv' = Hg.generate ( ) in
  let pub1 = Hg.address (Hg.derive priv) in
  let pub2 = Hg.address (Hg.derive priv) in
  let pub' = Hg.address (Hg.derive priv') in
  Alcotest.(check string) "the same private key derives the same public key" pub1 pub2;
  Alcotest.(check (neg string)) "different private keys derive different public keys" pub1 pub'

let __public_key_serialization ( ) =
  let (_, pub) = Hg.pair ( ) in
  let result1 = Hg.load (Hg.show pub) in
  let result2 = Hg.load "Some invalid Public Key dump here..." in
  Alcotest.(check pass) "must not parse and load invalid public key dumps" None result2;
  match result1 with
  | None -> Alcotest.fail "Expected a valid loaded Public Key dump!"
  | Some pub' ->
      let pub_addr = Hg.address pub in
      let pub'_addr = Hg.address pub' in
      Alcotest.(check string) "serialized public key maintains all information" pub_addr pub'_addr

let __private_key_backup ( ) =
  let priv = Hg.generate ( ) in
  let cipher = Hg.export ~priv ~pass:"Stupid pass made of 1, 2, 3" in
  let result1 = Hg.import ~cipher ~pass:"Stupid pass made of 1, 2, 3, 4, 5" in
  let result2 = Hg.import ~cipher ~pass:"Stupid pass made of 1, 2, 3" in
  Alcotest.(check pass) "must not import private key if is not able to decrypt properly" None result1;
  match result2 with
  | None -> Alcotest.fail "Expected a valid loaded Private Key backup!"
  | Some priv' ->
      let addr1 = Hg.address (Hg.derive priv) in
      let addr2 = Hg.address (Hg.derive priv') in
      Alcotest.(check string) "valid passwords enable backup and restore of private keys" addr1 addr2

let suite = [
  "public key derivation",     `Quick, __public_key_derivation;
  "public key serialization",  `Quick, __public_key_serialization;
  "private key secure backup", `Slow,  __private_key_backup
]
