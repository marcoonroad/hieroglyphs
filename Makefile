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
	dune runtest -f --no-buffer

install:
	dune install

uninstall:
	dune uninstall

clean:
	dune clean
# Optionally, remove all files/folders ignored by git as defined
# in .gitignore (-X).
	git clean -dfXq
