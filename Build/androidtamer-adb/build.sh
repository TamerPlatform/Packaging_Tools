#!/bin/bash
#!/bin/bash
MAINVER="0.6"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/adb_wrapper ./source
fi
rm -rf usr
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
rm -rf usr etc
mkdir -p usr/bin usr/local/bin usr/share/applications etc/udev/rules.d
cp source/adb usr/bin/adb
cp source/fastboot usr/bin/fastboot
cp source/adb_wrapper usr/local/bin/adb
chmod 755 usr/local/bin/adb
chmod 755 usr/bin/fastboot
chmod 755 usr/bin/adb
cp source/99-android.rules etc/udev/rules.d/99-android.rules
cat <<EOF > usr/share/applications/tamerplatform-adb.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/local/bin/adb
Exec=x-terminal-emulator --command "adb --help; $SHELL"
Name=Android Debug Bridge
Icon=terminator
Categories=X-tamer
EOF
cat <<EOF > usr/share/applications/tamerplatform-fastboot.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=fastboot
Exec=x-terminal-emulator --command "fastboot --help; fastboot devices; $SHELL"
Name=Fastboot
Icon=terminator
Categories=X-tamer-romdev
EOF
debctrl "tamerplatform-adb" "$VERSION" "TamerPlatform Customized ADB\n Source compiled ADB and fastboot\n additional wrapper added with features like adb list\n and device naming" "https://github.com/TamerPlatform/adb_wrapper" "all" "libc6, libssl1.0.0, zlib1g" "android-tools-adb, android-tools-fastboot"
changelog
build_package etc usr
