#!/bin/bash
MAINVER="0.0.1"
Extra="0.1"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/oat2dex-python ./source
fi
rm -rf usr 
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
## Build
mkdir -p usr/bin usr/share/applications 
cp source/oat2dex.py usr/bin/oat2dex.py
chmod 755 usr/bin/oat2dex.py
cat <<EOF > usr/share/applications/oat2dex.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=OAT2DEX.py
Exec=/usr/bin/x-terminal-emulator --command "oat2dex.py; \$SHELL"
Name=oat2dex
Icon=terminator
Categories=X-tamer-re
EOF
echo $VERSION
debctrl "oat2dex-python" "$VERSION" "Extract DEX files from an ART ELF binary" "https://github.com/AndroidTamer/oat2dex-python" "all" ""
changelog
build_package usr