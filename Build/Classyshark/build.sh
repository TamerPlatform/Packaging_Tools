#!/bin/bash
MAINVER="6.7"
Extra=""
if [ ! -d "source" ]
then
	mkdir source
fi
wget https://github.com/google/android-classyshark/releases/download/$MAINVER/ClassyShark.jar -O source/classyshark-$MAINVER.jar
rm -rf usr
#Get commit hash
VERSION=$MAINVER$Extra
mkdir -p usr/share/applications usr/share/classyshark usr/bin usr/share/icons/androidtamer
cp classyshark.png usr/share/icons/androidtamer/
cp source/classyshark-$MAINVER.jar usr/share/classyshark/classyshark.jar
cat <<EOF > usr/bin/classyshark
#!/bin/bash
java -jar /usr/share/classyshark/classyshark.jar "\$@"
EOF
chmod 755 usr/bin/classyshark
cat <<EOF > usr/share/applications/classyshark.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/classyshark
Exec=/usr/bin/classyshark
Name=ClassyShark
Icon=/usr/share/icons/androidtamer/classyshark.png
Categories=X-tamer-manualanalysis
EOF
debctrl "classyshark" "$VERSION" "Android executables browser\n ClassyShark is a standalone tool for Android developers.\n It can reliably browse any Android executable\n and show important info such as\n class interfaces and members, dex counts and dependencies" "https://github.com/AndroidTamer/android-classyshark" "all" "default-jre"
changelog
build_package usr
