module String = Core.String
module List = Core.List

let verify ~pub ~msg ~signature =
  let indexed_keys = Utils.indexed_keys msg in
  let hashes = String.split signature ~on:'-' in
  let proofs = List.zip_exn indexed_keys hashes in
  Utils.verify_with ~matrix:pub ~digest:Hash.digest proofs
