NAME=smali
VERSION=2.1.2-87d10dac
LICENSE=BSD-3-clause
xpm -t deb -s dir -n $NAME -v $VERSION -a all --license $LICENSE --deb-custom-control debian/control --exclude .DS_Store  -m "Anant Shrivastava <anant@anantshri.info>" --vendor AndroidTamer $*
