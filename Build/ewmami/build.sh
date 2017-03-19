#!/bin/bash
MAINVER="0.1.0"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/ewmami ./source
fi
VERSION=$MAINVER$Extra
cd source
gem build ewmami.gemspec
cd ..
fpm -s gem -t deb source/ewmami-$VERSION.gem
dpkg-sig --sign builder -k 7EE83BCF "rubygem-ewmami_"$VERSION"_all.deb"
