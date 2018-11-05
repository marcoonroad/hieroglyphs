type pair = {
  priv : string list;
  pub : string list;
}

let pair ( ) =
  let priv = Keys.generate ( ) in
  let pub = Keys.derive priv in
  { priv; pub }

let sign = Signing.sign
let verify = Verification.verify
