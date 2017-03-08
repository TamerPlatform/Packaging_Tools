#!/bin/bash
MAINVER="2.4.2"
Extra=""
if [ -d "source" ]
	then
	cd source 
	git pull
	cd ..
else
	git clone https://github.com/AndroidTamer/drozer ./source
fi
wget "https://github.com/mwrlabs/drozer/releases/download/$MAINVER/drozer-$MAINVER-py2.7.egg" -O "drozer-$MAINVER-py2.7.egg"
build_pip local source/setup.py
