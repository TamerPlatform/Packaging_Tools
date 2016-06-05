#!/bin/bash
MAINVER="1.0.0"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/simplify ./source
fi
rm -rf usr
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
# Setting java 8
echo "Java going to 8 for some time"
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
# Build
cd source
git submodule update --init --recursive
./gradlew clean
./gradlew fatJar 
cd ..
echo "Reverting back to 7"
sudo update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
mkdir -p usr/bin usr/share/simplify usr/share/applications
ls -l ./source/simplify/build/libs/simplify.jar
if [ ! -f ./source/simplify/build/libs/simplify.jar ]
then
	echo "Build Failed Aborting"
	exit
else
	echo "Build sucessful"
fi
cp ./source/simplify/build/libs/simplify.jar usr/share/simplify/simplify.jar
cat  <<EOF > usr/bin/simplify
#!/bin/bash
JAR_BIN=/usr/share/simplify/simplify.jar
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
MEM=""
if [[ "\$1" == "-Xmx"* ]]
then
        MEM=\$1
        shift
        echo "Custom Max memory size found $MEM"
fi
\$JAVAPRG -jar \$MEM \$JAR_BIN "\$@"
EOF
chmod 755 usr/bin/simplify
cat <<EOF > usr/share/applications/simplify.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/simplify
Exec=x-terminal-emulator --command "simplify --help; \$SHELL"
Name=Simplify
Icon=terminator
Categories=X-tamer-manualanalysis
EOF
debctrl "simplify" "$VERSION" "Generic Android Deobfuscator\n Simplify uses a virtual machine to execute an app and understand what \n it does. Then, it applies optimizations to create code that behaves \n identically but is easier for a human to understand. It is a generic \n deobfuscator because it doesn't need any special configuration or code \n for different types of obfuscation." "https://github.com/AndroidTamer/simplify" "all" "default-jre"
changelog
build_package usr
