# hieroglyphs

Quantum-resistant, purely Hash-based, Stateful, One-Time Digital Signatures for OCaml.

<div align="center">
<a style="margin: 0.1em;" href="https://travis-ci.com/marcoonroad/hieroglyphs">
<img src="https://img.shields.io/travis/com/marcoonroad/hieroglyphs.svg?logo=travis&style=flat-square"/></a>
<a style="margin: 0.1em;" href="https://coveralls.io/github/marcoonroad/hieroglyphs?branch=master">
<img src="https://img.shields.io/coveralls/github/marcoonroad/hieroglyphs.svg?style=flat-square"/></a>
<a style="margin: 0.1em;" href="https://github.com/marcoonroad/hieroglyphs/blob/master/LICENSE">
<img src="https://img.shields.io/github/license/marcoonroad/hieroglyphs.svg?style=flat-square"/> </a>
<a style="margin: 0.1em;" href="https://github.com/marcoonroad/hieroglyphs/compare">
<img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square&logo=github"/>
</a>
<a style="margin: 0.1em;" href="https://www.blockchain.com/btc/address/1PEpBFvkKQtSHj56dCGgDFQBwz45VpMTTQ">
<img src="https://img.shields.io/badge/donate-BTC-yellow.svg?logo=bitcoin&style=flat-square"/>
</a>
</div>

---

For further information, see:
- [this wikipedia entry](https://en.wikipedia.org/wiki/Hash-based_cryptography)
- [this blog post](https://blog.cryptographyengineering.com/2018/04/07/hash-based-signatures-an-illustrated-primer/)

This library uses the Blake2B hash algorithm, but further / additional hashes are
planned as well. Currently, the following things are implemented now:

- [x] Importing/exporting encrypted private key (by now using ARC4).
- [x] Public Key serialization+validation (to share and receive such key for verification).
- [x] Built-in one-time invariant protected by a blacklist of used private keys.
- [x] Tests covering the things here and there.
- [ ] Benchmarks against currently famous Digital Signatures algorithms (RSA family,
  Elliptic Curves family, etc).
- [x] API documentation for the project (I should prefer automatic generation of
  documentation tools and provide the API documentation online under GH pages).
- [ ] Stress tests and prediction/timing simulated attacks, to prove the underlying
  library security and Private Key collision-free/resistance semantics.

The novel approach of this library is to sign every piece of hexadecimal character
from a given hash, so our range to sign and verify bits/bytes is smaller (we only
need 16 characters offset plus digest / fingerprint length of the message hash,
in the case of Blake2B, 128 characters). By hashing beforehand our message, we
can sign any size/length of input message, our signature, private key and public
key stay on the same size.


### Installation:

If this library is available on OPAM:

```shell
$ opam install hieroglyphs
```

Otherwise, through Dune build system:

```shell
$ dune install
```

### Usage:

(Assuming you've linked this library as `hieroglyphs`...)

```ocaml
module Hg = Hieroglyphs

let (priv, pub) = Hg.pair ( ) in
let msg = "Hello, World!" in
match Hg.sign ~priv ~msg with
| None -> failwith "Private key was already signed!"
| Some signature -> assert (Hg.verify ~pub ~msg ~signature)
```

For the complete API reference, check the docs
[here](https://marcoonroad.github.io/hieroglyphs/apiref/). Coverage reports are
shown at this [page](https://marcoonroad.github.io/hieroglyphs/coverage/).

### Disclaimer:

This library was not yet fully tested against many sort of attacks, such as timing
attacks, but nevertheless the real security lies behind the `digestif` and `nocrypto`
libraries, which both provide strong hashes, strong RNGs and strong encryption. Use
with care and take responsibility by your own acts.
