module List = Core.List
module String = Core.String
module Option = Core.Option

let digest = Hash.hash_bytes_seq

let load text =
  let list = String.split text ~on:':' in
  let open Option in
  Utils.validate_key list
  >>= fun list -> some @@ List.map ~f:Utils.bytes_of_hex list
