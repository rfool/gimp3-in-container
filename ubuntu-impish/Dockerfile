# --------------------------------------------------------------------------- #
FROM ubuntu:impish AS gimp3-runtime-env0
# --------------------------------------------------------------------------- #


ENV LANG de_DE.utf8

# add basic utils & data

RUN apt-get update && \
	DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y --no-install-recommends \
		locales \
		gzip zip unzip bzip2 pigz zstd \
		nano less \
		ca-certificates curl wget \
		binutils bash-completion \
		fonts-freefont-ttf fonts-freefont-otf gsfonts \
		fonts-liberation fonts-droid-fallback \
		python3 python3-gi \
		graphviz \
		libgnutls30 \
		ghostscript exiftool \
		icc-profiles-free \
		shared-mime-info \
		gnome-icon-theme colord-data \
		&& \
	apt-get clean; apt-get purge -y --auto-remove; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives; \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8; \
	localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8


# --------------------------------------------------------------------------- #
FROM gimp3-runtime-env0 AS gimp3-runtime-env
# --------------------------------------------------------------------------- #


# add gimp runtime dependencies

RUN apt-get update && \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
		valac-bin \
		libvalapanel0 libvala-0.52-0 libvaladoc-0.52-0 \
		luajit \
		libgtk-3-bin libappstream-glib8 \
		libatk1.0-0 libbabl-0.1-0 \
		libpoppler-glib8 poppler-data \
		libglib2.0-data libglib2.0-0 libglib2.0-bin \
		libpango1.0-0 libcairo2 libpangocairo-1.0-0 \
		libfontconfig1 libfreetype6 libharfbuzz0b \
		zlib1g libbz2-1.0 liblzma5 \
		libgexiv2-2 \
		libpng16-16 \
		libjpeg-turbo8 \
		libtiff5 \
		liblcms2-2 \
		libmypaint-1.5-1 mypaint-brushes mypaint-data mypaint-data-extras \
		libopenjp2-7 \
		libmng2 \
		librsvg2-2 librsvg2-bin \
		libwmf0.2-7 \
		libaa1 \
		libgs9 \
		libx265-192 libde265-0 libaom0 libheif1 \
		libwebp6 \
		libjxr0 \
		libopenexr25 openexr \
		libxcursor1 libxpm4 \
		libasound2 \
		libgudev-1.0-0 \
		libraw20 libmaxflow0 \
		libspiro1 libumfpack5 \
		libarchive13 \
		libgegl-0.4-0 gegl \
		glib-networking glib-networking-common \
		libbrotli1 \
		libavif9 libavif-bin \
		libcanberra-gtk3-module libcanberra-gtk0 libcanberra-gtk-module librsvg2-common libgtk2.0-bin \
		libjson-glib-1.0-0 \
		gjs lua-lgi \
		gir1.2-gegl-0.4 gir1.2-gudev-1.0 \
		libwebkit2gtk-4.0-37 \
		&& \
	apt-get clean; apt-get purge -y --auto-remove; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

#
#	DEBIAN_FRONTEND="noninteractive" apt-get remove -y --no-install-recommends \
#		libatk1.0-doc \
#		libpango1.0-doc \
#		libglib2.0-doc \
#		&& \
#	apt-get clean; apt-get purge -y --auto-remove; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives
#

#RUN groupadd -g 1000 gimp && useradd -g 1000 -u 1000 -d /home/gimp -m --shell=/bin/bash gimp


# --------------------------------------------------------------------------- #
FROM gimp3-runtime-env AS gimp3-build-env
# --------------------------------------------------------------------------- #


# add build tools & -dev packages (matching the runtime deps packages above)

