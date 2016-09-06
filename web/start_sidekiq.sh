#!/bin/bash
export RBENV_ROOT="/home/pi/.rbenv"

export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

cd /home/pi/EasyRaceLapTimer/web
RAILS_ENV=production sidekiq -c 1
