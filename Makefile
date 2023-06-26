REBAR3 = rebar3

VERSIONS = 1.1.2 2.10.0
SIZES = 1M 10M 100M 1G
TIMES = 10

RESULTDIR = result

.PHONY: test
test: all
	@test -d $(RESULTDIR) || mkdir $(RESULTDIR)
	@$(MAKE) _test 2>&1 | tee $(RESULTDIR)/test-log.txt

.PHONY: _test
_test:
	@erl -version
	@for i in $(VERSIONS); do \
		for j in $(SIZES); do \
			./scripts/run.sh $$i $$j $(TIMES); \
		done; \
	done

.PHONY: all
all:
	@for i in $(VERSIONS); do $(MAKE) COWBOY_VERSION=$$i _escriptize; done

.PHONY: clean
clean:
	@for i in $(VERSIONS); do $(MAKE) COWBOY_VERSION=$$i _clean; done


.PHONY: _escriptize
_escriptize:
	$(REBAR3) escriptize


.PHONY: _clean
_clean:
	$(REBAR3) clean

.PHONY: clear_result
clear_result:
	@rm -f $(RESULTDIR)/*.tsv
	@rm -f $(RESULTDIR)/*.txt
	@rm -f $(RESULTDIR)/*.dat
