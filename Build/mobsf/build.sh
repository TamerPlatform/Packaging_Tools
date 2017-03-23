#!/bin/bash
MAINVER="0.9.4.1"
Extra="-3"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/androidtamer/Mobile-Security-Framework-MobSF ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER"-SNAPSHOT-"$SVER$Extra
mkdir -p usr/bin usr/share/MobSF usr/share/applications
cp -r source/* usr/share/MobSF/
rm -rf usr/share/MobSF/.git
cat  <<EOF > usr/bin/mobsf 
#!/bin/bash
IP=0.0.0.0
PORT=3000
cd /usr/share/MobSF/
echo "Starting MobSF"
python manage.py runserver \$IP:\$PORT
EOF
chmod 755 usr/bin/mobsf
cat <<EOF > usr/share/applications/mobsf-server.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=x-terminal-emulator --command "/usr/bin/mobsf"
Name=MobSF Start Server
Icon=terminator
Categories=X-tamer-dynamic
EOF
cat <<EOF > usr/share/applications/mobsf-ui.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=x-www-browser http://127.0.0.1:3000/
Name=MobSF Start UI
Icon=terminator
Categories=X-tamer-dynamic
EOF
cat <<EOF > usr/share/applications/mobsf-setup.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=x-terminal-emulator --command "python /usr/share/MobSF/mobsfy.py"
Name=MobSF Setup Device
Icon=terminator
Categories=X-tamer-dynamic
EOF


# Enable USE_HOME by default
sed -i "s/USE_HOME = False/USE_HOME = True/" usr/share/MobSF/MobSF/settings.py
# Set local parameters
sed -i 's/DEX2JAR_BINARY = ""/DEX2JAR_BINARY = "\/usr\/local\/share\/dex2jar\/d2j-dex2jar.sh"/' usr/share/MobSF/MobSF/settings.py
sed -i 's/BACKSMALI_BINARY = ""/BACKSMALI_BINARY = "\/usr\/local\/smali\/baksmali-fat.jar"/' usr/share/MobSF/MobSF/settings.py
#sed -i 's/AXMLPRINTER_BINARY = ""/AXMLPRINTER_BINARY = "\/usr\/share\/axmlprinter\/axmlprinter.jar"/' usr/share/MobSF/MobSF/settings.py
sed -i 's/CFR_DECOMPILER_BINARY = ""/CFR_DECOMPILER_BINARY = "\/usr\/share\/cfr\/cfr.jar"/' usr/share/MobSF/MobSF/settings.py
sed -i 's/PROCYON_DECOMPILER_BINARY = ""/PROCYON_DECOMPILER_BINARY = "\/usr\/share\/procyon\/procyon-decompiler.jar"/' usr/share/MobSF/MobSF/settings.py
sed -i 's/ADB_BINARY = ""/ADB_BINARY = "\/usr\/local\/bin\/adb"/' usr/share/MobSF/MobSF/settings.py
sed -i 's/ENJARIFY_DIRECTORY = ""/ENJARIFY_DIRECTORY = "\/usr\/share\/enjarify\/"/' usr/share/MobSF/MobSF/settings.py
sed -i 's/JD_CORE_DECOMPILER_BINARY = ""/JD_CORE_DECOMPILER_BINARY = "\/usr\/share\/jd-core\/jd-core.jar"/' usr/share/MobSF/MobSF/settings.py
# Set realdevice to true
#sed -i "s/REAL_DEVICE = False/REAL_DEVICE = True/" usr/share/MobSF/MobSF/settings.py
echo "Building dependencies"
while read p;
do 
	build_pip $p;
done<source/requirements.txt
debctrl "mobsf" "$VERSION" "Mobile Security Framework (MobSF)\n MobSF is an intelligent, all-in-one open source mobile application \n (Android/iOS) automated pen-testing framework capable of performing static\n and dynamic analysis. We've been depending on multiple tools to carry out \n reversing, decoding, debugging, code review, and pen-test and this process\n requires a lot of effort and time. Mobile Security Framework can be used for\n effective and fast security analysis of Android and iOS Applications. It \n supports binaries (APK & IPA) and zipped source code." "https://github.com/AndroidTamer/Mobile-Security-Framework-MobSF" "all" "python-django, python-openssl, python-tornado,  python-configparser, python-rsa, python-pdfkit, python-lxml, dex2jar, enjarify, jd-core, cfr"
changelog
build_package usr
build_pip django
