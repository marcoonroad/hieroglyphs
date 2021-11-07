module List = Core.List
module String = Core.String
module Option = Core.Option

let digest = Hash.hash_bytes_seq

let load signature =
  let open Option in
  Encoding.decode signature
  >>= fun signature' ->
  let decoded = Cstruct.of_string signature' in
  let pieces = Utils.__split_cstruct decoded in
  Utils.validate_blob_key pieces
  >>= fun validated -> some @@ List.map ~f:Cstruct.to_bytes validated
