
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad tcsgen

all:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir; \
	done
	$(shell cd genKYandOnePion ; g++ -pipe -o genKYandOnePion genKYandOnePion.cpp -g `root-config --cflags --glibs` -O3)

install:
	install clasdis/clasdis $(JLAB_SOFTWARE)/clas12/bin
	install inclusive-dis-rad/inclusive-dis-rad $(JLAB_SOFTWARE)/clas12/bin/generate-dis
	install dvcsgen/dvcsgen $(JLAB_SOFTWARE)/clas12/bin
	install genKYandOnePion/genKYandOnePion $(JLAB_SOFTWARE)/clas12/bin/eg_ky
	install tcsgen/TCSGen.exe $(JLAB_SOFTWARE)/clas12/bin

clean:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done
	$(shell cd genKYandOnePion ; rm -f eg_ky) 

