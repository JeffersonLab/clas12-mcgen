
ROOT_CFLAGS := $(shell root-config --cflags)
ROOT_LIBS := $(shell root-config --libs)

install: build
	install -D genie2lund ../bin
	install -D genie ../bin

build:
	$(CXX) $(ROOT_CFLAGS) -o genie2lund genie2lund.cxx $(ROOT_LIBS)

clean:
	rm -f genie2lund

