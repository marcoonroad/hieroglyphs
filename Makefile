# Frontend to dune.

.PHONY: default build install uninstall test clean

default: build

build:
	dune build

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

clean:
	dune clean
# Optionally, remove all files/folders ignored by git as defined
# in .gitignore (-X).
	git clean -dfXq
