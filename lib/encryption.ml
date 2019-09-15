open Nocrypto.Cipher_block.AES.CBC
module Option = Core.Option
module Base64 = Nocrypto.Base64

let __digest cstruct =
  Cstruct.of_hex @@ Hash.digest @@ Cstruct.to_string cstruct


let __compute_iv cstruct =
  let digest = __digest cstruct in
  (* split 64 bytes into a pair of 32 *)
  let blob1, blob2 = Cstruct.split digest 32 in
  (* then split 32 bytes into a pair of 16 *)
  let blob3, blob4 = Cstruct.split blob1 16 in
  let blob5, blob6 = Cstruct.split blob2 16 in
  let blob7 = Nocrypto.Uncommon.Cs.xor blob3 blob4 in
  let blob8 = Nocrypto.Uncommon.Cs.xor blob5 blob6 in
  Nocrypto.Uncommon.Cs.xor blob7 blob8


let encrypt msg ~pass =
  let proof = Hash.mine pass ~difficulty:Constants._KEY_DIFFICULTY in
  let key = of_secret proof in
  let iv = __compute_iv proof in
  let blob = Utils.pad ~basis:16 msg in
  let result = encrypt ~iv ~key blob in
  result |> Base64.encode |> Cstruct.to_string


let decrypt cipher ~pass =
  let proof = Hash.mine pass ~difficulty:Constants._KEY_DIFFICULTY in
  let key = of_secret proof in
  let iv = __compute_iv proof in
  let result = cipher |> Cstruct.of_string |> Base64.decode in
  let open Option in
  result >>= fun msg -> msg |> decrypt ~iv ~key |> Utils.unpad |> some
