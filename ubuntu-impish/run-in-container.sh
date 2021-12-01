#!/usr/bin/env bash

set -u # fail on uninitialized variables
set -e # fail when statements exit with error
set -o pipefail # like -e, but also fail when part of a pipe fails

SELF=$(readlink -f "${BASH_SOURCE}" 2>/dev/null || greadlink -f "${BASH_SOURCE}")
P=$(readlink -f "${SELF%/*}" 2>/dev/null || greadlink -f "${SELF%/*}")


#xhost +
xhost +SI:localuser:$(id -un)


GIMP3_USERNAME=$(id -un)
GIMP3_GROUPNAME=$(id -gn)
GIMP3_UID=$(id -u)
GIMP3_GID=$(id -g)

DBUS_HOST=$(hostname)

mkdir -p $P/home/.config || :
#mkdir -p $P/home/.local/share || :
cp -a ~/.config/dconf $P/home/.config/ || :
cp -a ~/.config/gtk-3.0 $P/home/.config/ || :

#cp -a ~/.local/share/gvfs-metadata ./home/.local/share/gvfs-metadata



declare -a REQFILEMOUNT=()

# bind users home
REQFILEMOUNT+=("$HOME:/home/$GIMP3_USERNAME")
# and overlay users .config with custom version
REQFILEMOUNT+=("$P/home/.config:/home/$GIMP3_USERNAME/.config")
# cur dir
REQFILEMOUNT+=("$PWD:$PWD")


XCMD1="/launch_gimp.sh"
XCMD12=
declare -a XCMD_ARR=("$@")



if [ $# -gt 0 ]; then
	if [ "$1" = "bash" ]; then
		shift
		XCMD1="/bin/bash"
		if [ $# -gt 0 -a "${1-}" = "-c" ]; then
			shift
			XCMD1="$XCMD1"
			XCMD12="$XCMD12 -c"
	 		if [ $# -gt 0 -a "${1-}" = "--" ]; then
				XCMD12="$XCMD12 --"
				shift
			fi
		fi

		XCMD_ARR=("$@")

	else
		while [ $# -gt 0 ]; do
			if [ -f "$1" ]; then
				MPATH=$(realpath "$1")
				MDIR=$(dirname "$MPATH")
				#echo "MDIR(1)=$MDIR"
				REQFILEMOUNT+=("$MDIR:$MDIR")
				if [ -h "$1" ]; then
					MPATH=$(realpath "$1")
					MDIR=$(dirname "$MPATH")
					#echo "MDIR(2)=$MDIR"
					REQFILEMOUNT+=("$MDIR:$MDIR")
				fi
			fi
			shift
		done
	fi
fi

#WORKDIR="/home/$GIMP3_USERNAME"
WORKDIR="$PWD"

#REQFILEMOUNT_UNIQ=($(for M in "${REQFILEMOUNT[@]}"; do echo "${M}"; done | sort -u))
REQFILEMOUNT_UNIQ=($(tr ' ' '\n' <<<"${REQFILEMOUNT[@]}" | awk '!u[$0]++' | tr '\n' ' '))
REQFILEMOUNT_UNIQ_STR=$( IFS=,; printf ' -v %s' "${REQFILEMOUNT_UNIQ[@]}" )

# echo "==--reqfmnt==============="
# printf "%s\n" "${REQFILEMOUNT[@]}"
# echo "=================="
# printf "%s\n" "${REQFILEMOUNT_UNIQ[@]}"
# echo "=================="
# echo "REQFILEMOUNT_UNIQ_STR=$REQFILEMOUNT_UNIQ_STR"
# exit


MORE_OPTS=

[ -d /dev/dri ] && MORE_OPTS="$MORE_OPTS --device /dev/dri"

tty -s && MORE_OPTS="$MORE_OPTS --interactive --tty"

if [ ! -z "$WAYLAND_DISPLAY" ]; then
   MORE_OPTS="$MORE_OPTS -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
   MORE_OPTS="$MORE_OPTS -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY"
   MORE_OPTS="$MORE_OPTS -e XDG_SESSION_TYPE=wayland"
fi

run_docker() {
  set -x
  docker run -i --rm \
    --env=DISPLAY=unix${DISPLAY-} \
    --mount type=bind,source=${XAUTHORITY},target=${XAUTHORITY} \
    --env=XAUTHORITY=${XAUTHORITY-} \
    --env=XMODIFIERS=${XMODIFIERS-} \
    --security-opt apparmor:unconfined \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --mount type=bind,source=${XDG_RUNTIME_DIR}/bus,target=${XDG_RUNTIME_DIR}/bus \
    --mount type=bind,source=/run/dbus/system_bus_socket,target=/run/dbus/system_bus_socket \
    --env=DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
    --mount type=bind,source=${XDG_RUNTIME_DIR},target=${XDG_RUNTIME_DIR} \
    --env=XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} \
    --device /dev/snd \
    --mount type=bind,source=${XDG_RUNTIME_DIR}/pulse,target=${XDG_RUNTIME_DIR}/pulse,readonly \
    --env=PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    --mount type=bind,source=/run/cups/cups.sock,target=/run/cups/cups.sock \
    --env CUPS_SERVER=/run/cups/cups.sock \
    --ipc=host \
    $MORE_OPTS \
    $REQFILEMOUNT_UNIQ_STR \
    -u $GIMP3_UID:$GIMP3_GID \
    -w $WORKDIR \
    gimp3-gogo:ubuntu-impish \
    $XCMD1 $XCMD12 "${XCMD_ARR[@]}"
}


run_docker

