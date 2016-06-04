#!/bin/bash
MAINVER="0.1"
Extra=".1"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/JAADAS ./source
fi
rm -rf usr
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
# Setting java 8
echo "Java going to 8 for some time"
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
# Build
cd source
# git submodule update --init --recursive
# ./gradlew clean
# ./gradlew build
# ./gradlew fatJar 
./gradlew clean
./gradlew fatJar
cd ..
echo "Reverting back to 7"
sudo update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
mkdir -p usr/bin usr/share/jaadas usr/share/applications
# ls -l ./source/brut.apktool/apktool-cli/build/libs/apktool-$MAINVER.jar 
if [ ! -f ./source/jade/build/libs/jade-$MAINVER.jar ]
then
 	echo "Build Failed"
 	#exit
	echo "Using fallback"
	echo "Downloading precompiled binary from Official page"
	wget https://github.com/flankerhqd/JAADAS/releases/download/release$MAINVER/jaadas-$MAINVER.zip -O usr/share/jaadas/jaadas.zip
	cd usr/share/jaadas
	unzip jaadas.zip
	cd ../../../
	mv usr/share/jaadas/jade-$MAINVER.jar usr/share/jaadas/jade.jar
	rm usr/share/jaadas/jaadas.zip
else
 	echo "Build sucessful"
 	cp ./source/jade/build/libs/jade-$MAINVER.jar usr/share/jaadas/jade.jar
 	cp -r ./source/jade/build/libs/config usr/share/jaadas/
fi

cat  <<EOF > usr/bin/jaadas
#!/bin/bash
JAR_BIN=/usr/share/jaadas/jade.jar
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
echo $1
if [[ "\$1" == "-Xmx"* ]]
then
        MEM=\$1
        shift
        echo "Custom Max memory size found $MEM"
fi
\$JAVAPRG -jar \$MEM \$JAR_BIN "\$@"
EOF
chmod 755 usr/bin/jaadas
cat <<EOF > usr/share/applications/jaadas.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/jaadas
Exec=x-terminal-emulator --command "jaadas ; \$SHELL"
Name=JAADAS
Icon=terminator
Categories=X-tamer-manualanalysis
EOF
debctrl "jaadas" "$VERSION" "Joint Advanced Defect assEsment for android applications\n JAADAS is a tool written in Java and Scala with the power of Soot \n to provide both interprocedure and intraprocedure static analysis \n for android applications. Its features include API misuse analysis, \n local-denial-of-service (intent crash) analysis, inter-procedure style\n taint flow analysis (from intent to sensitive API, i.e. getting a \n parcelable from intent, and use it to start activity)." "https://github.com/Androidtamer/JAADAS" "all" "default-jre"
changelog
build_package usr
