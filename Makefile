JSONNET_FILE ?= mixin.libsonnet
YAML_FILE ?= alerts.yaml

.PHONY: all init install update clean render yaml

all: deps  install build

deps:
	go install github.com/monitoring-mixins/mixtool/cmd/mixtool@master
	go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
	go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest


install:
	@echo "Installing dependencies..."
	jb install github.com/oliver006/redis_exporter/contrib/redis-mixin


build:
	jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' > alerts.yaml
clean:
	@echo "Cleaning vendor and output..."
#	rm -rf vendor/ $(YAML_FILE)