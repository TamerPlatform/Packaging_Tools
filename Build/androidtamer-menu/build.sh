#!/bin/bash
MAINVER="0.9"
Extra=".1"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/tamerplatform-menu ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
mkdir -p usr/share/desktop-directories etc/xdg/menus/applications-merged usr/share/icons/tamerplatform
cp source/mate-applications.menu etc/xdg/menus/applications-merged/mate-applications.menu
cp source/directories/* usr/share/desktop-directories/
cp source/icons/* usr/share/icons/tamerplatform/
chmod -R 644 usr/share/icons/tamerplatform/* etc/xdg/menus/applications-merged/mate-applications.menu usr/share/desktop-directories/*
echo $VERSION
debctrl "tamerplatform-menu" "$VERSION" "TamerPlatform Menu" "https://github.com/TamerPlatform/tamerplatform-menu" "all"
changelog
build_package etc usr
