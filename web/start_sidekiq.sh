#!/bin/bash
cd /home/pi/EasyRaceLapTimer/web
RAILS_ENV=production sidekiq -c 1
