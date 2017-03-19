#!/bin/bash
MAINVER="1.3.0"
Extra=""
VERSION=$MAINVER$Extra
build_pip --depends ffmpeg robogif
dpkg-sig --sign builder -k 7EE83BCF "python-robogif_"$VERSION"_all.deb"