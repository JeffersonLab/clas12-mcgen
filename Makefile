
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad tcsgen genKYandOnePion jpsigen

all:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir; \
	done

clean:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done

