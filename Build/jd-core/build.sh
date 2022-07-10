#!/bin/bash
#https://github.com/TamerPlatform/source
MAINVER="1.1.3"
Extra="-1"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/jd-core-java ./source
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
chmod 755 ./gradlew
./gradlew clean
./gradlew build
cd ..
mkdir -p usr/bin usr/share/jd-core usr/share/applications
ls -l ./source/build/libs/jd-core-java-$MAINVER.jar 
if [ ! -f ./source/build/libs/jd-core-java-$MAINVER.jar ]
then
	echo "Build Failed Aborting"
	exit
	#echo "Using fallback"
	#echo "Downloading precompiled binary from Official page"
	#wget https://github.com/iBotPeaches/Apktool/releases/download/$MAINVER/apktool_$MAINVER.jar -O usr/share/apktool/apktool-cli.jar
else
	echo "Build sucessful"
	cp ./source/build/libs/jd-core-java-$MAINVER.jar usr/share/jd-core/jd-core.jar
fi
cat  <<EOF > usr/bin/jd-core
#!/bin/bash
java -jar /usr/share/jd-core/jd-core.jar "\$@"
EOF
chmod 755 usr/bin/jd-core
cat <<EOF > usr/share/applications/jd-core.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/jd-core
Exec=x-terminal-emulator --command "jd-core --help; $SHELL"
Name=JD-Core
Icon=terminator
Categories=X-tamer-manualanalysis
EOF
debctrl "jd-core" "$VERSION" "JD-Core \n jd-core java decompiler commandline" "https://github.com/TamerPlatform/jd-core-java" "all" "default-jre"
changelog
build_package usr
