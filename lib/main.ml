module Option = Core.Option
module String = Core.String
module List = Core.List
module Bytes = Core.Bytes

type priv = bytes

type pub = bytes

let __derive = Keys.derive

let import = Keys.import

let export = Keys.export

let show = Keys.show

let load = Keys.load

let address = Keys.address

let sign = Keys.sign

let verify = Keys.verify

(*** wrappers *****************************************************************)

let __decode blob =
  let payload = Encoding.decode blob in
  Option.value_exn payload


let __split priv =
  let parts = String.split ~on:'\n' @@ Bytes.to_string priv in
  List.map ~f:__decode parts


let derive priv = Bytes.of_string @@ List.nth_exn (__split priv) 1

let __check_tail pub =
  let id = "0x" ^ Utils.bytes_to_hex pub in
  if Blacklist.exists id then None else Some pub


let __check priv = __check_tail @@ __derive priv

let check priv = __check_tail @@ derive priv

let sign ~priv:priv' ~msg =
  let priv = Bytes.of_string @@ List.nth_exn (__split priv') 0 in
  let success pub =
    let signature = sign ~priv ~msg in
    Blacklist.add @@ "0x" ^ Utils.bytes_to_hex pub ;
    Some signature
  in
  let open Option in
  check priv' >>= success


let import ~cipher ~pass =
  let open Option in
  import ~cipher ~pass
  >>= function priv -> check priv >>= (function _ -> Some priv)


let rec __generate () =
  let priv = Keys.generate () in
  let const _ _ = priv in
  let option = __check priv in
  let step = Option.value_map option ~default:__generate ~f:const in
  step ()


(* precomputed public key together with private key *)
let generate () =
  let priv = __generate () in
  let pub = __derive priv in
  let priv' = Encoding.encode @@ Bytes.to_string priv in
  let pub' = Encoding.encode @@ Bytes.to_string pub in
  Bytes.of_string (priv' ^ "\n" ^ pub')


let pair () =
  let priv = generate () in
  let pub = derive priv in
  (priv, pub)
