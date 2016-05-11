#!/bin/bash
MAINVER="1.11.6"
Extra="-1"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/sslscan ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
mkdir -p usr/bin usr/share/applications
cd source 
make static
cd ..
cp source/sslscan usr/bin/sslscan
cat << EOF > usr/share/applications/sslscan.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=SSLScan 
Exec=/usr/bin/x-terminal-emulator --command "sslscan --help; \$SHELL"
Name=Fast SSL Scanner
Icon=terminator
Categories=X-tamer-pentest
EOF
chmod 644 usr/share/applications/sslscan.desktop
echo $VERSION
debctrl "sslscan" "$VERSION" "Fast SSL Scanner\n SSL scanning software" "https://github.com/AndroidTamer/sslscan" "amd64"
changelog
build_package usr