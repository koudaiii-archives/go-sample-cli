LDFLAGS := -ldflags="-s -w"
GLIDE_VERSION := 0.11.1
GO15VENDOREXPERIMENT=1
GOFMT_FILES?=$$(find . -name '*.go' | grep -v vendor)
NAME=go-sample-cli

build: deps
	go build $(LDFLAGS) -o ./bin/$(NAME)

.PHONY: ci-build
ci-build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o ./bin/$(NAME)

.PHONY: deps
deps: glide
	./glide install

glide:
ifeq ($(shell uname),Darwin)
	curl -fL https://github.com/Masterminds/glide/releases/download/v$(GLIDE_VERSION)/glide-v$(GLIDE_VERSION)-darwin-amd64.zip -o glide.zip
	unzip glide.zip
	mv ./darwin-amd64/glide glide
	rm -fr ./darwin-amd64
	rm ./glide.zip
else
	curl -fL https://github.com/Masterminds/glide/releases/download/v$(GLIDE_VERSION)/glide-v$(GLIDE_VERSION)-linux-amd64.zip -o glide.zip
	unzip glide.zip
	mv ./linux-amd64/glide glide
	rm -fr ./linux-amd64
	rm ./glide.zip
endif

.PHONY: test
test:
	go test .

.PHONY: clean
clean:
	rm ./glide
	rm -fr ./build

.PHONY: update-deps
update-deps: glide
	./glide update

goimports:
	goimports -w $(GOFMT_FILES)
