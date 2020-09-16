module Sys = Core.Sys
module Option = Core.Option
module Int = Core.Int

let get variable default =
  let optional = Sys.getenv variable in
  Option.value optional ~default


let _ROOT =
  let default = Sys.getenv_exn "HOME" ^ "/.hieroglyphs" in
  get "HIEROGLYPHS_ROOT" default


let _KEY_DIFFICULTY = get "HIEROGLYPHS_KEY_DIFFICULTY" "5" |> Int.of_string
