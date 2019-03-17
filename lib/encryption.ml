open Nocrypto.Cipher_block.AES.CBC
module Option = Core.Option
module Base64 = Nocrypto.Base64

let digest cstruct =
  let digest = Nocrypto.Hash.SHA256.digest cstruct in
  let left, right = Cstruct.split digest 16 in
  (* split 32 bytes into a pair of 16 *)
  Nocrypto.Uncommon.Cs.xor left right


let encrypt msg ~pass =
  let proof = Hash.mine pass ~difficulty:5 in
  let key = of_secret proof in
  let iv = digest proof in
  let result = encrypt ~iv ~key (Utils.pad ~basis:16 msg) in
  result |> Base64.encode |> Cstruct.to_string


let decrypt cipher ~pass =
  let proof = Hash.mine pass ~difficulty:5 in
  let key = of_secret proof in
  let iv = digest proof in
  let result = cipher |> Cstruct.of_string |> Base64.decode in
  let open Option in
  result
  >>= fun msg ->
  msg |> decrypt ~iv ~key |> Cstruct.to_string |> Utils.unpad |> some
