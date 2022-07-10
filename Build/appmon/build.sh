#!/bin/bash
MAINVER="0.1"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/appmon ./source
fi
cd source
SVER=`git log --pretty=format:'%h' -n 1`
cd ..
VERSION=$MAINVER$Extra"-SNAPSHOT-"$SVER
echo "Version: " $VERSION
rm -rf usr
mkdir -p usr/share/appmon usr/bin usr/share/applications
cp -r source/* usr/share/appmon/
rm -rf source/screenshots/
cat  <<EOF > usr/bin/appmon
#!/bin/bash
cd /usr/share/appmon/
/usr/share/appmon/appmon.py "\$@"
EOF
chmod 755 usr/bin/appmon

cat  <<EOF > usr/bin/appintruder
#!/bin/bash
cd /usr/share/appmon/intruder
/usr/share/appmon/intruder/appintruder.py "\$@"
EOF
chmod 755 usr/bin/appintruder

cat  <<EOF > usr/bin/appmon_androidTracer
#!/bin/bash
cd /usr/share/appmon/tracer
/usr/share/appmon/tracer/appmon_androidTracer.py "\$@"
EOF
chmod 755 usr/bin/appmon_androidTracer
debctrl "appmon" "$VERSION" "AppMon is an automated framework for monitoring and tampering system API calls" "https://github.com/dpnishant/appmon" "all" "python-argparse, python-frida, python-flask, python-termcolor, python-dataset"
changelog
build_package usr
echo "Building additional dependencies"
build_pip dataset
build_pip normality
build_pip alembic
echo "building editor"
git clone --depth 1 https://github.com/fmoo/python-editor
build_pip local python-editor/setup.py