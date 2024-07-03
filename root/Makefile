
VERSION := 6.32.02
PREFIX ?= ${TOP}/root-${VERSION}-install
TOP ?= $(shell pwd)

download:
	wget -N --no-check-certificate https://root.cern/download/root_v${VERSION}.source.tar.gz

build: download
	rm -rf root_v${VERSION}
	tar xzf root_v${VERSION}.source.tar.gz
	+ cmake -S root-${VERSION} -B root-${VERSION}-build \
		-DCMAKE_CXX_STANDARD=17 \
		-DCMAKE_INSTALL_PREFIX=${PREFIX} \
		-Dbuiltin_glew=ON \
		-Dmathmore=ON \
		-Dfftw3=ON \
		-DPYTHIA6_LIBRARY=${TOP}/lib/libPythia6.so

clean:
	rm -rf root_v${VERSION} root_v${VERSION}-build

prune: clean
	rm -rf root_v${VERSION}.source.tar.gz

install:
	+ cmake --build root-${VERSION}-build --target ${prefix}

