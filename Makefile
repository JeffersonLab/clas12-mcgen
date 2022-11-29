
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad TCSGen genKYandOnePion JPsiGen twopeg MCEGENpiN_radcorr deep-pipi-gen genepi

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
	# seems twopeg has a non-standard(?) Makefile and requires this instead:
	cd twopeg ; make nobos ; cd --
	# clas12-elSpectro uses cmake:
	mkdir build && cd build && cmake -DCMAKE_CXX_COMPILER=`which g++` -DCMAKE_C_COMPILER=`which gcc` ../ && cmake --build . --target install && cd ..
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
	rm -rf build

clean:
	rm -rf bin lib build
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done

