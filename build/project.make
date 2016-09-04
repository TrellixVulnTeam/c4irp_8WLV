PROJECT := chirp
GIT_HUB := https://github.com/concretecloud/c4irp

include build/pyproject/Makefile

FAIL_UNDER := 95  # TODO: remove!!

SRCS=$(wildcard src/*.c)
COVOUT=$(SRCS:.c=.c.gcov)
DOCC=$(wildcard src/*.c)
DOCH=$(wildcard src/*.h) $(wildcard include/*.h)
DOCRST=$(DOCC:.c=.c.rst) $(DOCH:.h=.h.rst)

vi:  ## Start a vim editing the imporant files
	vim *.rst src/*.c src/*.h c4irp/*.py chirp_cffi/*.py include/*.h doc/ref/* config.defs.h makefile.cmd Makefile

lldb: all  ## Build and run py.test in lldb
	echo lldb `pyenv which python` -- -m pytest -x
	lldb `pyenv which python` -- -m pytest -x

test_ext: coala cpp-check test-lib doc-all coverage

doc-all: $(DOCRST) doc  ## Build using c2rst and then generate docs

cpp-check:  ## Run cppcheck on the project
	cppcheck -v --std=c99 -Iinclude -I$(LIBUVD)/include --config-exclude=$(LIBUVD)/include -D_SGLIB__h_ --error-exitcode=1 --inline-suppr --enable=warning,style,performance,portability,information,missingInclude src/

test-lib:
	make -f build/build.make test-lib

genhtml:  ## Generate html coverage report
	mkdir -p lcov_tmp
	cd lcov_tmp && genhtml --config-file ../lcovrc ../app_total.info
	cd lcov_tmp && open index.html

ifeq ($(PYPY),0)
coverage:
else
coverage: $(COVOUT)
endif

%.c.gcov: %.c
ifeq ($(CC),clang)
	llvm-cov $<
else
	gcov $<
endif
	mv *.c.gcov src/
	!(grep -v "// NOCOV" $@ | grep -E "\s+#####:")

%.c.rst: %.c
	pyproject/c2rst $<

%.h.rst: %.h
	pyproject/c2rst $<
