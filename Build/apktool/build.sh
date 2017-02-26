#!/bin/bash
MAINVER="2.2.2"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/Apktool ./source
fi
rm -rf usr
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
# Build
cd source
git submodule update --init --recursive
./gradlew clean
./gradlew build fatJar 
cd ..
mkdir -p usr/bin usr/share/apktool usr/share/applications
ls -l ./source/brut.apktool/apktool-cli/build/libs/apktool-$MAINVER.jar 
if [ ! -f ./source/brut.apktool/apktool-cli/build/libs/apktool-$MAINVER.jar ]
then
	echo "Build Failed Aborting"
	echo "Using fallback"
	echo "Downloading precompiled binary from Official page"
	wget https://github.com/iBotPeaches/Apktool/releases/download/$MAINVER/apktool_$MAINVER.jar -O usr/share/apktool/apktool-cli.jar
else
	echo "Build sucessful"
	cp ./source/brut.apktool/apktool-cli/build/libs/apktool-$MAINVER.jar usr/share/apktool/apktool-cli.jar
fi
cat  <<EOF > usr/bin/apktool
#!/bin/bash
java -jar /usr/share/apktool/apktool-cli.jar "\$@"
EOF
chmod 755 usr/bin/apktool
cat <<EOF > usr/share/applications/apktool.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/apktool
Exec=x-terminal-emulator --command "apktool --help; $SHELL"
Name=APKTool
Icon=terminator
Categories=X-tamer-manualanalysis
EOF
debctrl "apktool" "$VERSION" "A tool for reverse engineering Android apk files\n It is a tool for reverse engineering 3rd party, closed, binary Android apps. \n It can decode resources to nearly original form and rebuild them after making\n some modifications; it makes possible to debug smali code step by step. \n Also it makes working with app easier because of project-like files structure\n and automation of some repetitive tasks like building apk, etc.\n It is NOT intended for piracy and other non-legal uses. \n It could be used for localizing, adding some features or support for custom \n platforms and other GOOD purposes. Just try to be fair with authors of an \n app, that you use and probably like." "https://github.com/AndroidTamer/Apktool" "all" "default-jre"
changelog
build_package usr
