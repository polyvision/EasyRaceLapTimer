![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# complete setup guide

You need a working internet connection for setting up the system from scratch. If you want, you
can also use the provided images for EasyRaceLapTimer, so you need to setup nothing and can start
right away.

## basic

download and install a Raspian Jessie on a 8GB (or more) micro SD card

increase the size of your SD card and reboot

    sudo raspi-config

get the code

    cd ~
    git clone https://github.com/polyvision/EasyRaceLapTimer.git

## ir_daemon

    cd ~/EasyRaceLapTimer/ir_daemon
    sudo apt-get install  qt5-default libcurl4-openssl-dev
    qmake ir_daemon.pro
    make

## the Ruby on Rails webservice

   cd ~/EasyRaceLapTimer/web/
   sudo apt-get install ruby2.1-dev libssl-dev apache2 apache2-threaded-dev libapr1-dev redis-server libaprutil1-dev imagemagick libsqlite3-dev
   sudo gem install bundler
   bundle config build.nokogiri --use-system-libraries
   sudo  gem install nokogiri -v "1.6.6.2"
   bundle
   RAILS_ENV=production rake db:create
   RAILS_ENV=production rake db:migrate
   RAILS_ENV=production rake db:seed
   RAILS_ENV=production rake assets:precompile
   sudo gem install passenger
   sudo passenger-install-apache2-module

## the configuration

  cd ~/EasyRaceLapTimer
