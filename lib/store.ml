module String = Core.String
module Sys = Core.Sys

open Lwt.Infix

module GitStore = Irmin_unix.Git.FS.KV(Irmin.Contents.String)

let _HIEROGLYPHS_ROOT = match Sys.getenv "HIEROGLYPHS_ROOT" with
  | None -> Sys.getenv_exn "HOME" ^ "/.hieroglyphs"
  | Some directory -> directory
let _HIEROGLYPHS_STORE = _HIEROGLYPHS_ROOT ^ "/state"

let config = Irmin_git.config ~bare:true _HIEROGLYPHS_STORE
let info fmt = Irmin_unix.info fmt

let set ?msg:(msg="Set key...") ~key value =
  let path = String.split ~on:'/' key in
  let msg = info (format_of_string "%s") msg in
  let transaction ( ) =
    GitStore.Repo.v config >>= function repo ->
      GitStore.master repo >>= function branch ->
        GitStore.set branch ~info:msg path value
  in
  Lwt_main.run (transaction ( ))

let get ~key =
  let path = String.split ~on:'/' key in
  let transaction ( ) =
    GitStore.Repo.v config >>= function repo ->
      GitStore.master repo >>= function branch ->
        GitStore.get branch path
  in
  try Some (Lwt_main.run (transaction ( )))
  with Invalid_argument _ -> None

let ( ) =
  Irmin_unix.set_listen_dir_hook ()
