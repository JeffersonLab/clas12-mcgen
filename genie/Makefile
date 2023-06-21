
deps:
	mkdir -p build && cd build && ../build-deps.sh

root:
	mkdir -p build && cd build && ../build-root.sh -v 6.26.10 -p $(ROOTSYS)

genie:
	./build-genie.sh

prune:
	rm -rf build

clean: prune
	rm -rf bin lib share include clean

