module String = Core.String
module Str = Re.Str

let _HASH_LENGTH = 128

let regexp = Str.regexp "^[a-f0-9]+$"

let is_hash text =
  Str.string_match regexp text 0 && String.length text = _HASH_LENGTH
