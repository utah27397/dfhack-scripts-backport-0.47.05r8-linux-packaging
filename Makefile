.DEFAULT_GOAL := build

PACKAGE := $(shell awk '$$1 == "Package:" { print $$2; exit }' DEBIAN/control)
VERSION := $(shell awk '$$1 == "Version:" { print $$2; exit }' DEBIAN/control)
ARCH := $(shell awk '$$1 == "Architecture:" { print $$2; exit }' DEBIAN/control)
OUTPUT ?= ../$(PACKAGE)_$(VERSION)_$(ARCH).deb
BACKPORT_SOURCE_DIR ?= upstream/scripts
SCRIPT_INSTALL_ROOT ?= opt/dfhack-scripts-backport-0.47.05r8
SCRIPT_INSTALL_DIR ?= hack/scripts

.PHONY: build check-source clean source-info

check-source:
	@set -eu; \
	for required in \
		DEBIAN/control \
		DEBIAN/postrm \
		DEBIAN/preinst \
		README.md \
		scripts/dfhack-launcher \
		"$(BACKPORT_SOURCE_DIR)/Makefile"; \
	do \
		if [ ! -e "$$required" ]; then \
			echo "missing package file: $$required" >&2; \
			echo "run: git submodule update --init --recursive" >&2; \
			exit 1; \
		fi; \
	done

source-info: check-source
	$(MAKE) -C "$(BACKPORT_SOURCE_DIR)" source-info

build: check-source
	@set -eu; \
	tmp=$$(mktemp -d "$${TMPDIR:-/tmp}/$(PACKAGE)-build.XXXXXX"); \
	trap 'rm -rf "$$tmp"' EXIT HUP INT TERM; \
	mkdir -p "$$tmp/pkg" "$$tmp/scripts"; \
	$(MAKE) -C "$(BACKPORT_SOURCE_DIR)" build OUTPUT_DIR="$$tmp/scripts"; \
	cp -a DEBIAN "$$tmp/pkg/"; \
	mkdir -p "$$tmp/pkg/$(SCRIPT_INSTALL_ROOT)/$(SCRIPT_INSTALL_DIR)"; \
	cp -a "$$tmp/scripts/." "$$tmp/pkg/$(SCRIPT_INSTALL_ROOT)/$(SCRIPT_INSTALL_DIR)/"; \
	mkdir -p "$$tmp/pkg/usr/bin" "$$tmp/pkg/usr/share/doc/$(PACKAGE)"; \
	cp -a scripts/dfhack-launcher "$$tmp/pkg/usr/bin/dfhack"; \
	cp -a "$(BACKPORT_SOURCE_DIR)/README.md" "$$tmp/pkg/usr/share/doc/$(PACKAGE)/README.md"; \
	chmod 755 "$$tmp/pkg/DEBIAN/postrm"; \
	chmod 755 "$$tmp/pkg/DEBIAN/preinst"; \
	chmod 755 "$$tmp/pkg/usr/bin/dfhack"; \
	dpkg-deb --root-owner-group --build "$$tmp/pkg" "$(OUTPUT)"

clean:
	rm -rf build
	$(MAKE) -C "$(BACKPORT_SOURCE_DIR)" clean
