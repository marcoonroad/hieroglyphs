module List = Core.List
module String = Core.String

let populate _ =
  ( )
  |> Random.generate
  |> Core.Int64.to_string
  |> Hash.digest
  |> Hash.digest

let length = Utils._KEY_LENGTH

let generate ( ) =
  List.init length ~f:populate

let derive priv =
  List.map priv ~f:Hash.digest

let export ~priv ~pass =
  priv
  |> List.reduce_exn ~f:Utils.concat_hashes
  |> Encryption.encrypt ~pass

let import ~cipher ~pass =
  cipher
  |> Encryption.decrypt ~pass
  |> String.split ~on:'-'
  |> Utils.validate_key

let load = Serialization.load
let show = Serialization.show
let address = Serialization.address

let sign = Signing.sign
let verify = Verification.verify
