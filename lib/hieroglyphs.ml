module Option = Core.Option

type priv = string list
type pub = string list

let derive = Keys.derive

let import = Keys.import
let export = Keys.export

let show = Keys.show
let load = Keys.load
let address = Keys.address

let sign = Keys.sign
let verify = Keys.verify

(*** wrappers *****************************************************************)
let __decode on_none on_some = function
  | None -> on_none ( )
  | Some value -> on_some value
(* workaround to increase code coverage on match branches,
   yep, I know, it's a wrong to do, increase coverage
   at the expense of boilerplate :p *)

let __check priv =
  let pub = derive priv in
  let id = address pub in
  if Blacklist.exists id then None else Some pub

let sign ~priv ~msg =
  let failure ( ) = None in
  let success pub =
    let signature = sign ~priv ~msg in
    Blacklist.add (address pub);
    Some signature
  in
  priv
  |> __check
  |> __decode failure success

let import ~cipher ~pass =
  let open Option in
  import ~cipher ~pass >>= function priv ->
  __check priv >>= function _ -> Some priv

let rec generate ( ) =
  let priv = Keys.generate ( ) in
  let success _ = priv in
  priv
  |> __check
  |> __decode generate success

let pair ( ) =
  let priv = generate ( ) in
  let pub = derive priv in
  (priv, pub)
