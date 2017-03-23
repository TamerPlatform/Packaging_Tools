#!/bin/bash
MAINVER="1.3.0"
wget "http://cloud.radare.org/get/"$MAINVER"/radare2_"$MAINVER"_amd64.deb"
dpkg-sig --sign builder -k 7EE83BCF radare2_"$MAINVER"_amd64.deb
