#!/bin/bash


if [ -f /usr/local/share/chruby/chruby.sh ]; then
  source /usr/local/share/chruby/chruby.sh
fi
if [ -f /usr/local/share/chruby/auto.sh ]; then
  source /usr/local/share/chruby/auto.sh
fi


if [ -f tmp/pids/server.pid ]; then
  kill `cat tmp/pids/server.pid`
fi

RAILS_ENV=alpha bin/rails s
