#!/bin/bash
MAINVER="2.4.3"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/drozer ./source
fi
echo "source as of now needs to be manually edited"
echo 'install_requires = ["protobuf>=2.6.1","pyopenssl>=16.2.0", "pyyaml>=3.12"],'
read -p "Please edit sources and once done press enter" test
cd source
sudo update-java-alternatives -s java-1.8.0-openjdk-amd64
make apks
cd ..
sudo update-java-alternatives -s java-1.7.0-openjdk-amd64
#wget "https://github.com/mwrlabs/drozer/releases/download/$MAINVER/drozer-$MAINVER-py2.7.egg" -O "drozer-$MAINVER-py2.7.egg"
build_pip local source/setup.py
