#!/usr/bin/env bash

set -e

#DEF_OPTS="--verbose --console-messages -s"
DEF_OPTS="-s"

exec /opt/gimp3/bin/gimp-2.99 $DEF_OPTS "$@"





# try normal run first (will pass file to existing instance, probably in another container),
# when that failed, then run as "new instance" in this container
# (may happen when the "other container" does not have access to the files in args).
#/opt/gimp3/bin/gimp-2.99 $DEF_OPTS "$@"; LPID=$?
#echo exited with LPID=$LPID
#if [ "$LPID" != "0" ]; then
#	/opt/gimp3/bin/gimp-2.99 $DEF_OPTS -n "$@"
#fi



