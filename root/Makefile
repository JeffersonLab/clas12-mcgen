
ROOTV := 6.32.02
TOP := $(shell pwd)

download:
	wget -N --no-check-certificate https://root.cern/download/root_v${ROOTV}.source.tar.gz

build: download
ifndef prefix
	$(error prefix must be defined.)
endif
	rm -rf root_v${ROOTV}
	tar xzf root_v${ROOTV}.source.tar.gz
	+ cmake -S root-${ROOTV} -B root-${ROOTV}-build \
		-DCMAKE_CXX_STANDARD=17 \
		-DCMAKE_INSTALL_PREFIX=${prefix} \
		-Dbuiltin_glew=ON \
		-Dmathmore=ON \
		-Dfftw3=ON \
		-DPYTHIA6_LIBRARY=${TOP}/lib/libPythia6.so
#		-Dpythia6=ON \
#	+ cmake --build root-${ROOTV}-build --target ${prefix}

