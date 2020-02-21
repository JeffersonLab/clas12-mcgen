
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad tcsgen

all:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir; \
	done
	$(shell cd genKYandOnePion ; g++ -pipe -o eg_ky eg_ky.cpp -g `root-config --cflags --glibs` -O3)

clean:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done
	$(shell cd genKYandOnePion ; rm -f eg_ky) 

