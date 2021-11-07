module Base64 = Nocrypto.Base64
module Option = Core.Option

let encode payload =
  Cstruct.to_string @@ Base64.encode @@ Cstruct.of_string payload


let decode blob =
  let open Option in
  blob |> Cstruct.of_string |> Base64.decode >>| Cstruct.to_string
