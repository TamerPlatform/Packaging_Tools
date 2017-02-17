#!/bin/bash
SOURCE_URL="https://github.com/AndroidTamer/androidAuditTools"
MAINVER="2011"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone $SOURCE_URL ./source
fi
rm -rf usr
build_gem trollop
build_gem colored
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
# Commit
rm -rf usr
mkdir -p usr/bin usr/share/androidaudittools usr/share/applications usr/share/androidaudittools/bin usr/share/androidaudittools/src
cp source/bin/*.rb  usr/share/androidaudittools/bin/
cp source/src/*.rb  usr/share/androidaudittools/src/
chmod +x usr/share/androidaudittools/bin/*.rb
cat <<EOF > usr/bin/fsdiff
#!/bin/bash
cd /usr/share/androidaudittools/bin/
ruby fsdiff.rb "\$@"
EOF
cat <<EOF > usr/share/applications/fsdiff.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=FSDiff
Exec=/usr/bin/x-terminal-emulator --command "/usr/bin/fsdiff --help; \$SHELL"
Name=FSDiff
Icon=terminator
Categories=X-tamer-forensics
EOF
chmod 755 usr/bin/fsdiff
chmod 644 usr/share/applications/*.desktop
echo $VERSION
debctrl "androidaudittools" "$VERSION" "androidaudittools are collection of foreensic evaluation scripts useful for android devices." "$SOURCE_URL" "all" "rubygem-trollop, rubygem-colored"
changelog
build_package usr