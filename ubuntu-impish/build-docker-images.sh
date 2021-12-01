#!/bin/bash

# clean
#docker image rm gimp3-gogo:ubuntu-impish gimp3-builder:ubuntu-impish gimp3-build-env:ubuntu-impish gimp3-runtime-env:ubuntu-impish gimp3-runtime-env0:ubuntu-impish || :

# stage by stage, with caches

#docker build --cache-from gimp3-runtime-env0:ubuntu-impish --target gimp3-runtime-env0 -t gimp3-runtime-env0:ubuntu-impish .
#docker build --cache-from gimp3-runtime-env0:ubuntu-impish --cache-from gimp3-runtime-env:ubuntu-impish --target gimp3-runtime-env -t gimp3-runtime-env:ubuntu-impish .
#docker build --cache-from gimp3-runtime-env:ubuntu-impish --cache-from gimp3-build-env:ubuntu-impish --target gimp3-build-env -t gimp3-build-env:ubuntu-impish .
#docker build --cache-from gimp3-build-env:ubuntu-impish --cache-from gimp3-builder:ubuntu-impish --target gimp3-builder -t gimp3-builder:ubuntu-impish .
#docker build --cache-from gimp3-runtime-env0:ubuntu-impish --cache-from gimp3-runtime-env:ubuntu-impish --cache-from gimp3-gogo:ubuntu-impish --target gimp3-gogo -t gimp3-gogo:ubuntu-impish .


GOGO_ARGS="--build-arg GIMP3_USERNAME=$(id -un) --build-arg GIMP3_GROUPNAME=$(id -gn) --build-arg GIMP3_UID=$(id -u) --build-arg GIMP3_GID=$(id -g) --build-arg GIMP3_DBUS_HOST=$(hostname)"

IMAGES="gimp3-runtime-env0 gimp3-runtime-env gimp3-build-env gimp3-builder gimp3-gogo"
TAG="ubuntu-impish"
CF=""
for IMAGE in $IMAGES; do
	CF="$CF --cache-from $IMAGE:$TAG"
	BUILDARGS=
	[ "$IMAGE" == "gimp3-gogo" ] && BUILDARGS="$GOGO_ARGS"

	echo -e "Building $IMAGE:"
	echo -e "        docker build $CF $BUILDARGS --target $IMAGE -t $IMAGE:$TAG .)"
	echo -e "\n\n"

	docker build $CF $BUILDARGS --target $IMAGE -t $IMAGE:$TAG .

	echo -e "\n\n"
done


# all stages in one slide
#docker build -t gimp3-gogo:ubuntu-impish .

