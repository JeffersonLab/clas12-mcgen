
TOP = $(shell pwd)

SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad TCSGen genKYandOnePion JPsiGen twopeg MCEGENpiN_radcorr deep-pipi-gen genepi GiBUU onepigen genie

build:
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
	$(MAKE) -C GiBUU
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
	install GiBUU/GiBUU.x bin
	install GiBUU/gibuu2lund bin
	install onepigen/onepigen bin
	install onepigen/onepigen_lund bin
	rm -rf build

clean:
	rm -rf bin lib build share include etc
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done

lhapdf:
	$(eval V := 6.5.4)
	wget https://lhapdf.hepforge.org/downloads/?f=LHAPDF-${V}.tar.gz -O LHAPDF-${V}.tar.gz
	tar -xzvf LHAPDF-${V}.tar.gz
	cd LHAPDF-6.5.4 && ./configure --prefix=${TOP}
	make -j 8 -C LHAPDF-${V}
	make -j 8 -C LHAPDF-${V} install
	rm -rf LHAPDF*


