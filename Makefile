REBAR3 = rebar3

VERSIONS = 1.1.2 2.10.0

TEST1_VERSIONS = 1.1.2 2.10.0
TEST1_SIZES = 1M 10M 100M 1G
TEST1_TIMES = 10

TEST2_VERSION = 2.10.0
TEST2_SIZE = 1G
TEST2_ACTIVE_NS = 10 100 1000 10000
TEST2_LENGTHS = 8000000 80000000 800000000
TEST2_TIMES = 10

TEST3_VERSION = 2_so_buffer
TEST3_SIZE = 1G
TEST3_SO_BUFFERS = 1460 8192 16384 32768 65536 131072 262144 524288
TEST3_TIMES = 10

TESTS=1 2 3

RESULTDIR = result

.PHONY: test
test: all
	@for i in $(TESTS); do $(MAKE) TEST_N=$$i _test; done

.PHONY: _test
_test:
	@test -d $(RESULTDIR) || mkdir $(RESULTDIR)
	@test -n "$(TEST$(TEST_N)_TIMES)" || (echo illegal TEST_N >&2; exit 1)
	@$(MAKE) _test$(TEST_N) 2>&1 | tee $(RESULTDIR)/test$(TEST_N)-log.txt

.PHONY: _test1
_test1:
	@erl -version
	@for i in $(TEST1_VERSIONS); do \
		for j in $(TEST1_SIZES); do \
			./scripts/run.sh $$i $$j $(TEST1_TIMES); \
		done; \
	done

.PHONY: _test2
_test2:
	@erl -version
	@for i in $(TEST2_ACTIVE_NS); do \
		for j in $(TEST2_LENGTHS); do \
			./scripts/run.sh --active-n=$$i --length=$$j $(TEST2_VERSION) $(TEST2_SIZE) $(TEST2_TIMES); \
		done; \
	done

.PHONY: _test3
_test3:
	@erl -version
	@for i in $(TEST3_SO_BUFFERS); do \
		./scripts/run.sh --so-buffer=$$i $(TEST3_VERSION) $(TEST3_SIZE) $(TEST3_TIMES); \
		done; \
	done

.PHONY: all
all:
	@for i in $(VERSIONS); do $(MAKE) COWBOY_VERSION=$$i _escriptize; done
	@$(MAKE) _escriptize_so_buffer

.PHONY: clean
clean:
	@for i in $(VERSIONS); do $(MAKE) COWBOY_VERSION=$$i _clean; done


.PHONY: _escriptize
_escriptize:
	$(REBAR3) escriptize

.PHONY: _escriptize_so_buffer
_escriptize_so_buffer:
	env COWBOY_REPO=https://github.com/AoiMoe/cowboy.git COWBOY_BRANCH=feature/add_so_buffer BUILD_SUFFIX=2_so_buffer \
		$(REBAR3) escriptize

.PHONY: _clean
_clean:
	$(REBAR3) clean

.PHONY: clear_result
clear_result:
	@rm -f $(RESULTDIR)/*.tsv
	@rm -f $(RESULTDIR)/*.txt
	@rm -f $(RESULTDIR)/*.dat
