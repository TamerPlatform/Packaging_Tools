#!/bin/bash
MAINVER="0.4"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/androidtamer-menu ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
mkdir -p usr/share/desktop-directories etc/xdg/menus/applications-merged usr/share/icons/androidtamer
cp source/mate-applications.menu etc/xdg/menus/applications-merged/mate-applications.menu
cp source/directories/* usr/share/desktop-directories/
cp source/icons/* usr/share/icons/androidtamer/
chmod -R 644 usr etc
echo $VERSION
debctrl "androidtamer-menu" "$VERSION" "AndroidTamer Menu" "https://github.com/AndroidTamer/androidtamer-menu" "all"
changelog
build_package etc usr