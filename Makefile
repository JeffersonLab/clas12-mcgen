
MAKEDIRS := $(shell find . -maxdepth 2 -mindepth 2 -name Makefile | awk -F/ '{print$$2}')
SUBMODULES := $(shell grep ^\\[submodule .gitmodules | awk -F\" '{print$$2}')
CLEANDIRS := $(MAKEDIRS)
MAKEDIRS := $(filter-out gibuu,$(MAKEDIRS))
MAKEDIRS := $(filter-out genie,$(MAKEDIRS))
MAKEDIRS := $(filter-out twopeg,$(MAKEDIRS))
MAKEDIRS := $(filter-out pythia8,$(MAKEDIRS))
MAKEDIRS := $(filter-out root,$(MAKEDIRS))
MAKEDIRS := $(filter-out test,$(MAKEDIRS))

TOP := $(shell pwd)
PATH := $(TOP)/bin:$(PATH)

export GENIE := $(TOP)/genie

all: gibuu twopeg elspectro clas-stringspinner simple

simple: $(MAKEDIRS)

$(MAKEDIRS):
	$(MAKE) -C $@
.PHONY: $(MAKEDIRS)

elspectro:
	rm -rf build && mkdir build
	+ cd build && cmake -DCMAKE_CXX_COMPILER=`which g++` -DCMAKE_C_COMPILER=`which gcc` ../
	+ cd build && cmake --build . --target install
.PHONY: elspectro

twopeg:
	sed -i 's/\(^CXX .*= g++ \)/\1 -std=c++17 /' twopeg/Makefile
	cd twopeg && $(MAKE) nobos
.PHONY: twopeg

clas-stringspinner: pythia8
	meson setup $@/build $@ --prefix=${TOP}
	meson install -C $@/build
.PHONY: clas-stringspinner

gibuu: bin/GiBUU.x
lhapdf: lib/libLHAPDF.so
log4cpp: lib/liblog4cpp.so
pythia6: lib/libPythia6.so
pythia8: lib/libpythia8.so

bin/GiBUU.x: lhapdf
	$(MAKE) -C gibuu install 

dirs:
	mkdir -p bin lib etc share doc
.PHONY: dirs

lib/libLHAPDF.so: dirs
	$(eval V := 6.5.4)
	wget --no-check-certificate https://lhapdf.hepforge.org/downloads/?f=LHAPDF-${V}.tar.gz -O LHAPDF-${V}.tar.gz
	tar -xzvf LHAPDF-${V}.tar.gz
	cd LHAPDF-${V} && ./configure --prefix=${TOP} --disable-python
	$(MAKE) -C LHAPDF-${V}
	$(MAKE) -C LHAPDF-${V} install

lib/liblog4cpp.so: dirs
	wget --no-check-certificate https://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.4.tar.gz
	tar -xzvf log4cpp-1.1.4.tar.gz
	cd log4cpp && ./configure --prefix=${TOP}
	$(MAKE) -C log4cpp
	$(MAKE) -C log4cpp install

lib/libPythia6.so: dirs
	wget --no-check-certificate https://root.cern/download/pythia6.tar.gz
	tar -xzvf pythia6.tar.gz
	sed -i 's/^char /extern char /' ./pythia6/pythia6_common_address.c
	sed -i 's/^int /extern int /' ./pythia6/pythia6_common_address.c
	sed -i 's/^extern int pyuppr/int pyuppr /' ./pythia6/pythia6_common_address.c
	cd pythia6 && ./makePythia6.linuxx8664
	install -D pythia6/libPythia6.so lib/libPythia6.so

lib/libpythia8.so: dirs
	cd pythia8 && ./configure \
		--prefix=${TOP} \
		--cxx=$(shell which g++) \
		--cxx-common="-fPIC" \
		--cxx-shared="-shared -ldl"
	$(MAKE) -C pythia8
	$(MAKE) -C pythia8 install

lib/libgsl.so: dirs
	wget --no-check-certificate https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz
	tar -xzvf gsl-2.7.tar.gz
	cd gsl-2.7 && ./configure --prefix=${TOP}
	$(MAKE) -C gsl-2.7
	$(MAKE) -C gsl-2.7 install

lib/libxml2.so: dirs
	wget --no-check-certificate http://mirror.umd.edu/gnome/sources/libxml2/2.11/libxml2-2.11.0.tar.xz
	tar -xJvf libxml2-2.11.0.tar.xz
	cd libxml2-2.11.0 && ./configure --prefix=${TOP} --without-python
	$(MAKE) -C libxml2-2.11.0
	$(MAKE) -C libxml2-2.11.0 install

genie: pythia6 lhapdf log4cpp dirs
	git clone -b R-3_04_00 --depth 1 https://github.com/GENIE-MC/Generator.git genie
	cd genie && ./configure \
	 --prefix=${TOP} --disable-profiler --disable-validation-tools \
	 --disable-doxygen --disable-cernlib --disable-lhapdf5 --enable-lhapdf6 \
	 --enable-flux-drivers --enable-geom-drivers --enable-dylibversion --enable-nucleon-decay \
	 --enable-test --enable-mueloss --enable-t2k --enable-fnal --enable-atmo \
	 --disable-masterclass --disable-debug --with-optimiz-level=O2 \
	 --with-pythia6-lib=${TOP}/lib --with-lhapdf6-inc=${TOP}/include --with-lhapdf6-lib=${TOP}/lib \
	 --with-log4cpp-inc=${TOP}/include --with-log4cpp-lib=${TOP}/lib
	$(MAKE) -C genie
	$(MAKE) -C genie install
	mv -f bin/genie bin/genie.exe
	$(MAKE) -C genie-util install

install: fixperms
	install -D clasdis/clasdis bin/clasdis
	install -D claspyth/claspyth bin/claspyth
	install -D dvcsgen/dvcsgen bin/dvcsgen
	install -D genKYandOnePion/genKYandOnePion bin/genKYandOnePion
	install -D inclusive-dis-rad/inclusive-dis-rad bin/inclusive-dis-rad
	install -D JPsiGen/JPsiGen.exe bin/JPsiGen.exe
	install -D JPsiGen/JPsiGen bin/JPsiGen
	install -D twopeg/twopeg bin/twopeg
	install -D JPsiGen/lib/libJPsiGen.so lib/libJPsiGen.so
	install -D TCSGen/TCSGen.exe bin/TCSGen.exe
	install -D TCSGen/TCSGen bin/TCSGen
	install -D TCSGen/lib/libTCSGen.so lib/libTCSGen.so
	install -D MCEGENpiN_radcorr/MCEGENpiN_radcorr bin/MCEGENpiN_radcorr
	install -D deep-pipi-gen/deep-pipi-gen bin/deep-pipi-gen
	install -D genepi/genepi bin/genepi
	install -D generate-seeds.py bin/generate-seeds.py
	install -D onepigen/onepigen bin/onepigen
	install -D onepigen/onepigen_lund bin/onepigen_lund
	install -D clas12-elSpectro/elSpectro/jpacPhoto/lib/* lib

fixperms:
	chmod 755 onepigen/spp_tbl
	chmod -R +r onepigen/spp_tbl

clean:
	rm -rf bin lib lib64 build share include
	for dir in $(CLEANDIRS); do\
		$(MAKE) -C $$dir clean; \
	done
	rm -rf LHAPDF* log4cpp* pythia6* libxml* root-* build clas-stringspinner/build

prune:
	rm -rf LHAPDF* log4cpp* pythia6* libxml* root-* build onepigen/spp_tbl.tar.gz clas-stringspinner/build

debug:
	@ echo SUBMODULES: $(SUBMODULES)
	@ echo CLEANDIRS:  $(CLEANDIRS)
	@ echo MAKEDIRS:   $(MAKEDIRS)

