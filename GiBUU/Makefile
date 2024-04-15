
RELEASE = 2023
PATCH = 03
SYMLINKS = release buuinput libraries
PACKAGES = release$(RELEASE) buuinput$(RELEASE) libraries$(RELEASE)_RootTuple

all: $(PACKAGES) gibuu2lund patch
	+ $(MAKE) -C release buildRootTuple
	+ $(MAKE) withROOT=1 -C release PDF=LHAPDF
	install release/objects/GiBUU.x .

prep: $(PACKAGES)

download: $(addsuffix .tar.gz,$(PACKAGES))
	for pdf in $(PDFSETS); do\
		wget -N $$pdf; \
	done

release$(RELEASE): release$(RELEASE).tar.gz
	@ [ -e $@ ] || tar -xzvf $<

buuinput$(RELEASE): buuinput$(RELEASE).tar.gz
	@ [ -e $@ ] || tar -xzvf $<

libraries$(RELEASE)_RootTuple: libraries$(RELEASE)_RootTuple.tar.gz
	@ [ -e libraries${RELEASE} ] || tar -xzvf $<

$(addsuffix .tar.gz,$(PACKAGES)):
	wget -N --content-disposition "https://gibuu.hepforge.org/downloads?f=archive/r${RELEASE}_${PATCH}/$@"

gibuu2lund:
	$(CXX) $(shell root-config --cflags) -o gibuu2lund gibuu2lund.cxx $(shell root-config --libs)

patch: $(PACKAGES)
	cp -f FindROOT.cmake libraries/RootTuple/RootTuple-master/cmake/Modules/FindROOT.cmake
	cp -f eks98_dummy.f90 release/code/collisions/twoBodyReactions/HiEnergy
	patch -p 0 < NuclearPDF.f90.patch
	#ln -s ./lib/*.so ./lib

clean:
	rm -rf $(SYMLINKS) $(PACKAGES) libraries${RELEASE}
	rm -rf GiBUU.x gibuu2lund

tarclean: clean
	rm -rf $(addsuffix .tar.gz,$(PACKAGES))

