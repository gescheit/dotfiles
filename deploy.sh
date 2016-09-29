#!/bin/sh -e
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
DSTHOST=$1
[ -z "$DSTHOST" ] && exit 1
rsync --exclude '/README.md' --exclude '/deploy.sh' --exit '.gitignore' -Carzvvn $SCRIPTPATH  "$DSTHOST:"

