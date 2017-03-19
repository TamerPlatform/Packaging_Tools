#!/bin/bash
MAINVER="0.4"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/drozer_checks ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
echo "Version: " $VERSION
rm -rf usr
mkdir -p usr/bin usr/share/applications
cp source/drozer_checks usr/bin/drozer_checks
cp source/drozer_start usr/bin/drozer_start
chmod 755 usr/bin/drozer_start
chmod 755 usr/bin/drozer_checks
cat <<EOF > usr/share/applications/drozer_checks.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/x-terminal-emulator --command "drozer_checks; \$SHELL"
Name=Drozer Checks
Icon=terminator
Categories=X-tamer-dynamic
EOF
cat <<EOF > usr/share/applications/drozer_start.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/x-terminal-emulator --command "drozer_start; \$SHELL"
Name=Drozer Start
Icon=terminator
Categories=X-tamer-re
EOF
debctrl "drozer-checks" "$VERSION" "Automated Drozer Assessment\n A Shell script wrapper to ease out the process\n of running drozer and help in quick analysis.\n Depends on drozer" "https://github.com/AndroidTamer/drozer_checks" "all" "python-drozer"
changelog
build_package usr
