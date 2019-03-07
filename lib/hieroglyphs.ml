module Option = Core.Option

type priv = bytes

type pub = bytes list

let derive = Keys.derive

let pair = Keys.pair

let import = Keys.import

let export = Keys.export

let show = Keys.show

let load = Keys.load

let address = Keys.address

let sign = Keys.sign

let verify = Keys.verify

(*** wrappers *****************************************************************)

let __check priv =
  let pub = derive priv in
  let id = address pub in
  if Blacklist.exists id then None else Some pub


let sign ~priv ~msg =
  let success pub =
    let signature = sign ~priv ~msg in
    Blacklist.add (address pub) ;
    Some signature
  in
  let open Option in
  __check priv >>= success


let import ~cipher ~pass =
  let open Option in
  import ~cipher ~pass
  >>= function priv -> __check priv >>= (function _ -> Some priv)


let rec generate () =
  let priv = Keys.generate () in
  let const _ _ = priv in
  let option = __check priv in
  let step = Option.value_map option ~default:generate ~f:const in
  step ()
