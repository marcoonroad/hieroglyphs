type priv = string list
type pub = string list

let pair ( ) =
  let priv = Keys.generate ( ) in
  let pub = Keys.derive priv in
  (priv, pub)

let generate = Keys.generate
let derive = Keys.derive

let import = Keys.import
let export = Keys.export

let sign = Signing.sign
let verify = Verification.verify
