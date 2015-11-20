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
     sudo apt-get update
     sudo apt-get install ruby2.1-dev libssl-dev apache2 apache2-threaded-dev libapr1-dev redis-server libaprutil1-dev imagemagick libsqlite3-dev bridge-utils hostapd
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
    sudo cp config_files/000-default.conf /etc/apache2/sites-available/000-default.conf

paste the following

     LoadModule passenger_module /var/lib/gems/2.1.0/gems/passenger-5.0.21/buildout/apache2/mod_passenger.so
    <IfModule mod_passenger.c>
      PassengerRoot /var/lib/gems/2.1.0/gems/passenger-5.0.21
      PassengerDefaultRuby /usr/bin/ruby2.1
    </IfModule>

into /etc/apache2/apache2.conf near the lines


    # Include module configuration:
    IncludeOptional mods-enabled/*.load
    IncludeOptional mods-enabled/*.conf

edit command for the apache2.conf file

    sudo nano /etc/apache2/apache2.conf

now the network configuration

    sudo cp config_files/network_interfaces /etc/network/interfaces

setting up the wifi access point.
this part comes from http://www.daveconroy.com/turn-your-raspberry-pi-into-a-wifi-hotspot-with-edimax-nano-usb-ew-7811un-rtl8188cus-chipset/

    cd ~
    wget http://www.daveconroy.com/wp3/wp-content/uploads/2013/07/hostapd.zip
    unzip hostapd.zip
    sudo mv /usr/sbin/hostapd /usr/sbin/hostapd.bak
    sudo mv hostapd /usr/sbin/hostapd.edimax
    sudo ln -sf /usr/sbin/hostapd.edimax /usr/sbin/hostapd
    sudo chown root.root /usr/sbin/hostapd
    sudo chmod 755 /usr/sbin/hostapd
    cd ~/EasyRaceLapTimer
    sudo cp config_files/hostapd.conf /etc/hostapd/

copy the following in the last line before "exit"

    _IR_DAEMON=$(/home/pi/EasyRaceLapTimer/ir_daemon/ir_daemon &)
