#!/bin/bash
MAINVER="0.1"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/androidtamer-menuitems ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
rm -rf usr
mkdir -p usr/share/applications usr/share/icons/androidtamer
cp source/*.desktop usr/share/applications/
chmod 644 usr/share/applications/*.desktop
echo $VERSION
debctrl "androidtamer-menuitems" "$VERSION" "AndroidTamer MenuItems" "https://github.com/AndroidTamer/androidtamer-menuitems" "all"
changelog
build_package usr
