
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad TCSGen genKYandOnePion JPsiGen twopeg

build:
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
	cd clas12-elSpectro && mkdir build && cd build && cmake ../ && cmake --build . --target install
	mkdir -p bin lib
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
	install clas12-elSpectro/build/clas12-elSpectro bin

clean:
	rm -rf bin lib
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done

