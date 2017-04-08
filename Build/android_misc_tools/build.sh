#!/bin/bash
MAINVER="0.0.1"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/android_misc_tools ./source
fi
rm -rf usr 
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
## Build
mkdir -p usr/bin usr/share/android_misc_tools
cp source/apkget usr/bin/apkget
cp source/binaries/mkfs.yaffs2 usr/share/android_misc_tools/mkfs.yaffs2
cp source/getimage.sh usr/bin/getfsimage
cp source/sendsecretcode usr/bin/sendsecretcode
chmod 755 usr/bin/
## Build End
echo $VERSION
debctrl "android_misc_tools" "$VERSION" "miscellaneous tools for android device interaction" "https://github.com/AndroidTamer/android_misc_tools" "all" ""
changelog
build_package usr