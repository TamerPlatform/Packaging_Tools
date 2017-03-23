#!/bin/bash
MAINVER="1.5"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/JamesHabben/evolve ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
echo "Version: " $VERSION
debctrl "evolve" "$VERSION" "Web interface for the Volatility Memory Forensics Framework" "https://github.com/dpnishant/appmon" "all" "python-bottle, python-yara, python-distorm3, python-maxminddb"
build_pip local --verbose --deb-custom-control debian/control source/setup.py
build_pip bottle
build_pip distorm3
build_pip maxminddb
build_pip yara
