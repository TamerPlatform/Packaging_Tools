#!/bin/bash
VER="0.3.1"
wget "https://github.com/SUPERAndroidAnalyzer/super/releases/download/"$VER"/super-analyzer_"$VER"_debian_amd64.deb"
dpkg-sig --sign tamer -k 7EE83BCF "super-analyzer_"$VER"_debian_amd64.deb"
echo "DEB Signed and ready for usage"