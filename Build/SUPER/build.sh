#!/bin/bash
VER="0.4.1"
wget "https://github.com/SUPERAndroidAnalyzer/super/releases/download/"$VER"/super-analyzer_"$VER"_debian_amd64.deb"
sign_only "super-analyzer_"$VER"_debian_amd64.deb"
echo "DEB Signed and ready for usage"