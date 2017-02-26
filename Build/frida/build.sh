#!/bin/bash
#xpm  -s python -t deb --deb-sign 7EE83BCF -m "Anant Shrivastava <anant@anantshri.info>" --vendor AndroidTamer "$@"
build_pip frida
build_pip prompt-toolkit
build_pip six
build_pip wcwidth