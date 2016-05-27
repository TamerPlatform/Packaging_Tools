#!/bin/bash
MAINVER="2.1"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/dex2jar ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
## Build
cd source
./gradlew 
cd ..
## END BUILD
rm -rf usr etc
mkdir -p usr/bin usr/share/ usr/share/applications
unzip source/dex-tools/build/distributions/dex-tools-$MAINVER-SNAPSHOT.zip -d usr/share/
mv usr/share/dex-tools-$MAINVER-SNAPSHOT usr/share/dex2jar
cp usr/share/dex2jar/*.sh usr/bin/
#### Tamer Specific PAtch for force prgdir to /usr/share/dex2jar/
sed -i "s/PRGDIR=.*/PRGDIR='\/usr\/share\/dex2jar\/'/g" usr/bin/*.sh
#### Patch end
chmod 755 usr/bin/*.sh
cat <<EOF > usr/share/applications/dex2jar.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=Dex2Jar
Exec=x-terminal-emulator --command "cd /usr/bin; ls d2j*; $SHELL"
Name=Dex2Jar
Icon=terminator
Categories=X-tamer-re
EOF
chmod 644 usr/share/applications/dex2jar.desktop
echo $VERSION
debctrl "dex2jar" "$VERSION" "Tools to work with android .dex and java .class files\n dex2jar is a suite consisting of commands\n dex-reader/writer: Read/write the Dalvik Executable (.dex) file. It has a light weight API similar with ASM.\n d2j-dex2jar: Convert .dex file to .class files (zipped as jar)\n smali/baksmali: disassemble dex to smali files and assemble dex from smali files. different implementation to smali/baksmali, same syntax, but we support escape in type desc Lcom/dex2jar\t\u1234;\n other tools: d2j-decrypt-string" "https://github.com/AndroidTamer/dex2jar" "all" "default-jre"
changelog
build_package usr
