.PHONY = clean build

build: bin/os-release
	ls -hl bin

run: bin/os-release
	@bin/os-release

bin/os-release: src/*.zig
	mkdir bin
	@(cd bin; zig build-exe ../src/os-release.zig)


clean:
	rm -r bin/
