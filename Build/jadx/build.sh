#!/bin/bash
SOURCE_URL="https://github.com/AndroidTamer/jadx"
MAINVER="0.6.1"
Extra=".2"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone $SOURCE_URL ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
## Build
cd source
./gradlew dist
cd ..
## END BUILD
rm -rf usr etc
mkdir -p usr/bin usr/share/jadx usr/share/applications
cp source/build/jadx/bin/jadx usr/bin/jadx
cp source/build/jadx/bin/jadx-gui usr/bin/jadx-gui
#### PATCHING ANDROID TAMER SPECIFIC
sed -i "s/APP_HOME=.*/APP_HOME='\/usr\/share\/jadx\/'/g" usr/bin/jad*
#### PATCHING END
cp -r source/build/jadx/lib usr/share/jadx/
cp source/LICENSE usr/share/jadx/LICENSE
chmod 755 usr/bin/*
cat <<EOF > usr/share/applications/jadx.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=jadx
Exec=/usr/bin/x-terminal-emulator --command "/usr/bin/jadx --help; \$SHELL"
Name=Jadx
Icon=terminator
Categories=X-tamer-re
EOF
cat <<EOF > usr/share/applications/jadx-gui.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=jadx-gui
Exec=/usr/bin/jadx-gui
Name=jadx-gui
Icon=terminator
Categories=X-tamer-re
EOF
chmod 644 usr/share/applications/jadx.desktop
chmod 644 usr/share/applications/jadx-gui.desktop
echo $VERSION
debctrl "jadx" "$VERSION" "Dex to Java decompiler\n Command line and GUI tools for produce Java source code\n from Android Dex and Apk files" "$SOURCE_URL" "all" "default-jre"
changelog
build_package usr
