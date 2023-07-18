
URL = https://gibuu.hepforge.org/downloads
RELEASE = 2021
SYMLINKS = release buuinput libraries
PACKAGES = release$(RELEASE) buuinput$(RELEASE) libraries$(RELEASE)_RootTuple
UNAME := $(shell uname)

ROOT_CFLAGS := $(shell root-config --cflags)
ROOT_LIBS := $(shell root-config --libs)

all: $(PACKAGES)
ifeq ($(UNAME),Darwin)
	sed -i '' 's/ cmake / cmake -DCMAKE_CXX_STANDARD=17 /' ./libraries/RootTuple/Makefile
else
	sed -i 's/ cmake / cmake -DCMAKE_CXX_STANDARD=17 /' ./libraries/RootTuple/Makefile
endif
	+ $(MAKE) -C release buildRootTuple
	+ $(MAKE) withROOT=1 -C release
	install release/objects/GiBUU.x .

$(PACKAGES):%:%.tar.gz
	tar -xzvf $< && rm -f $<

$(addsuffix .tar.gz,$(PACKAGES)):
	wget -N --content-disposition "${URL}?f=$@"

clean:
	rm -rf $(addsuffix .tar.gz,$(PACKAGES))
	rm -rf $(SYMLINKS) $(PACKAGES) libraries$(RELEASE)
	rm -rf GiBUU.x 

gibuu2lund:
	$(CXX) $(ROOT_CFLAGS) -o gibuu2lund gibuu2lund.cxx $(ROOT_LIBS)

