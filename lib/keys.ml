module List = Core.List
module String = Core.String

let populate _ =
  ( )
  |> Random.generate
  |> Core.Int64.to_string
  |> Hash.digest
  |> Hash.digest

(* 16 hex chars and 128 chars/string length for hash under hex string format *)
let length = 16 * 128

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
