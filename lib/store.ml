module String = Core.String
module Sys = Core.Sys
open Lwt.Infix
module GitStore = Irmin_unix.Git.FS.KV (Irmin.Contents.String)

let failure () = Sys.getenv_exn "HOME" ^ "/.hieroglyphs"

let success = Utils.id

let _HIEROGLYPHS_ROOT =
  Sys.getenv "HIEROGLYPHS_ROOT" |> Utils.__decode failure success


let _HIEROGLYPHS_STORE = _HIEROGLYPHS_ROOT ^ "/state"

let config = Irmin_git.config ~bare:true _HIEROGLYPHS_STORE

let info fmt = Irmin_unix.info fmt

let set ~msg ~key value =
  let path = String.split ~on:'/' key in
  let msg = info (format_of_string "%s") msg in
  let transaction () =
    GitStore.Repo.v config
    >>= fun repo ->
    GitStore.master repo
    >>= fun branch -> GitStore.set branch ~info:msg path value
  in
  Lwt_main.run (transaction ())


let get ~key =
  let path = String.split ~on:'/' key in
  let transaction () =
    GitStore.Repo.v config
    >>= fun repo ->
    GitStore.master repo >>= fun branch -> GitStore.get branch path
  in
  try Some (Lwt_main.run (transaction ())) with Invalid_argument _ -> None


let () = Irmin_unix.set_listen_dir_hook ()
