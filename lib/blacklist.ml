module Unix = Core.Unix
module String = Core.String
module Sys = Core.Sys

open Lwt.Infix

module Store = Irmin_unix.Git.FS.KV(Irmin.Contents.String)

let split address =
  let length = String.length address in
  let directory = String.sub ~pos:2 ~len:2 address in
  let filename = String.sub ~pos:4 ~len:(length - 4) address in
  (directory, filename)

let _CONFIG_DIR = match Sys.getenv "HIEROGLYPHS_ROOT" with
  | None -> Sys.getenv_exn "HOME" ^ "/.hieroglyphs"
  | Some directory -> directory
let _BLACKLIST_ROOTDIR = _CONFIG_DIR ^ "/blacklist"

let config = Irmin_git.config ~bare:true _BLACKLIST_ROOTDIR
let info fmt = Irmin_unix.info fmt

let add address =
  let (directory, filename) = split address in
  let path = [directory; filename] in
  let msg = info "Revoking Private Key." in
  let transaction ( ) =
    Store.Repo.v config >>= function repo ->
    Store.master repo >>= function branch ->
    Store.set branch ~info:msg path ""
  in
  Lwt_main.run (transaction ( ))

let exists address =
  let (directory, filename) = split address in
  let path = [directory; filename] in
  let transaction ( ) =
    Store.Repo.v config >>= function repo ->
    Store.master repo >>= function branch ->
    Store.get branch path
  in
  try ignore(Lwt_main.run (transaction ( ))); true
  with Invalid_argument _ -> false

let ( ) =
  Unix.mkdir_p _CONFIG_DIR;
  Unix.mkdir_p _BLACKLIST_ROOTDIR;
  Irmin_unix.set_listen_dir_hook ()
