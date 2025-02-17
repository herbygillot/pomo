VERSION ?= $(shell git describe --tags 2>/dev/null)
ifeq "$(VERSION)" ""
	VERSION := UNKNOWN
endif

LDFLAGS=\
	-X github.com/kevinschoon/pomo/pkg/internal.Version=$(VERSION)

.PHONY: \
	test \
	docs \
	pomo-build \
	readme 

default: bin/pomo

clean:
	[[ -f bin/pomo ]] && rm bin/pomo || true

bin/pomo: test
	cd cmd/pomo && \
	go build -ldflags '${LDFLAGS}' -o ../../$@

test:
	go test ./...
	go vet ./...

docs: www/data/readme.json
	cd www && hugo -d ../docs

www/data/readme.json: www/data README.md
	cat README.md | python -c 'import json,sys; print(json.dumps({"content": sys.stdin.read()}))' > $@

www/data bin:
	mkdir -p $@
