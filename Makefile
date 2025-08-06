
# Jsonnet-Input
JSONNET_FILE := mixin.jsonnet
JSON_OUTPUT := output.json
YAML_OUTPUT := output.yaml
HELM_YAML_OUTPUT := output.helm.yaml

JSONNET_BIN := $(shell which jsonnet || echo $(GOPATH)/bin/jsonnet)
JSON2YAML_BIN := $(shell which json2yaml || echo $(GOPATH)/bin/json2yaml)
JB_BIN := $(shell which jb || echo $(GOPATH)/bin/jb)

all: yaml helm


deps:
	@echo "Installing dependencies..."
	go install github.com/google/go-jsonnet/cmd/jsonnet@latest
	go install github.com/itchyny/json2yaml/cmd/json2yaml@latest
	go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest

	$(JB_BIN) install


json: deps
	@echo "Rendering Jsonnet to JSON..."
	$(JSONNET_BIN) -J vendor $(JSONNET_FILE) > $(JSON_OUTPUT)


# JSON → YAML
yaml: json
	@echo "Converting JSON to YAML..."
	$(JSON2YAML_BIN) $(JSON_OUTPUT) > $(YAML_OUTPUT)

helm: json
	@echo "Converting JSON to Helm-compatible YAML..."
	$(JSON2YAML_BIN) $(JSON_OUTPUT) | sed 's/{{/{{`{{`}}/g; s/}}/{{`}}`}}/g' > $(HELM_YAML_OUTPUT)
