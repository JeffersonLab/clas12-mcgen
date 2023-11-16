
ROOT_CFLAGS := $(shell root-config --cflags)
ROOT_LIBS := $(shell root-config --libs)

all: genie genie2lund

deps:
	mkdir -p build && cd build && ../build-deps.sh

root:
	mkdir -p build && cd build && ../build-root.sh -v 6.26.10 -p $(ROOTSYS)

genie: deps
	./build-genie.sh

prune:
	rm -rf build LHAPDF* libxml* log4cpp* pythia* root* 

clean: prune
	rm -rf bin lib share include clean genie

genie2lund:
	mkdir -p bin
	$(CXX) $(ROOT_CFLAGS) -o bin/genie2lund genie2lund.cxx $(ROOT_LIBS)

