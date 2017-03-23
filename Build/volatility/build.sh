#!/bin/bash
MAINVER="2.6"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/volatility ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
echo "Version: " $VERSION
build_pip local --version $VERSION source/setup.py

