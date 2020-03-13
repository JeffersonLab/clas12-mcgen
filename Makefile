
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad tcsgen genKYandOnePion jpsigen

all: build install

build:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir; \
	done

install:
	mkdir -p bin
	install clasdis/clasdis bin
	install inclusive-dis-rad/inclusive-dis-rad bin
	install dvcsgen/dvcsgen bin
	install genKYandOnePion/genKYandOnePion bin
	install tcsgen/TCSGen.exe bin
	install jpsigen/JPsiGen.exe bin
	install tcsgen/tcsgen bin
	install jpsigen/jpsigen bin

clean:
	rm -rf bin
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done