RUN apt-get update && \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
		valac \
		git \
		cpp-11 gcc-11 g++-11 \
		pkg-config automake autoconf libtool \
		make yasm nasm build-essential \
		bison flex patch patchelf \
		cmake meson ninja-build \
		intltool \
		gtk-doc-tools \
		libvalapanel-dev libvala-0.52-dev libvaladoc-0.52-dev \
		libgjs-dev libluajit-5.1-dev \
		python-gi-dev \
		libgnutls28-dev libproxy-dev \
		appstream-util xvfb desktop-file-utils \
		libgtk-3-dev libgdk-pixbuf2.0-dev libappstream-glib-dev \
		libpoppler-glib-dev \
		libglib2.0-dev libglib2.0-dev-bin \
		libatk1.0-dev \
		libpango1.0-dev libcairo2-dev \
		libfontconfig1-dev libfreetype6-dev libharfbuzz-dev \
		zlib1g-dev libbz2-dev liblzma-dev \
		libgexiv2-dev \
		libpng-dev \
		libjpeg-dev libjpeg-turbo8-dev \
		libtiff-dev \
		libmypaint-dev \
		libopenjp2-7-dev \
		libwebkit2gtk-4.0-37 libwebkit2gtk-4.0-dev \
		libmng-dev \
		librsvg2-dev \
		libwmf-dev \
		libaa1-dev \
		libgs-dev \
		libx265-dev libde265-dev libaom-dev libheif-dev \
		libwebp-dev \
		libjxr-dev \
		libopenexr-dev \
		libxcursor-dev libxpm-dev \
		libasound2-dev \
		libgudev-1.0-dev \
		libraw-dev libmaxflow-dev libspiro-dev libsuitesparse-dev \
		libbrotli-dev \
		libavif-dev \
		libbabl-dev libgegl-dev liblcms2-dev libjson-glib-dev \
		gir1.2-babl-0.1 gir1.2-gegl-0.4 gir1.2-json-1.0 gir1.2-webkit2-4.0 \
		&& \
	apt-get clean; apt-get purge -y --auto-remove; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives



# --------------------------------------------------------------------------- #
FROM gimp3-build-env AS gimp3-builder
# --------------------------------------------------------------------------- #

WORKDIR /opt

# libjxl
RUN cd /opt; \
	[ ! -d libjxl ] && git clone https://github.com/libjxl/libjxl.git --recursive && \
	cd libjxl/ && \
	git submodule update --init --recursive && \
	mkdir -p build; cd build; \
	cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && \
	cmake --build . -- -j$(nproc --ignore=3) && \
	cmake --install .


# gimp
RUN cd /opt; \
	[ ! -d gimp ] && git clone --branch GIMP_2_99_8 --depth 1 https://gitlab.gnome.org/GNOME/gimp.git && \
	cd gimp/ && \
	./autogen.sh --enable-relocatable-bundle --prefix=/opt/gimp3 && \
	make -j $(nproc --ignore=3) && \
	make install && \
	ldconfig


# --------------------------------------------------------------------------- #
FROM gimp3-runtime-env AS gimp3-gogo
ARG GIMP3_USERNAME gimp
ARG GIMP3_GROUPNAME gimp
ARG GIMP3_UID 1000
ARG GIMP3_GID 1000
ARG GIMP3_DBUS_HOST localhost
# --------------------------------------------------------------------------- #

# + libjxl dependencies from build
COPY --from=gimp3-builder /usr/lib/x86_64-linux-gnu/libjxl.so.0.7.0 /usr/lib/x86_64-linux-gnu/libjxl_threads.so.0.7.0 /usr/lib/x86_64-linux-gnu/libjxrglue.so.1.1 /usr/lib/x86_64-linux-gnu/
COPY --from=gimp3-builder /usr/bin/cjxl /usr/bin/djxl /usr/bin/cjpeg_hdr /usr/bin/benchmark_xl /usr/bin/
# + actual gimp binaries and libs from build
COPY --from=gimp3-builder /opt/gimp3 /opt/gimp3

RUN ldconfig

RUN apt-get update && \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
		dbus-x11 \
		gvfs-backends gvfs-fuse \
		&& \
	apt-get clean; apt-get purge -y --auto-remove; rm -rf /var/lib/apt/lists/* /var/cache/apt/archives


RUN groupadd -g $GIMP3_GID $GIMP3_GROUPNAME && \
	useradd -g $GIMP3_GID -u $GIMP3_UID -d /home/$GIMP3_USERNAME -m --shell=/bin/bash $GIMP3_USERNAME && \
	mkdir -p /run/dbus


COPY launch_gimp.sh /launch_gimp.sh


USER $GIMP3_USERNAME:$GIMP3_GROUPNAME
WORKDIR /home/$GIMP3_USERNAME
ENV SHELL /bin/bash
#ENV DBUS_SESSION_BUS_ADDRESS="tcp:host=$GIMP3_DBUS_HOST,port=6667,family=ipv4"


RUN echo alias la=\"ls -lha\" >> .bashrc

CMD [ "/launch_gimp.sh" ]

