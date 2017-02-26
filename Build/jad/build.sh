#!/bin/bash
MAINVER="1.5.8e"
Extra="2"
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
rm -rf opt usr
mkdir -p opt/jad usr/bin usr/share/applications
cp source/* opt/jad/
cat <<EOF > usr/bin/jad
#!/bin/bash
/opt/jad/jad "\$@"
EOF
cat <<EOF > usr/share/applications/jad.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=terminator
Name[en_US]=JAD
Exec=/usr/bin/x-terminal-emulator --command "/usr/bin/jad --help; \$SHELL"
Name=JAD
Icon=terminator
Categories=X-tamer-re
EOF
chmod 755 usr/bin/jad
debctrl "jad" "$VERSION"
changelog
debctrl "jad" "$VERSION" "Java Decompiler\n One of the oldest Java Decompiler.\n Original Distribution place is long gone from web.\n Homepage is a mirror hosting last versions of decompiler." "http://varaneckas.com/jad/" "all" "default-jre"
build_package opt usr

