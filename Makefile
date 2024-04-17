
TOP = $(shell pwd)

SUBDIRS = clasdis claspyth dvcsgen inclusive-dis-rad TCSGen genKYandOnePion JPsiGen MCEGENpiN_radcorr deep-pipi-gen genepi onepigen

all: gibuu genie twopeg elspectro
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir; \
	done

elspectro:
	rm -rf build && mkdir build
	+ cd build && cmake -DCMAKE_CXX_COMPILER=`which g++` -DCMAKE_C_COMPILER=`which gcc` ../
	+ cd build && cmake --build . --target install && cd ..

twopeg:
	sed -i 's/\(^CXX .*= g++ \)/\1 -std=c++17 /' twopeg/Makefile
	cd twopeg && $(MAKE) nobos

gibuu: lhapdf
	$(MAKE) -C gibuu 

lhapdf: lib/libLHAPDF.so
log4cpp: lib/liblog4cpp.so
pythia6: lib/libPythia6.so

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
	install -D pythia6/libPythia6.so lib

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
	mv root-${V} ${SOURCE_DIR}
	+ cmake -S ${SOURCE_DIR} -B ${BUILD_DIR} \
		-DCMAKE_CXX_STANDARD=17 \
		-DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
		-Dbuiltin_glew=ON \
		-Dmathmore=ON \
		-Dfftw3=ON \
		-Dpythia6=ON \
		-DPYTHIA6_LIBRARY=${PYTHIA_LIB}
	+ cmake --build ${BUILD_DIR} --target install -- -j${NTHREADS}
	cp -f ${PYTHIA_LIB} ${INSTALL_DIR/lib}

genie: pythia6 lhapdf
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

install:
	install -D clas12-elSpectro/elSpectro/jpacPhoto/lib/* lib
	install -D clasdis/clasdis bin
	install -D claspyth/claspyth bin
	install -D dvcsgen/dvcsgen bin
	install -D genKYandOnePion/genKYandOnePion bin
	install -D inclusive-dis-rad/inclusive-dis-rad bin
	install -D JPsiGen/JPsiGen.exe bin
	install -D JPsiGen/JPsiGen bin
	install -D twopeg/twopeg bin
	install -D JPsiGen/lib/libJPsiGen.so lib
	install -D TCSGen/TCSGen.exe bin
	install -D TCSGen/TCSGen bin
	install -D TCSGen/lib/libTCSGen.so lib
	install -D MCEGENpiN_radcorr/MCEGENpiN_radcorr bin
	install -D deep-pipi-gen/deep-pipi-gen bin
	install -D genepi/genepi bin
	install -D generate-seeds.py bin
	install -D onepigen/onepigen bin
	install -D onepigen/onepigen_lund bin
	install -D gibuu/gibuu bin
	install -D gibuu/release/objects/GiBUU.x bin
	install -D gibuu/gibuu2lund bin

clean: prune
	rm -rf bin lib lib64 build share include etc
	for dir in $(SUBDIRS); do\
		$(MAKE) -C $$dir clean; \
	done
	$(MAKE) -C twopeg clean
#$(MAKE) -C gibuu clean
#$(MAKE) -C genie clean

prune:
	rm -rf LHAPDF* log4cpp* pythia6* gsl* libxml* build

