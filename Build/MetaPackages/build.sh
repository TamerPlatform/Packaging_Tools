#!/bin/bash
# run loop over all control file and then
# extract that changelog from file if file not present
# create file otherwise add a changelog entry for that specific package
export DEBFULLNAME="Anant Shrivastava"
export DEBEMAIL="anant@anantshri.info"
for i in `ls *.control`
do
	#echo $i
	NAME=`grep "^Package:" $i | cut -f2 -d":" | tr -d ' '`
	VERSION=`grep "^Version:" $i | cut -f2 -d":" | tr -d ' '`
	NAME_CHANGELOG=`grep "^Changelog:" $i | cut -f2 -d":" | tr -d ' '`
	EXT=""
	if [ ! -f $NAME_CHANGELOG ]
	then
		EXT="--create "
	fi
	echo $NAME
	echo $VERSION
	echo $NAME_CHANGELOG
	echo $EXT
	dch --package $NAME -v $VERSION $EXT -c $NAME_CHANGELOG
	dch --distribution stable -r "" -c $NAME_CHANGELOG
	equivs-build $i
done
dpkg-sig --sign builder -k 7EE83BCF *.deb