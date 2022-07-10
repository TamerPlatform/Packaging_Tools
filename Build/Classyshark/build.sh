#!/bin/bash
MAINVER="8.1"
Extra="-1"
if [ ! -d "source" ]
then
	mkdir source
fi
wget https://github.com/google/android-classyshark/releases/download/$MAINVER/ClassyShark.jar -O source/classyshark-$MAINVER.jar
rm -rf usr
#Get commit hash
VERSION=$MAINVER$Extra
mkdir -p usr/share/applications usr/share/classyshark usr/bin usr/share/icons/tamerplatform
cp classyshark.png usr/share/icons/tamerplatform/
cp source/classyshark-$MAINVER.jar usr/share/classyshark/classyshark.jar
cat <<EOF > usr/bin/classyshark
#!/bin/bash
JAR_BIN=/usr/share/classyshark/classyshark.jar
JAVAPRG=/usr/bin/java
echo "Need java 1.8, checking if jdk 8 installed"
if [ ! -f /usr/lib/jvm/java-8-openjdk-amd64/bin/java ]
then
        echo "Java 1.8 openjdk not found"
		echo "Classyshark needs java 8 to work"
else
        echo "Java Found starting"
        export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
        JAVAPRG="/usr/lib/jvm/java-8-openjdk-amd64/bin/java"
fi
\$JAVAPRG -jar \$JAR_BIN "\$@"

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
Icon=/usr/share/icons/tamerplatform/classyshark.png
Categories=X-tamer-manualanalysis
EOF
debctrl "classyshark" "$VERSION" "Android executables browser\n ClassyShark is a standalone tool for Android developers.\n It can reliably browse any Android executable\n and show important info such as\n class interfaces and members, dex counts and dependencies" "https://github.com/TamerPlatform/android-classyshark" "all" "default-jre"
changelog
build_package usr
