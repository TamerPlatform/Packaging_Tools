#!/bin/bash
#http://newandroidbook.com/tools/imgtool.tar
MAINVER="0.3"
Extra=""
VERSION=$MAINVER$Extra
if [ -d source ]
then
	rm -rf source
fi
mkdir -p source
wget http://newandroidbook.com/files/imgtool.tar -O source/imgtool.tar
mkdir -p source/extract 
tar xvf source/imgtool.tar -C ./source/extract
if [ ! -f source/extract/imgtool ]
then
	echo "tar extraction failed missing imgtool.ELF64"
	exit
fi
echo "Checking Version"
BINVER=`./source/extract/imgtool.ELF64 2>&1 | grep "compiled" | cut -f4 -d" "`
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
mkdir -p usr/bin/ usr/share/applications opt/imgtool
cp -r source/extract/imgtool* opt/imgtool
chmod 755 opt/imgtool/imgtool*
cat <<EOF >>usr/bin/imgtool
#!/bin/bash
NM=""
if [ `getconf LONG_BIT` = "64" ]
then
    NM="ELF64"
else
    NM="ELF32"
fi
cd /opt/imgtool
./imgtool.\$NM "\$@"
EOF
chmod 755 usr/bin/imgtool
cat <<EOF > usr/share/applications/imgtool.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/imgtool
Exec=x-terminal-emulator --command "imgtool; $SHELL"
Name=imgtool
Icon=terminator
Categories=X-tamer-romdev
EOF
debctrl "imgtool" "$VERSION" "A tool for unpacking/creating Android boot partition images\n The imgtool utility is another one of the tools included in \n http://newandroidbook.com book related to Boot process. This tool \n acts like a quick extractor for variosu images and internal formats \n used by difference boot images. This became more important with the \n L preview, and Google Glass system images.\n .\n If you need a quick tool to unpack Android images, this is useful. \n Think of it as the inverse of mkbootimg (from the AOSP), coupled \n with simg2img (the sparse image extractor). Another bonus feature \n it provides is unpacking the Linux bzimage kernels." "http://newandroidbook.com/tools/imgtool.html" "all"
changelog
build_package usr opt