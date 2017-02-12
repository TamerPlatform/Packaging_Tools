#!/bin/bash
SOURCE_URL="https://github.com/AndroidTamer/smalisca"
MAINVER="0.2.1"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone $SOURCE_URL ./source
fi
fpm -s python -t deb --category AndroidTamer -m "Anant Shrivastava <anant@anantshri.info>" --vendor AndroidTamer source/setup.py
#cut -f1 -d"=" source/requirements.txt | xargs build_pip 
build_pip configparser
build_pip graphviz
build_pip cement
build_pip sqlalchemy
build_pip pyfiglet
build_pip flask
build_pip click
build_pip mimerender
build_pip flask-sqlalchemy
build_pip flask-restless
echo "Python packages please doublecheck and sign all of them using the commands listed"
find . -name '*.deb'  -mtime -1 | xargs dpkg-sig --sign builder -k 7EE83BCF 
