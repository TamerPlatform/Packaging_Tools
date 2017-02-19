#!/bin/bash
MAINVER="1.7.17"
Extra=""
VERSION=$MAINVER$Extra
#mkdir source
wget "https://portswigger.net/Burp/Releases/Download?productId=100&version="$MAINVER"&type=Jar" -O source/burpsuite-free.jar
wget "https://portswigger.net/burp/eula-free.html" -O source/license.html
html2text "https://portswigger.net/burp/eula-free.html" | tee source/license.txt
rm -rf usr opt
mkdir -p usr/bin opt/burpsuite/ usr/share/applications usr/share/icons/androidtamer
cp source/burpsuite-free.jar opt/burpsuite/
cp source/license.txt opt/burpsuite/license.txt
cp burpsuite-free.png usr/share/icons/androidtamer/burpsuite-free.png 
cat <<EOF > usr/bin/burpsuite-free
#!/bin/bash
java -jar /opt/burpsuite/burpsuite-free.jar "\$@"
EOF
cat <<EOF > usr/share/applications/burpsuite-free.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/burpsuite-free
Name=BurpSuite-Free
Icon=/usr/share/icons/androidtamer/burpsuite-free.png
Categories=X-tamer-pentest
EOF
chmod 755 usr/bin/burpsuite-free
debctrl "burpsuite-free" "$VERSION" "Burp Suite Free\n is a platform for performing security testing of web applications.\n Its various tools work seamlessly together to support the entire testing process,\n from initial mapping and analysis of an application's attack surface,\n through to finding and exploiting security vulnerabilities.\n Burp gives you full control, letting you combine advanced manual techniques\n with state-of-the-art automation, to make your work faster,\n more effective, and more fun." "http://portswigger.net/index.html" "all" "default-jre"
changelog
build_package usr opt
