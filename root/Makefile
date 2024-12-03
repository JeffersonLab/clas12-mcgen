VERSION ?= 6.32.08
PREFIX ?= $(shell pwd)/${VERSION}

build: configure
	+ cmake --build root-${VERSION}-build

install: build
	+ cd root-${VERSION}-build && make install

configure: extract
	+ cmake -S root-${VERSION} -B root-${VERSION}-build \
		-DCMAKE_CXX_STANDARD=17 \
		-DCMAKE_INSTALL_PREFIX=${PREFIX} \
		-Dbuiltin_glew=ON \
		-Dmathmore=ON \
		-Dfftw3=ON \
		-Dpythia8=ON

download: root_v${VERSION}.source.tar.gz

extract: download
	+ rm -rf root_v${VERSION}
	+ tar xzf root_v${VERSION}.source.tar.gz

clean:
	+ rm -rf root-${VERSION} root-${VERSION}-build

prune: clean
	+ rm -rf root_v${VERSION}.source.tar.gz

root_v${VERSION}.source.tar.gz:
	+ wget -N --no-check-certificate https://root.cern/download/root_v${VERSION}.source.tar.gz

