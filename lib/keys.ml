module List = Core.List
module String = Core.String
module Float = Core.Float
module Int64 = Core.Int64
module Option = Core.Option

let length = Utils._KEY_LENGTH

let generate () = Random.generate512 ()

let derive priv =
  let pieces = Utils.generate_pieces ~digest:Hash.digest_bytes priv in
  List.map pieces ~f:Hash.digest_bytes


let pair () =
  let priv = generate () in
  let pub = derive priv in
  (priv, pub)


let export ~priv ~pass = Encryption.encrypt ~pass @@ Utils.bytes_to_string priv

let validate_key plain =
  if String.length plain == Utils._HASH_LENGTH then Some plain else None


let import ~cipher ~pass =
  let open Option in
  Encryption.decrypt ~pass cipher >>= validate_key >>| Utils.bytes_of_string


let load = Serialization.load

let show = Serialization.show

let address = Serialization.address

let sign = Signing.sign

let verify = Verification.verify
