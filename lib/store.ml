module String = Core.String
module Option = Core.Option
module Sys = Core.Sys
open Lwt.Infix
module GitStore = Irmin_unix.Git.FS.KV (Irmin.Contents.String)

let _HIEROGLYPHS_ROOT =
  let root = Sys.getenv "HIEROGLYPHS_ROOT" in
  let default = Sys.getenv_exn "HOME" ^ "/.hieroglyphs" in
  Option.value root ~default


let _HIEROGLYPHS_STORE = _HIEROGLYPHS_ROOT ^ "/state"

let config = Irmin_git.config ~bare:true _HIEROGLYPHS_STORE

let author = "Hieroglyphs library"

let info fmt = Irmin_unix.info ~author fmt

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


let boot () =
  let date = 946684800L (* Sat Jan 1 00:00:00 2000 +0000 *) in
  let address = "0x" ^ String.make Utils._HASH_LENGTH '0' in
  let path = ["blacklist"; address] in
  let msg = "Revoking private key ID " ^ address ^ "." in
  let info = Core.const (Irmin.Info.v ~date ~author msg) in
  let transaction () =
    GitStore.Repo.v config
    >>= fun repo ->
    GitStore.master repo >>= fun branch -> GitStore.set branch ~info path ""
  in
  Lwt_main.run (transaction ())


let () =
  boot () ;
  Irmin_unix.set_listen_dir_hook ()
