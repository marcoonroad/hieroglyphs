let _MIN_RANDOM = "1" ^ Core.String.init 511 ~f:(Core.const '0')

let _MAX_RANDOM = Core.String.init 512 ~f:(Core.const '1')

let _min_random = Z.of_string_base 2 _MIN_RANDOM

let _max_random = Z.of_string_base 2 _MAX_RANDOM

let generate512 () =
  let number = Nocrypto.Rng.Z.gen_r _min_random _max_random in
  Cstruct.to_bytes @@ Nocrypto.Numeric.Z.to_cstruct_be number


let _ = Nocrypto_entropy_unix.initialize ()
