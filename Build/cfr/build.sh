#!/bin/bash
#http://www.benf.org/other/cfr/cfr_0_119.jar
MAINVER="119"
RELEASE_DATE="nov-2016"
EXTRA=""
VERSION="0-"$MAINVER"-"$RELEASE_DATE$EXTRA
echo $VERSION
URL="http://www.benf.org/other/cfr/cfr_0_"$MAINVER".jar"
echo $URL
mkdir -p source
wget $URL -O "source/cfr_0_"$MAINVER".jar"
html2text "http://www.benf.org/other/cfr/license.html" | tee source/license.txt
rm -rf usr
mkdir -p usr/share/cfr usr/bin
cp "source/cfr_0_"$MAINVER".jar" usr/share/cfr/cfr.jar
cp source/license.txt usr/share/cfr/license.txt
cat  <<EOF > usr/bin/cfr
#!/bin/bash
java -jar /usr/share/cfr/cfr.jar "\$@"
EOF
chmod 755 usr/bin/cfr
debctrl "cfr" "$VERSION" "CFR  another java decompiler\n CFR will decompile modern Java feature like  \n Java 8 lambdas \n Java 7 String switches \n But written in Java 6" "http://www.benf.org/other/cfr/" "all" "default-jre"
changelog
build_package usr
