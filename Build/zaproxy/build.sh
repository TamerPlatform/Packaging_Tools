#!/bin/bash
VERSION="2.6.0"
wget -c "https://github.com/zaproxy/zaproxy/releases/download/$VERSION/zaproxy-$VERSION.deb" -O "zaproxy-$VERSION.deb"
dpkg-sig --sign packer -k 7EE83BCF "zaproxy-$VERSION.deb"