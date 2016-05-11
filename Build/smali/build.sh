#!/bin/bash
MAINVER="2.1.2"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/smali ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
## Build
cd source
./gradlew fatjar
cd ..
## END BUILD
rm -rf usr etc
mkdir -p usr/bin usr/share/smali usr/share/applications
cp source/smali/build/libs/smali-*-fat.jar usr/share/smali/smali-fat.jar
cp source/baksmali/build/libs/baksmali-*-fat.jar usr/share/smali/baksmali-fat.jar
cat <<EOF > usr/bin/smali
#!/bin/bash
java -jar /usr/share/smali/smali-fat.jar "\$@"
EOF
chmod 755 usr/bin/smali
cat <<EOF > usr/bin/baksmali
#!/bin/bash
java -jar /usr/share/smali/baksmali-fat.jar "\$@"
EOF
chmod 755 usr/bin/baksmali
cat <<EOF > usr/share/applications/smali.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=Smali
Exec=/usr/bin/x-terminal-emulator --command "/usr/bin/smali --help; \$SHELL"
Name=Smali
Icon=terminator
Categories=X-tamer-re
EOF
cat <<EOF > usr/share/applications/baksmali.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=Baksmali
Exec=/usr/bin/x-terminal-emulator --command "/usr/bin/baksmali --help; \$SHELL"
Name=Baksmali
Icon=terminator
Categories=X-tamer-re
EOF
chmod 644 usr/share/applications/smali.desktop
chmod 644 usr/share/applications/baksmali.desktop
echo $VERSION
debctrl "smali" "$VERSION" "assembler/disassembler for the dex format" "https://github.com/AndroidTamer/smali" "all" "default-jre"
changelog
build_package usr