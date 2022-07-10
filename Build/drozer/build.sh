#!/bin/bash
MAINVER="2.4.2"
Extra="-1"
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone --depth 1 https://github.com/TamerPlatform/drozer ./source
fi
VERSION=$MAINVER$Extra
# Temp fix for issue https://github.com/mwrlabs/drozer/issues/253
sed -i 's/install_requires = ["protobuf==2.6.1","pyopenssl==16.2", "pyyaml==3.11"],/install_requires = ["protobuf>=2.6.1","pyopenssl>=16.2.0", "pyyaml>=3.12"],/g' source/setup.py
cd source
sudo update-java-alternatives -s java-1.8.0-openjdk-amd64
make apks
cd ..
sudo update-java-alternatives -s java-1.7.0-openjdk-amd64
debctrl "python-drozer" "$VERSION" "The Leading Android Security Testing Framework" "http://mwr.to/drozer" "all" "python-protobuf (>= 2.6.1), python-pyopenssl (>= 16.2.0), python-pyyaml (>= 3.12)" 
build_pip local  --replaces drozer --verbose --deb-custom-control debian/control source/setup.py
echo "Building dependencies"
# not building newer version are more error prone
#build_pip protobuf
build_pip pyopenssl
build_pip pyyaml
build_pip cryptography
build_pip appdirs
build_pip asn1crypto
# need libffi-dev to be installed
build_pip cffi
build_pip idna
build_pip ipaddress
build_pip packaging
build_pip pycparser
build_pip pyparsing
build_pip setuptools
build_pip six
# Autosign all binary created today
echo "Autosigning all binaries done today"
find ./ -name '*.deb' -maxdepth 1 -mtime -1 -exec dpkg-sig --sign builder -k 7EE83BCF "{}" \;
