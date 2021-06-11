
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad TCSGen genKYandOnePion JPsiGen twopeg

build:
	mkdir -p bin lib
	$(MAKE) -C clasdis
	$(MAKE) -C claspyth
	$(MAKE) -C dvcsgen
	$(MAKE) -C genKYandOnePion
	$(MAKE) -C inclusive-dis-rad
	$(MAKE) -C JPsiGen
	$(MAKE) -C TCSGen
	# seems twopeg has a non-standard(?) Makefile and requires this instead:
	cd twopeg ; make nobos ; cd --
	# clas12-elSpectro uses cmake:
	mkdir build && cd build && cmake -DCMAKE_CXX_COMPILER=`which g++` -DCMAKE_C_COMPILER=`which gcc` ../ && cmake --build . --parallel 8 --target install && cd ..
	install build/clas12-elSpectro/elSpectro/jpacPhoto/libjpacPhoto.so lib
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
	rm -rf build

clean:
	rm -rf bin lib build
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done

