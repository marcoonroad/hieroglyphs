module List = Core.List
module String = Core.String
module Float = Core.Float
module Int64 = Core.Int64
module Option = Core.Option

let populate time _ =
  ()
  |> Random.generate
  |> Int64.to_string
  |> String.( ^ ) time
  |> Hash.digest
  |> Hash.digest


let length = Utils._KEY_LENGTH

let timestamp () = () |> Unix.gettimeofday |> Float.to_string

let generate () =
  let time = timestamp () in
  List.init length ~f:(populate time)


let derive priv = List.map priv ~f:Hash.digest

let export ~priv ~pass =
  priv |> List.reduce_exn ~f:Utils.concat_hashes |> Encryption.encrypt ~pass


let import ~cipher ~pass =
  let open Option in
  Encryption.decrypt ~pass cipher
  >>= fun result -> result |> String.split ~on:'-' |> Utils.validate_key


let load = Serialization.load

let show = Serialization.show

let address = Serialization.address

let sign = Signing.sign

let verify = Verification.verify
