Alcotest.run "hieroglyphs specification" [
  "keys-management",          Keys.suite;
  "signing-and-verification", Sign.suite
]
