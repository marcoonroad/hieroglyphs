module List = Core.List
module String = Core.String

let show pub =
 List.reduce_exn pub ~f:Utils.concat_hashes

let load text =
  let list = String.split text ~on:'-' in
  Utils.validate_key list

let address pub =
  pub
  |> show
  |> Hash.digest
  |> Utils.to_hex
