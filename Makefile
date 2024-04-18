
MAKEDIRS := $(shell find . -maxdepth 2 -mindepth 2 -name Makefile | awk -F/ '{print$$2}')
SUBMODULES := $(shell grep ^\\[submodule .gitmodules | awk -F\" '{print$$2}')
CLEANDIRS := $(MAKEDIRS)
MAKEDIRS := $(filter-out gibuu,$(MAKEDIRS))
MAKEDIRS := $(filter-out genie,$(MAKEDIRS))
MAKEDIRS := $(filter-out twopeg,$(MAKEDIRS))

TOP := $(shell pwd)

export GENIE := $(TOP)/genie

all: gibuu genie twopeg elspectro $(MAKEDIRS)

$(MAKEDIRS):
	echo $(MAKE) -C $@

.PHONY: $(MAKEDIRS)

elspectro:
	rm -rf build && mkdir build
	+ cd build && cmake -DCMAKE_CXX_COMPILER=`which g++` -DCMAKE_C_COMPILER=`which gcc` ../
	+ cd build && cmake --build . --target install && cd ..

twopeg:
	sed -i 's/\(^CXX .*= g++ \)/\1 -std=c++17 /' twopeg/Makefile
	cd twopeg && $(MAKE) nobos

gibuu: bin/GiBUU.x
lhapdf: lib/libLHAPDF.so
log4cpp: lib/liblog4cpp.so
pythia6: lib/libPythia6.so

bin/GiBUU.x: lhapdf
	$(MAKE) -C gibuu install 

lib/libLHAPDF.so:
	$(eval V := 6.5.4)
	wget https://lhapdf.hepforge.org/downloads/?f=LHAPDF-${V}.tar.gz -O LHAPDF-${V}.tar.gz
	tar -xzvf LHAPDF-${V}.tar.gz
	cd LHAPDF-${V} && ./configure --prefix=${TOP}
	$(MAKE) -C LHAPDF-${V}
	$(MAKE) -C LHAPDF-${V} install

lib/liblog4cpp.so:
	wget https://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.4.tar.gz
	tar -xzvf log4cpp-1.1.4.tar.gz
	cd log4cpp && ./configure --prefix=${TOP}
	$(MAKE) -C log4cpp
	$(MAKE) -C log4cpp install

lib/libPythia6.so:
	wget https://root.cern/download/pythia6.tar.gz
	tar -xzvf pythia6.tar.gz
	sed -i 's/^char /extern char /' ./pythia6/pythia6_common_address.c
	sed -i 's/^int /extern int /' ./pythia6/pythia6_common_address.c
	sed -i 's/^extern int pyuppr/int pyuppr /' ./pythia6/pythia6_common_address.c
	cd pythia6 && ./makePythia6.linuxx8664
	install -D pythia6/libPythia6.so lib/libPythia6.so

lib/libgsl.so: 
	wget https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz
	tar -xzvf gsl-2.7.tar.gz
	cd gsl-2.7 && ./configure --prefix=${TOP}
	$(MAKE) -C gsl-2.7
	$(MAKE) -C gsl-2.7 install

lib/libxml2.so:
	wget http://mirror.umd.edu/gnome/sources/libxml2/2.11/libxml2-2.11.0.tar.xz
	tar -xJvf libxml2-2.11.0.tar.xz
	cd libxml2-2.11.0 && ./configure --prefix=${TOP} --without-python
	$(MAKE) -C libxml2-2.11.0
	$(MAKE) -C libxml2-2.11.0 install

root: pythia6
	$(eval V := 6.30.04)
	wget https://root.cern/download/root_v${V}.source.tar.gz
	tar xzf root_v${V}.source.tar.gz
	+ cmake -S root-${V} -B root-${V}-build \
		-DCMAKE_CXX_STANDARD=17 \
		-DCMAKE_INSTALL_PREFIX=${TOP}/root \
		-Dbuiltin_glew=ON \
		-Dmathmore=ON \
		-Dfftw3=ON \
		-Dpythia6=ON \
		-DPYTHIA6_LIBRARY=${TOP}/lib/libPythia6.so
	+ cmake --build root-${V}-build --target install

genie: pythia6 lhapdf log4cpp
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

install:
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

clean:
	rm -rf bin lib lib64 build share include etc
	for dir in $(CLEANDIRS); do\
		$(MAKE) -C $$dir clean; \
	done
	rm -rf LHAPDF* log4cpp* pythia6* libxml* root-* build

prune:
	rm -rf LHAPDF* log4cpp* pythia6* libxml* root-* build

debug:
	@ echo SUBMODULES: $(SUBMODULES)
	@ echo CLEANDIRS:  $(CLEANDIRS)
	@ echo MAKEDIRS:   $(MAKEDIRS)

