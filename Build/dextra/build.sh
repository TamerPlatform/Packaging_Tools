#!/bin/bash
#http://newandroidbook.com/tools/dextra.tar
MAINVER="1.29.79"
Extra=""
VERSION=$MAINVER$Extra
if [ -d source ]
then
	rm -rf source
fi
mkdir -p source
wget http://newandroidbook.com/tools/dextra.tar -O source/dextra.tar
mkdir -p source/extract 
tar xvf source/dextra.tar -C ./source/extract
if [ ! -f source/extract/dextra.ELF64 ]
then
	echo "tar extraction failed missing dextra.ELF64"
	exit
fi
echo "Checking Version"
BINVER=`./source/extract/dextra.ELF64 2>&1 | grep "version" | grep compiled | cut -f5 -d" "`
echo "Binary Version: " $BINVER
echo "Build Script for : "$MAINVER
if [ "$BINVER" = "$MAINVER" ]
then
	echo "Matched"
else
	echo "Version : Mismatch quiting"
	exit
fi
rm -rf usr opt
mkdir -p usr/bin/ usr/share/applications opt/dextra
cp -r source/extract/* opt/dextra
cat <<EOF >>usr/bin/dextra
#!/bin/bash
cd /opt/dextra
./dextra.ELF64 "\$@"
EOF
chmod 755 usr/bin/dextra
cat <<EOF > usr/share/applications/dextra.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/dextra
Exec=x-terminal-emulator --command "dextra --help; $SHELL"
Name=Dextra
Icon=terminator
Categories=X-tamer-manualanalysis
EOF
debctrl "dextra" "$VERSION" "A tool for DEX and OAT dumping, decompilation, and fuzzing\n The dextra utility began its life as an alternative to the AOSP's dexdump \n and dx --dump, both of which are rather basic, and produce copious, but \n unstructured output. In addition to supporting all their features, it also \n supports various output modes, specific class, method and field lookup, as \n well as determining static field values. I later updated it to support ART \n (which is also one of the reasons why the tool was renamed).\n .\n The dextra tool is provided as one of the free downloads provided for the \n \"Android Internals\" book (http://NewAndroidBook.com/). You are welcome to \n use it even if you don't buy the book (though naturally you're even more \n welcome to buy the book :-). Its method of operation and a lot more about \n Dalvik internals is covered in detail, in Chapters 10 and 11. Its latest \n version, as a tar file with binaries for OS X, Linux/Android x86_64 or\n ARMv7, can always be obtained http://newandroidbook.com/tools/dextra.html" "http://newandroidbook.com/tools/dextra.html" "amd64"
changelog
build_package usr opt