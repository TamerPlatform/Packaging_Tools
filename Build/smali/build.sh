#!/bin/bash
MAINVER="2.2.0"
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
# Setting java 8
echo "Java going to 8 for some time"
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
# Build
cd source
./gradlew clean
./gradlew fatjar
cd ..
echo "Reverting back to 7"
sudo update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-7-openjdk-amd64/bin/javac

## END BUILD
rm -rf usr etc
mkdir -p usr/bin usr/share/smali usr/share/applications
cp source/smali/build/libs/smali-*-fat.jar usr/share/smali/smali-fat.jar
cp source/baksmali/build/libs/baksmali-*-fat.jar usr/share/smali/baksmali-fat.jar
if [ ! -f usr/share/smali/smali-fat.jar ]
then
	echo "looks like build failed"
	exit
fi
cat <<EOF > usr/bin/smali
#!/bin/bash
JAR_BIN=/usr/share/smali/smali-fat.jar
JVER=\`java -version 2>&1 | awk '/version/ {print \$3}' | egrep -o '[^\"]*' | cut -f1,2 -d"."\`
if [ "\$JVER" = "1.8" ]
then
        JAVAPRG=/usr/bin/java
else
        echo "Need java 1.8, checking if jdk 8 installed"
        if [ ! -f /usr/lib/jvm/java-8-openjdk-amd64/bin/java ]
        then
                echo "Java 1.8 openjdk not found"
                echo "please install openjdk-8 from jessie backports or simmilar"
                exit
        else
                echo "Java Found starting"
                export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
                JAVAPRG="/usr/lib/jvm/java-8-openjdk-amd64/bin/java"
        fi
fi

\$JAVAPRG -jar \$MEM \$JAR_BIN "\$@"
EOF
chmod 755 usr/bin/smali
cat <<EOF > usr/bin/baksmali
#!/bin/bash
JAR_BIN=/usr/share/smali/baksmali-fat.jar
JVER=\`java -version 2>&1 | awk '/version/ {print \$3}' | egrep -o '[^\"]*' | cut -f1,2 -d"."\`
if [ "\$JVER" = "1.8" ]
then
        JAVAPRG=/usr/bin/java
else
        echo "Need java 1.8, checking if jdk 8 installed"
        if [ ! -f /usr/lib/jvm/java-8-openjdk-amd64/bin/java ]
        then
                echo "Java 1.8 openjdk not found"
                echo "please install openjdk-8 from jessie backports or simmilar"
                exit
        else
                echo "Java Found starting"
                export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
                JAVAPRG="/usr/lib/jvm/java-8-openjdk-amd64/bin/java"
        fi
fi

\$JAVAPRG -jar \$MEM \$JAR_BIN "\$@"
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
