# Frontend to dune.

.PHONY: default vendor build doc install uninstall test coverage report clean

vendor:
	opam install . --deps-only --yes

default: build

build:
	dune build

doc-index:
#	echo "" > docs/index.md
#	echo "---" >> docs/index.md
#	echo "---" >> docs/index.md
#	cat README.md >> docs/index.md
	cp README.md docs/index.md

doc: build
	rm -rf docs/apiref
	mkdir -p docs/apiref
	dune build @doc
	make doc-index
	mv _build/default/_doc/_html/* docs/apiref/

### Alcotest environment variables:
#
#  -  ALCOTEST_VERBOSE=1
#  -  ALCOTEST_QUICK_TESTS=1
#  -  ALCOTEST_SHOW_ERRORS=1
#
test:
	dune build @test/spec/runtest -f --no-buffer -j 1

bench:
	dune build @test/bench/runtest -f --no-buffer -j 1

install:
	dune install

uninstall:
	dune uninstall

coverage: clean vendor
	rm -rf docs/coverage
	rm -vf `find . -name 'bisect*.out'`
	mkdir -p docs/coverage
	BISECT_ENABLE=YES make test
	bisect-ppx-report -html coverage/ -I _build/default `find . -name 'bisect*.out'`
	make doc-index
	mv coverage/* docs/coverage/
	bisect-ppx-report -I _build/default/ -text - `find . -name 'bisect*.out'`

report: coverage
	opam install ocveralls --yes
	ocveralls --prefix '_build/default' `find . -name 'bisect*.out'` --send

blacklist:
	irmin init --bare --root=${HOME}/.hieroglyphs/blacklist

clean:
	dune clean
# Optionally, remove all files/folders ignored by git as defined
# in .gitignore (-X).
# git clean -dfXq
