
SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad TCSGen genKYandOnePion JPsiGen

all: build install

build:
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir; \
	done

install:
	mkdir -p bin
	install clasdis/clasdis bin
	install claspyth/claspyth bin
	install dvcsgen/dvcsgen bin
	install genKYandOnePion/genKYandOnePion bin
	install inclusive-dis-rad/inclusive-dis-rad bin
	install JPsiGen/JPsiGen.exe bin
	install JPsiGen/JPsiGen bin
	install TCSGen/TCSGen.exe bin
	install TCSGen/TCSGen bin

clean:
	rm -rf bin
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done

