#!/bin/bash
MAINVER="0.0.1"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/YADD ./source
fi
rm -rf usr
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
# Build
cd source
./clean.py --rebuild
cd build
cmake ..
make
cd ..
if [ ! -f bin/dumper ]
then
	echo "build failed"
	exit
fi
cd ..
mkdir -p usr/bin usr/share/applications
cp source/bin/dumper usr/bin/dumper
chmod 755 usr/bin/dumper
cat <<EOF > usr/share/applications/dumper.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/dumper
Exec=x-terminal-emulator --command "dumper --help; $SHELL"
Name=YAAD-dumper
Description: Yet another Android Dex bytecode Disassembler
Icon=terminator
Categories=X-tamer-manualanalysis
EOF
debctrl "yaad-dumper" "$VERSION" "Yet another Android Dex bytecode Disassembler\n YADD is planed to be a complex disassembler for the Android Dex bytecode\n hat is, a hybrid tool to support pure binary/signature dumping and to provide an interface for reversing analysis" "https://github.com/AndroidTamer/YAAD" "all" "python"
changelog
build_package usr
