NAME=jd-gui
VERSION=1.4.0-1
LICENSE=GPL3
xpm -t deb -s dir -n $NAME -v $VERSION -a all --license $LICENSE --deb-custom-control debian/control --exclude .DS_Store  -m "Anant Shrivastava <anant@anantshri.info>" --deb-changelog debian/changelog --vendor TamerPlatform $*
