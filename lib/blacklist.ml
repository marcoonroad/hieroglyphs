let _PREFIX = "blacklist/"

let add address =
  let key = _PREFIX ^ address in
  let msg = "Revoking private key for public key " ^ address ^ "." in
  Store.set ~msg ~key ""


let exists address =
  let key = _PREFIX ^ address in
  match Store.get ~key with None -> false | Some _ -> true
