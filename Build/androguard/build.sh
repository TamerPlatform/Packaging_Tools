#!/bin/bash
MAINVER="2.0"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/androguard ./source
fi
rm -rf usr
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
# Build
debctrl "python-androguard" "$VERSION" "Androguard is a full python tool to play with Android files." "https://github.com/TamerPlatform/androguard" "all" "python-pyasn1, python-cryptography (>= 1.0), python-future, python-ipython (>= 5.0.0), python-networkx, python-pygments, python-pyperclip, python-pyqt5" 
build_pip local --deb-custom-control debian/control -v $VERSION  source/setup.py
build_pip pyperclip
build_pip ipython

echo "Autosigning all binaries done today"
find ./ -name '*.deb' -maxdepth 1 -mtime -1 -exec dpkg-sig --sign builder -k 7EE83BCF "{}" \;
