let add address =
  let key = "blacklist/" ^ address in
  let msg = "Revoking Private Key " ^ address ^ "." in
  Store.set ~msg ~key ""

let exists address =
  let key = "blacklist/" ^ address in
  match Store.get ~key with
  | None -> false
  | Some _ -> true

let ( ) =
  Irmin_unix.set_listen_dir_hook ()
