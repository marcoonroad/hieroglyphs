let add address =
  let key = "blacklist/" ^ address in
  let msg = "Revoking private key ID " ^ address ^ "." in
  Store.set ~msg ~key ""


let exists address =
  let key = "blacklist/" ^ address in
  match Store.get ~key with None -> false | Some _ -> true
