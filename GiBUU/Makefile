
URL = https://gibuu.hepforge.org/downloads
RELEASE = 2021
SYMLINKS = release buuinput libraries
PACKAGES = release$(RELEASE) buuinput$(RELEASE) libraries$(RELEASE)_RootTuple

all: $(PACKAGES)
	$(MAKE) -C release
	sed -i 's/ cmake ../ cmake -DCMAKE_CXX_STANDARD=17 ../' ./libraries/RootTuple/Makefile
	$(MAKE) -C release buildRootTuple

$(PACKAGES):%:%.tar.gz
	tar -xzvf $<

$(addsuffix .tar.gz,$(PACKAGES)):
	wget -N --content-disposition "${URL}?f=$@"

cleanbuild:
	rm -rf $(addsuffix .tar.gz,$(PACKAGES))
	rm -rf release/objects

clean: cleanbuild
	rm -rf $(addsuffix $(RELEASE),$(SYMLINKS)) $(SYMLINKS)

