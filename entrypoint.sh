#!/bin/bash

bundle install

rm -f tmp/pids/server.pid

bundle exec rails db:prepare

bundle exec rails s -p 3000 -b '0.0.0.0' -e development