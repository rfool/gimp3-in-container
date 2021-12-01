#!/usr/bin/env bash

set -u # fail on uninitialized variables
set -e # fail when statements exit with error
set -o pipefail # like -e, but also fail when part of a pipe fails

SELF=$(readlink -f "${BASH_SOURCE}" 2>/dev/null || greadlink -f "${BASH_SOURCE}")
P=$(readlink -f "${SELF%/*}" 2>/dev/null || greadlink -f "${SELF%/*}")

#echo $P; exit 0

rm /usr/bin/gimp

ln -s $P/run-in-container.sh /usr/bin/gimp


cp gimp-docker.desktop ~/.local/share/applications/

