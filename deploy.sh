#!/bin/sh -e
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
DSTHOST=$1
[ -z "$DSTHOST" ] && exit 1
ls -A1 $SCRIPTPATH | grep -vE "(README\.md|deploy\.sh|\.git|\.swp)$" | xargs -I FILE scp "$SCRIPTPATH/FILE" "$DSTHOST:"

