(* TODO

   Run a benchmark test where our implementation must be fast enough in given
   metrics (for instance, signing must be faster than X.YZ seconds). A good library
   to create benchmarks is the Jane Street's core_bench.

*)

open Core_bench.Bench
module Command = Core.Command

let suite = Hiero.suite

let _ =
  Command.run (make_command suite)
