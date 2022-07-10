#!/bin/bash
MAINVER="1.0.0"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/AndroBugs_Framework ./source
fi
rm -rf usr
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
# Build
mkdir -p usr/bin usr/share/androbugs_framework usr/share/applications
cp -r ./source/* usr/share/androbugs_framework
cat  <<EOF > usr/bin/androbugs
#!/bin/bash
python2 /usr/share/androbugs_framework/androbugs.py "\$@"
EOF
chmod 755 usr/bin/androbugs
cat <<EOF > usr/share/applications/androbugs.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/androbugs
Exec=x-terminal-emulator --command "androbugs -h; \$SHELL"
Name=Androbugs Framework
Icon=terminator
Categories=X-tamer-dynamic
EOF
debctrl "androbugs-framework" "$VERSION" "Android Vulnerability scanner\n AndroBugs Framework is an Android vulnerability analysis system that \n helps developers or hackers find potential security vulnerabilities \n in Android applications. No splendid GUI interface, but the most \n efficient (less than 2 minutes per scan in average) and more accurate." "https://github.com/TamerPlatform/AndroBugs_Framework" "all" "python"
changelog
build_package usr
