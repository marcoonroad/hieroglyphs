let populate _ =
  ( )
  |> Random.generate
  |> Core.Int64.to_string
  |> Hash.digest
  |> Hash.digest

(* 16 hex chars and 128 chars/string length for hash under hex string format *)
let length = 16 * 128

let generate ( ) =
  Core.List.init length ~f:populate

let derive priv =
  Core.List.map priv ~f:Hash.digest
