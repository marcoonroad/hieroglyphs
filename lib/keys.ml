module List = Core.List
module String = Core.String
module Float = Core.Float
module Int64 = Core.Int64
module Option = Core.Option

let generate () = Random.generate512 ()

let genpub priv =
  let pieces = Utils.generate_pieces ~digest:Hash.digest_bytes priv in
  List.map pieces ~f:Hash.digest_bytes


let derive priv = Utils.bytes_of_string @@ Serialization.digest @@ genpub priv

let export ~priv ~pass = Encryption.encrypt ~pass @@ Utils.bytes_to_string priv

let validate_key plain =
  if String.length plain == Utils._HASH_LENGTH then Some plain else None


let import ~cipher ~pass =
  let open Option in
  Encryption.decrypt ~pass cipher >>= validate_key >>| Utils.bytes_of_string


let address pub = Utils.to_hex @@ Utils.bytes_to_string pub

let sign = Signing.sign

let verify = Verification.verify

let show = Utils.bytes_to_string

let load dump =
  if Utils.is_hash dump then Some (Utils.bytes_of_string dump) else None
