module List = Core.List
module String = Core.String
module Float = Core.Float
module Int64 = Core.Int64
module Option = Core.Option
module Base64 = Nocrypto.Base64

let generate () = Random.generate512 ()

let __digest piece = Hash.digest_bytes ~steps:255 piece

let genpub priv =
  let pieces = Utils.generate_pieces ~digest:Hash.digest_bytes priv in
  List.map pieces ~f:__digest


let derive priv = Utils.bytes_of_hex @@ Serialization.digest @@ genpub priv

let export ~priv ~pass =
  let priv' = Bytes.to_string priv in
  let payload = Encoding.encode priv' in
  Encryption.encrypt ~pass payload


(* validates both private and public keys *)
let validate_key blob =
  try
    let plain =
      blob
      |> Cstruct.of_string
      |> Base64.decode
      |> (fun opt -> Option.value_exn opt)
      |> Cstruct.to_string
    in
    let parts =
      String.split ~on:'\n' plain
      |> List.map ~f:Cstruct.of_string
      |> List.map ~f:Base64.decode
      |> List.map ~f:(fun opt -> Option.value_exn opt)
      |> List.map ~f:Cstruct.to_bytes
      |> List.map ~f:Utils.bytes_to_hex
    in
    assert (Utils._HASH_LENGTH == String.length @@ List.nth_exn parts 0) ;
    assert (Utils._HASH_LENGTH == String.length @@ List.nth_exn parts 1) ;
    Some plain
  with
  | _ ->
      None


let import ~cipher ~pass =
  let open Option in
  Encryption.decrypt ~pass cipher >>= validate_key >>| Bytes.of_string


let address pub = Utils.with_hex_prefix @@ Utils.bytes_to_hex pub

let sign = Signing.sign

let verify = Verification.verify

let show = Utils.bytes_to_hex

let load dump =
  if Utils.is_hash dump then Some (Utils.bytes_of_hex dump) else None
