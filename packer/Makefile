#!/usr/bin/make -f

SHELL := /bin/sh
.SHELLFLAGS := -euc

PACKER := $(shell command -v packer 2>/dev/null)

PACKER_WORK_DIR := ./
PACKER_CACHE_DIR := ./packer_cache/
PACKER_HCLOUD_OUT := ./dist/hcloud/wireguard.log

##################################################
## "all" target
##################################################

.PHONY: all
all: build

##################################################
## "build" target
##################################################

.PHONY: build

.PHONY: build-hcloud
build-hcloud: $(PACKER_HCLOUD_OUT)

$(PACKER_HCLOUD_OUT):
	mkdir -p '$(dir $(PACKER_HCLOUD_OUT))'
	'$(PACKER)' build -force -only=hcloud.main '$(PACKER_WORK_DIR)' 2>&1 | tee '$(PACKER_HCLOUD_OUT)'

##################################################
## "clean" target
##################################################

.PHONY: clean
clean:
	rm -rf '$(PACKER_HCLOUD_OUT)' '$(PACKER_CACHE_DIR)'
