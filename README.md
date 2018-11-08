# hieroglyphs

Quantum-resistant, purely Hash-based, Stateful, One-Time Digital Signatures for OCaml.

For further information, see:
- https://en.wikipedia.org/wiki/Hash-based_cryptography
- https://blog.cryptographyengineering.com/2018/04/07/hash-based-signatures-an-illustrated-primer/

This library uses the Blake2B hash algorithm, but further / additional hashes are
planned as well. Currently, the following things are implemented now:

- [x] Importing/exporting encrypted private key (by now using ARC4).
- [ ] Built-in one-time invariant protected by a blacklist of used private keys.
- [ ] Tests covering the things here and there.
- [ ] Benchmarks against currently famous Digital Signatures algorithms (RSA family,
  Elliptic Curves family, etc).

The novel approach of this library is to sign every piece of hexadecimal character
from a given hash, so our range to sign and verify bits/bytes is smaller (we only
need 16 characters offset plus digest / fingerprint length of the message hash,
in the case of Blake2B, 128 characters).

### Disclaimer:

This library was not yet fully tested against many sort of attacks, such as timing
attacks, but nevertheless the real security lies behind the `digestif` and `nocrypto`
libraries, which provide strong hashes, strong RNGs and strong encryption. Use
with care and take responsibility by your own acts.
