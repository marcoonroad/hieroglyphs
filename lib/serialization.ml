module List = Core.List
module String = Core.String
module Option = Core.Option

let show pub =
  pub
  |> List.map ~f:Utils.bytes_to_hex
  |> List.reduce_exn ~f:Utils.concat_hashes


let load text =
  let list = String.split text ~on:':' in
  let open Option in
  Utils.validate_key list
  >>= fun list -> some @@ List.map ~f:Utils.bytes_of_hex list


let digest pub = pub |> show |> Hash.digest
