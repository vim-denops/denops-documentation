TOOLS := ${CURDIR}/.tools

.DEFAULT_GOAL := help

help:
	@cat $(MAKEFILE_LIST) | \
	    perl -ne 'print if /^\w+.*##/;' | \
	    perl -pe 's/(.*):.*##\s*/sprintf("%-20s",$$1)/eg;'

tools: FORCE	## Install development tools
	@mkdir -p ${TOOLS}
	@cargo install mdbook --root ${TOOLS}
	@cargo install mdbook-plantuml --root ${TOOLS}

fmt: FORCE	## Format code
	@deno fmt src README.md

fmt-check: FORCE	## Format check
	@deno fmt --check src README.md

gen: FORCE	## Generate codes
	@${TOOLS}/bin/mdbook build
	@make fmt

FORCE:
