# Use start_sasl for development.
# For production, http://stackoverflow.com/questions/7032665/erlang-start-application-in-production 
# Migrate to rebar3 https://www.rebar3.org/docs/from-rebar-2x-to-rebar3 as it goes out from beta, and 
# automatic reload plugin is working, and intelliJ integration also. 
# About this file: http://blog.erlware.org/universal-makefile-for-erlang-projects-that-use-rebar/ 
#

ERLFLAGS= -pa $(CURDIR)/.eunit -pa $(CURDIR)/ebin -pa $(CURDIR)/deps/*/ebin \
    -boot start_sasl \
    -boot sync \
    -name devnode@127.0.0.1 \
    -setcookie work_capital_cookie \
    +K true \
    +P 65536 

DEPS_PLT=$(CURDIR)/.deps_plt
DEPS=erts kernel stdlib

# =============================================================================
# Verify that the programs we need to run are installed on this system
# =============================================================================
ERL = $(shell which erl)

ifeq ($(ERL),)
$(error "Erlang not available on this system")
endif

REBAR=$(shell which rebar)

ifeq ($(REBAR),)
$(error "Rebar not available on this system")
endif

.PHONY: all compile doc clean test dialyzer typer shell distclean pdf \
  update-deps clean-common-test-data rebuild

all: deps compile dialyzer test

# =============================================================================
# Rules to build the system
# =============================================================================



erlang:
	erlc 	

scala:
	scalac

doc:
	$(REBAR) skip_deps=true doc

eunit: compile clean-common-test-data
	$(REBAR) skip_deps=true eunit

test: compile eunit

$(DEPS_PLT):
	@echo Building local plt at $(DEPS_PLT)
	@echo
	dialyzer --output_plt $(DEPS_PLT) --build_plt \
	   --apps $(DEPS) -r deps

dialyzer: $(DEPS_PLT)
	dialyzer --fullpath --plt $(DEPS_PLT) -Wrace_conditions -r ./ebin

typer:
	typer --plt $(DEPS_PLT) -r ./src

shell: deps compile
# You often want *rebuilt* rebar tests to be available to the
# shell you have to call eunit (to get the tests
# rebuilt). However, eunit runs the tests, which probably
# fails (thats probably why You want them in the shell). This
# runs eunit but tells make to ignore the result.
	- @$(REBAR) skip_deps=true eunit
	@$(ERL) $(ERLFLAGS)

pdf:
	pandoc README.md -o README.pdf

clean:
	- rm -rf $(CURDIR)/*/*.beam
	- rm -rf $(CURDIR)/*/*.class


