#!/bin/bash
MAINVER="0.4"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/adb_wrapper ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
mkdir -p usr/local/bin etc/udev/rules.d
cp source/adb usr/local/bin/adb
chmod 755 usr/local/bin/adb
cp source/99-android.rules etc/udev/rules.d/99-android.rules
echo $VERSION
debctrl "androidtamer-adb" "$VERSION" "AndroidTamer Customized ADB\n Adds features like adb list\n and device naming" "https://github.com/AndroidTamer/adb_wrapper" "all"
changelog
build_package etc usr