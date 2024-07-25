.PHONY = clean build

build: bin/os-release
	ls -hl bin

run: bin/os-release
	@bin/os-release

bin/os-release: src/main.go
	@(cd src; go build -o ../bin/os-release)


clean:
	@echo no-op
