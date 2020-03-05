
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad tcsgen jpsigen

all:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir; \
	done
	$(shell cd genKYandOnePion ; g++ -pipe -o genKYandOnePion genKYandOnePion.cpp -g `root-config --cflags --glibs` -O3)

clean:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done
	$(shell cd genKYandOnePion ; rm -f eg_ky) 

