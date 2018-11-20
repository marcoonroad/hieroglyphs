module ECC = Secp256k1
module NoZ = Nocrypto.Numeric.Z
module SHA256 = Digestif.SHA256
module Base64 = Nocrypto.Base64

type priv = ECC.Key.secret ECC.Key.t

type pub = ECC.Key.public ECC.Key.t

let _gen_ctxt () = ECC.Context.create [ECC.Context.Sign; ECC.Context.Verify]

let ctx = _gen_ctxt ()

let _MIN_ORDER =
  "1000000000000000000000000000000000000000000000000000000000000000"


let _CURVER_ORDER =
  "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"


let _min_z = Z.succ @@ Z.of_string_base 16 _MIN_ORDER

let _max_z = Z.pred @@ Z.of_string_base 16 _CURVER_ORDER

let _gen_256_bits_number () = Nocrypto.Rng.Z.gen_r _min_z _max_z

let _generate_private_key ctx =
  Nocrypto_entropy_unix.initialize () ;
  let random_cstruct = NoZ.to_cstruct_be @@ _gen_256_bits_number () in
  ECC.Key.read_sk_exn ctx ~pos:0 (Cstruct.to_bigarray random_cstruct)


let generate () = _generate_private_key ctx

let derive priv = ECC.Key.neuterize_exn ctx priv

let _preprocess msg =
  let open ECC in
  let digest = Hex.of_string @@ SHA256.to_hex @@ SHA256.digest_string msg in
  let buffer = Cstruct.to_bigarray @@ Hex.to_cstruct digest in
  Sign.msg_of_bytes_exn buffer


let _encode buffer =
  buffer |> Cstruct.of_bigarray |> Base64.encode |> Cstruct.to_string


let _decode signature =
  match Base64.decode @@ Cstruct.of_string signature with
  | Some cstruct ->
      Cstruct.to_bigarray cstruct
  | None ->
      failwith "Failed to decode the secp256k1 signature!"


let sign ~priv ~msg =
  let open ECC in
  let signature = Sign.sign_exn ctx ~sk:priv ~msg:(_preprocess msg) in
  _encode @@ Sign.to_bytes ctx signature


let verify ~pub ~msg ~signature =
  let open ECC in
  let preprocessed = _preprocess msg in
  let buffer = _decode signature in
  let plainsig = Sign.read_exn ctx buffer in
  Sign.verify_exn ctx ~pk:pub ~msg:preprocessed ~signature:plainsig
