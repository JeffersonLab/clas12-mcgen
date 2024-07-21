VERSION := 6.32.02
TOP ?= $(shell pwd)
PREFIX ?= ${TOP}/${VERSION}

download:
	wget -N --no-check-certificate https://root.cern/download/root_v${VERSION}.source.tar.gz

configure: download
	rm -rf root_v${VERSION}
	tar xzf root_v${VERSION}.source.tar.gz
	+ cmake -S root-${VERSION} -B root-${VERSION}-build \
		-DCMAKE_CXX_STANDARD=17 \
		-DCMAKE_INSTALL_PREFIX=${PREFIX} \
		-Dbuiltin_glew=ON \
		-Dmathmore=ON \
		-Dfftw3=ON \
		-Dpythia8=ON

build: configure
	+ cmake --build root-${VERSION}-build

install: build
	+ cd root-${VERSION}-build && make install

clean:
	rm -rf root-${VERSION} root-${VERSION}-build

prune: clean
	rm -rf root_v${VERSION}.source.tar.gz

