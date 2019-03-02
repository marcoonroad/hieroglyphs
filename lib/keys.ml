module List = Core.List
module String = Core.String
module Float = Core.Float
module Int64 = Core.Int64
module Option = Core.Option

(*
let populate time _ =
  ()
  |> Random.generate
  |> Int64.to_string
  |> String.( ^ ) time
  |> Hash.digest
  |> Hash.digest
*)

let length = Utils._KEY_LENGTH

(*
let timestamp () = () |> Unix.gettimeofday |> Float.to_string

let generate () =
  let time = timestamp () in
  List.init length ~f:(populate time)
*)

let _random_hex _ = Cstruct.of_bytes @@ Random.generate512 ()

let _int_to_cstruct number = Cstruct.of_string @@ string_of_int number

let _hash_both prefix suffix =
  Cstruct.append prefix suffix |> Cstruct.to_bytes |> Hash.digest_bytes


let generate () =
  let nums = List.init length ~f:_int_to_cstruct in
  let rand = _random_hex () in
  List.map nums ~f:(_hash_both rand)


let derive priv = List.map priv ~f:Hash.digest_bytes

let pair () =
  let priv = generate () in
  let pub = derive priv in
  (priv, pub)


let export ~priv ~pass =
  priv
  |> List.map ~f:Utils.bytes_to_string
  |> List.reduce_exn ~f:Utils.concat_hashes
  |> Encryption.encrypt ~pass


let import ~cipher ~pass =
  let open Option in
  Encryption.decrypt ~pass cipher
  >>= fun result ->
  result
  |> String.split ~on:'-'
  |> Utils.validate_key
  >>= fun list -> some @@ List.map list ~f:Utils.bytes_of_string


let load = Serialization.load

let show = Serialization.show

let address = Serialization.address

let sign = Signing.sign

let verify = Verification.verify
