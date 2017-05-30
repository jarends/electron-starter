#!/usr/bin/env bash

NAME=$1

2>/dev/null 1>/dev/null killall $NAME
2>/dev/null 1>/dev/null killall $NAME

rm -rf /Applications/$NAME.app
cp -R build/$NAME-darwin-x64/$NAME.app /Applications

open /Applications/$NAME.app