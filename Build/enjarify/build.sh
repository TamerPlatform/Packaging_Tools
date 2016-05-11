#!/bin/bash
MAINVER="1.0.2"
Extra="-1"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/enjarify ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
rm -rf usr etc
mkdir -p usr/bin usr/share/enjarify usr/share/applications
#### PYTHON PATH PATCH
sed "s/PYTHONPATH=.*/PYTHONPATH='\/usr\/share\/enjarify'/g" source/enjarify.sh > usr/bin/enjarify
#### PYTHON PATH PATCH Ends
chmod 755 usr/bin/enjarify
cp -r source/enjarify usr/share/enjarify/
cat << EOF > usr/share/applications/enjarify.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=Enjarify
Exec=/usr/bin/x-terminal-emulator --command "enjarify --help; \$SHELL"
Name=Engarify
Icon=terminator
Categories=X-tamer-re
EOF
chmod 644 usr/share/applications/enjarify.desktop
echo $VERSION
debctrl "enjarify" "$VERSION" "Java Decompiler\n Enjarify is a tool for translating Dalvik bytecode\n to equivalent Java bytecode. This allows Java analysis tools\n to analyze Android applications." "https://github.com/AndroidTamer/enjarify" "all" "python3"
changelog
build_package usr