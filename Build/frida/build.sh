#!/bin/bash
#xpm  -s python -t deb --deb-sign 7EE83BCF -m "Anant Shrivastava <anant@anantshri.info>" --vendor AndroidTamer "$@"
build_pip frida
build_pip prompt-toolkit
build_pip six
build_pip wcwidth
find ./ -name '*.deb' -maxdepth 1 -mtime -1 -exec dpkg-sig --sign builder -k 7EE83BCF "{}" \;
