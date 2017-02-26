#!/bin/bash
#https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-0.5.30.jar
#http://www.benf.org/other/cfr/cfr_0_119.jar
MAINVER="0.5.30"
EXTRA=""
VERSION=$MAINVER$EXTRA
echo $VERSION
URL="https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-"$MAINVER".jar"
echo $URL
mkdir -p source
wget $URL -O "source/procyon-decompiler-"$MAINVER".jar"
rm -rf usr
mkdir -p usr/share/procyon usr/bin
cp "source/procyon-decompiler-"$MAINVER".jar" usr/share/procyon/procyon-decompiler.jar
cat  <<EOF > usr/bin/procyon-decompiler
#!/bin/bash
java -jar /usr/share/procyon/procyon-decompiler.jar "\$@"
EOF
chmod 755 usr/bin/procyon-decompiler
debctrl "procyon" "$VERSION" "Procyon Decompiler\n Procyon Java Decompiler" "https://bitbucket.org/mstrobel/procyon" "all" "default-jre"
changelog
build_package usr
