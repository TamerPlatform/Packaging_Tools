#!/bin/bash
MAINVER="0.0.1"
Extra="-1"
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
cp source/bin/dumper usr/bin/yadd-dumper
chmod 755 usr/bin/yadd-dumper
cat <<EOF > usr/share/applications/yadd-dumper.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/yadd-dumper
Exec=x-terminal-emulator --command "yadd-dumper --help; $SHELL"
Name=YAAD-dumper
Description: Yet another Android Dex bytecode Disassembler
Icon=terminator
Categories=X-tamer-manualanalysis
EOF
debctrl "yadd-dumper" "$VERSION" "Yet another Android Dex bytecode Disassembler\n YADD is planed to be a complex disassembler for the Android Dex bytecode\n That is, a hybrid tool to support pure binary/signature dumping and to \n provide an interface for reversing analysis" "https://github.com/AndroidTamer/YADD" "amd64" "python, libc6"
changelog "Initial release for Android Tamer"
build_package usr
