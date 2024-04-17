
TOP = $(shell pwd)

SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad TCSGen genKYandOnePion JPsiGen twopeg MCEGENpiN_radcorr deep-pipi-gen genepi gibuu onepigen genie

build: gibuu
	mkdir -p bin lib
	$(MAKE) -C clasdis
	$(MAKE) -C claspyth
	$(MAKE) -C dvcsgen
	$(MAKE) -C genKYandOnePion
	$(MAKE) -C inclusive-dis-rad
	$(MAKE) -C JPsiGen
	$(MAKE) -C TCSGen
	$(MAKE) -C MCEGENpiN_radcorr
	$(MAKE) -C deep-pipi-gen
	$(MAKE) -C genepi
	$(MAKE) -C onepigen
	$(MAKE) -C genie
	# twopeg needs c++17 support:
	sed -i 's/\(^CXX .*= g++ \)/\1 -std=c++17 /' twopeg/Makefile
	# seems twopeg has a non-standard(?) Makefile and requires this instead:
	cd twopeg ; $(MAKE) nobos ; cd --
	# clas12-elSpectro uses cmake:
	+ mkdir build && cd build && cmake -DCMAKE_CXX_COMPILER=`which g++` -DCMAKE_C_COMPILER=`which gcc` ../ && cmake --build . --target install && cd ..
	install clas12-elSpectro/elSpectro/jpacPhoto/lib/* lib
	install clasdis/clasdis bin
	install claspyth/claspyth bin
	install dvcsgen/dvcsgen bin
	install genKYandOnePion/genKYandOnePion bin
	install inclusive-dis-rad/inclusive-dis-rad bin
	install JPsiGen/JPsiGen.exe bin
	install JPsiGen/JPsiGen bin
	install twopeg/twopeg bin
	install JPsiGen/lib/libJPsiGen.so lib
	install TCSGen/TCSGen.exe bin
	install TCSGen/TCSGen bin
	install TCSGen/lib/libTCSGen.so lib
	install MCEGENpiN_radcorr/MCEGENpiN_radcorr bin
	install deep-pipi-gen/deep-pipi-gen bin
	install genepi/genepi bin
	install generate-seeds.py bin
	install onepigen/onepigen bin
	install onepigen/onepigen_lund bin
	rm -rf build

clean: prune
	rm -rf bin lib lib64 build share include etc
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done

prune:
	rm -rf LHAPDF* log4cpp*

gibuu: lhapdf
	$(MAKE) -C gibuu 
	install -D gibuu/gibuu bin
	install -D gibuu/release/objects/GiBUU.x bin
	install -D gibuu/gibuu2lund bin

lhapdf:
	$(eval V := 6.5.4)
	wget https://lhapdf.hepforge.org/downloads/?f=LHAPDF-${V}.tar.gz -O LHAPDF-${V}.tar.gz
	tar -xzvf LHAPDF-${V}.tar.gz
	cd LHAPDF-${V} && ./configure --prefix=${TOP}
	$(MAKE) -C LHAPDF-${V}
	$(MAKE) -C LHAPDF-${V} install
	rm -rf LHAPDF*

log4cpp:
	wget https://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.4.tar.gz
	tar -xzvf log4cpp-1.1.4.tar.gz
	cd log4cpp && ./configure --prefix=${TOP}
	$(MAKE) -C log4cpp
	$(MAKE) -C log4cpp install
	rm -rf log4cpp*

