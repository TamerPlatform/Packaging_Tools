#!/bin/bash
build_pip gdbgui
build_pip pygdbmi
build_pip enum-compat
build_pip eventlet
build_pip flask-socketio
build_pip gevent
build_pip greenlet
build_pip pypugjs
build_pip python-engineio
build_pip python-socketio
find ./ -name '*.deb' -maxdepth 1 -mtime -1 -exec dpkg-sig --sign builder -k 7EE83BCF "{}" \;