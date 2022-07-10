#!/bin/bash
MAINVER="0.9"
Extra=".5"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/tamerplatform-menuitems ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
rm -rf usr
mkdir -p usr/share/applications usr/share/icons/tamerplatform
cp source/*.desktop usr/share/applications/
cp -r source/icons/* usr/share/icons/tamerplatform/
chmod 644 usr/share/applications/*.desktop
echo $VERSION
debctrl "tamerplatform-menuitems" "$VERSION" "TamerPlatform MenuItems" "https://github.com/TamerPlatform/tamerplatform-menuitems" "all"
changelog
build_package usr
