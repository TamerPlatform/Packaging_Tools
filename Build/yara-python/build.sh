#!/bin/bash
MAINVER="3.5.0.999"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/yara-python ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
echo "Version: " $VERSION
cd source
python setup.py build
cd ..
build_pip local source/setup.py

