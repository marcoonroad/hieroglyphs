open Core_bench.Bench
module Command = Core.Command

let suite = Hiero.suite @ Rsa_pss.suite

let _ =
  Command.run (make_command suite)
