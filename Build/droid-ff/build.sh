#!/bin/bash
MAINVER="0.1.0"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/droid-ff ./source
fi
rm -rf usr
#Get commit hash
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
# Build
mkdir -p usr/bin usr/share/droid-ff usr/share/applications
# ensuring new binaries are executable
chmod 755 source/third_party/android_gdb/*
cp -r source/* usr/share/droid-ff/
# these values are android tamer specific assuming /opt/Arsenal/ being used for sdk and ndk
sed -i "s/ndkstack.*/ndkstack='\/opt\/Arsenal\/android-ndk\/ndk-stack'/g" usr/share/droid-ff/fuzzerConfig.py
sed -i "s/addr2line.*/addr2line='\/opt\/Arsenal\/android-ndk\/toolchains\/arm-linux-androideabi-4.9\/prebuilt\/linux-x86_64\/bin\/arm-linux-androideabi-addr2line'" usr/share/droid-ff/fuzzerConfig.py
cat  <<EOF > usr/bin/droid-ff
#!/bin/bash
if [ ! -f ~/.droid-ff-ready ]
then
	echo "Looks like running droid-ff for first time"
	echo "Setting up the environment"
	echo "Please provide your sudo credentials if asked"
	echo "we need to install 2 python modules pyZZUF, adb_android"
	sudo pip install pyZZUF
	sudo pip install adb_android
	mkdir -p \$HOME"/droid-ff/confirmed_crashes/"
	mkdir -p \$HOME"/droid-ff/crashes/"
	mkdir -p \$HOME"/droid-ff/generated_samples_folder/"
	cp -r /usr/share/droid-ff/symbols \$HOME"/droid-ff"
	cp -r /usr/share/droid-ff/mutation_sample \$HOME"/droid-ff/"
	touch ~/.droid-ff-ready
fi
if [ ! -f ~/droid-ff/.ready_$VERSION ]
then
	echo "Looks like running droid-ff ($VERSION) for first time"
	echo "Setting up the environment changes in this edition"
	mkdir -p \$HOME"/droid-ff/unique_crashes/"
	touch ~/.droid-ff/.ready_$VERSION
fi
echo "environment all setup"
echo "starting droid-ff"
cd /usr/share/droid-ff/
clear
python droid-ff.py
EOF
chmod 755 usr/bin/droid-ff
cat <<EOF > usr/share/applications/droid-ff.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
TryExec=/usr/bin/droid-ff
Exec=x-terminal-emulator --command "/usr/bin/droid-ff ; \$SHELL"
Name=Droid-ff 
Icon=terminator
Categories=X-tamer-fuzz
EOF
debctrl "droid-ff" "$VERSION" "A tool for automating Android Fuzzing" "https://github.com/AndroidTamer/droid-ff" "all" 
changelog
build_package usr

