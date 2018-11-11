module Sys = Core.Sys
module Unix = Core.Unix
module Out_channel = Core.Out_channel

let _HOME = Sys.getenv_exn "HOME"
let _BLACKLIST_ROOTDIR = _HOME ^ "/.hieroglyphs-blacklist"

let add address =
  let filename = _BLACKLIST_ROOTDIR ^ "/" ^ address in
  let filehandler = Out_channel.create ~append:false ~binary:false ~fail_if_exists:true filename in
  Out_channel.output_string filehandler "";
  Out_channel.close filehandler

let exists address =
  let open Sys in
  let filename = _BLACKLIST_ROOTDIR ^ "/" ^ address in
  file_exists_exn ~follow_symlinks:true filename

let ( ) =
  Unix.mkdir_p _BLACKLIST_ROOTDIR
