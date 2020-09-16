(* Environment Variables:
  - ALCOTEST_QUICK_TESTS
  - ALCOTEST_SHOW_ERRORS
  - ALCOTEST_VERBOSE
*)

;;
Alcotest.run
  "hieroglyphs specification"
  [("keys-management", Keys.suite); ("signing-and-verification", Sign.suite)]
