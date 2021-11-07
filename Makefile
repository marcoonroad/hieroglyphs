# Frontend to dune.

OCAML_VERSION := $(shell opam var switch)

.PHONY: default vendor build doc install uninstall test coverage report clean

addon:
	opam install merlin ocp-indent ocamlformat utop --yes

vendor:
	opam install . --deps-only --yes

default: build

build: vendor
	dune build

doc-index:
#	echo "" > docs/index.md
#	echo "---" >> docs/index.md
#	echo "---" >> docs/index.md
#	cat README.md >> docs/index.md
	cp README.md docs/index.md

doc: build
	opam install odoc --yes
	rm -rf docs/apiref
	mkdir -p docs/apiref
	dune build @doc
	make doc-index
	mv _build/$(OCAML_VERSION)/_doc/_html/* docs/apiref/ || \
		mv _build/default/_doc/_html/* docs/apiref/

### Alcotest environment variables:
#
#  -  ALCOTEST_VERBOSE=1
#  -  ALCOTEST_QUICK_TESTS=1
#  -  ALCOTEST_SHOW_ERRORS=1
#
spec-test: build
	dune build @test/spec/runtest -f --no-buffer -j 1

test:
	HIEROGLYPHS_KEY_DIFFICULTY=3 make spec-test

bench: clean build
	opam install core_bench --yes
	opam depext conf-secp256k1 secp256k1 --install --yes
	dune build @test/bench/runtest -f --no-buffer -j 1 --auto-promote \
		--diff-command="git diff --unified=10 --break-rewrites --no-index --exit-code --histogram --word-diff=none --color --no-prefix" || echo \
		"\n\n=== Differences detected! ===\n\n"

install: build
	dune install

uninstall:
	dune uninstall

coverage: clean
	rm -rf docs/coverage
	rm -vf `find . -name 'bisect*.out'`
	mkdir -p docs/coverage
	BISECT_ENABLE=YES \
	HIEROGLYPHS_KEY_DIFFICULTY=3 \
	make spec-test
	bisect-ppx-report -html coverage/ -I _build/default `find . -name 'bisect*.out'`
	make doc-index
	mv coverage/* docs/coverage/
	bisect-ppx-report -I _build/default/ -text - `find . -name 'bisect*.out'`

report: coverage
	opam install ocveralls --yes
	ocveralls --prefix '_build/default' `find . -name 'bisect*.out'` --send

blacklist: build
	irmin init --bare --root=${HOME}/.hieroglyphs/state

clean:
	dune clean
# Optionally, remove all files/folders ignored by git as defined
# in .gitignore (-X).
# git clean -dfXq
