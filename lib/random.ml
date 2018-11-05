let generate ( ) =
  Nocrypto.Rng.Int64.gen Core.Int64.max_value

let _ =
  Nocrypto_entropy_unix.initialize ( )
