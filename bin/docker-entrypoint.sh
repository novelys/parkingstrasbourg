#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

export PATH=/opt/node/bin:$PATH

USER_UID=$(ls -ld | awk '{print $3}')
if echo $USER_UID | grep -Eo -q "^[0-9]+$" ; then
  if cat /etc/passwd | grep -v -q $USER_UID ; then
    useradd --shell /bin/bash -m --user-group --uid $USER_UID app
  fi
  USER_UID=$(id -u -n $USER_UID)
fi

if [ "$1" = "sudo" ] ; then
  exec $@
fi

SUDO="sudo -E -H -u $USER_UID PATH=$PATH"

if [ ! -d vendor/.bundle -a -e Gemfile ] ; then
  echo "Initializing ruby dependencies"
  $SUDO bundle install
fi

exec $SUDO $@
