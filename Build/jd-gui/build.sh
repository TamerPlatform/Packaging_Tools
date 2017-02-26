#!/bin/bash
MAINVER="1.4.0"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/jd-gui ./source
fi
rm -rf usr opt
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
## Build
cd source
./gradlew clean
./gradlew build
cd ..
mkdir -p usr/bin usr/share/jd-gui/ usr/share/applications usr/share/icons/androidtamer
cp source/src/linux/resources/jd_icon_128.png usr/share/icons/androidtamer/jd-gui.png
cp source/build/libs/jd-gui-$MAINVER.jar usr/share/jd-gui/
cat <<EOF > usr/bin/jd-gui
#!/bin/bash
java -jar /usr/share/jd-gui/jd-gui-1.4.0.jar "\$@"
EOF
chmod 755 usr/bin/jd-gui
cat <<EOF > usr/share/applications/jd-gui.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=/usr/share/icons/androidtamer/jd-gui.png
Name[en_US]=JD-Gui
Exec=/usr/bin/jd-gui
Name=jd-gui
Icon=/usr/share/icons/androidtamer/jd-gui.png
Categories=X-tamer-re
EOF
#cp source/build/distributions/jd-gui_$MAINVER-0_all.deb ./
#dpkg-sig --sign builder -k 7EE83BCF jd-gui_$MAINVER-0_all.deb
echo $VERSION
debctrl "jd-gui" "$VERSION" "A Java Decompiler\n JD-GUI, a standalone graphical utility that displays Java sources from CLASS files" "https://github.com/AndroidTamer/jd-gui" "all" "default-jre"
changelog
build_package usr