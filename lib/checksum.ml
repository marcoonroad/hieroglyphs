module List = Core.List
module Bytes = Core.Bytes
module Char = Core.Char
module Int = Core.Int

let __compute_diff byte = 255 - Char.to_int byte

let __compute_sum input =
  input
  |> Bytes.to_list
  |> List.map ~f:__compute_diff
  |> List.reduce_exn ~f:( + )


let __generate input =
  let number = Z.of_int @@ __compute_sum input in
  Cstruct.to_bytes
  @@ Utils.pad_cstruct 2
  @@ Nocrypto.Numeric.Z.to_cstruct_be number


let make_payload input =
  let digest = Hash.digest_bytes ~steps:1 input in
  let checksum = Bytes.to_string @@ __generate digest in
  let blob = Bytes.to_string digest in
  let payload = Bytes.of_string (blob ^ checksum) in
  payload
