![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# Complete Setup Guide

This guide will walk you through manually setting up the software on your Raspberry Pi. You will
need to have your Pi connected to the internet to perform these steps.

As an alternative, you can use the provided Raspbian disk image file if you have the exact same
hardware as described in the hardware setup doc and just want to get started right away. But if you want
to know how to build the software up from scratch, this guide is for you!

## Preparing your Raspberry Pi

Before you begin, you should download and install a Raspian Jessie image onto an 8GB (or more) micro SD card.
For more information about setting up your Pi, see https://www.raspberrypi.org/help/quick-start-guide/.

The next thing is to ensure that you are using all of your SD card. Execute the following command:

    sudo raspi-config

and choose "Expand Filesystem".

If you used NOOBS to install Raspbian, you can probably skip this step, but if you're unsure, try it anyway
and it will tell you if there is nothing to do.

While you are in raspi-config, you might also want to change whether the Pi boots to a desktop (GUI) or to
the command line. Since the system runs "headless", not running the full GUI can free up resources. If you're
unsure, leave it set to the default.

## Get the Code

On the Pi, execute the following commands to pull the source from this GitHub repository:

    cd ~
    git clone https://github.com/polyvision/EasyRaceLapTimer.git

## Build the IR Daemon

The IR Daemon listens for the signals coming from the IR detectors and sends them to the Rails app via
a web API.

To build it, perform the following steps:

    cd ~/EasyRaceLapTimer/ir_daemon
    sudo apt-get install  qt5-default libcurl4-openssl-dev libudev-dev
    qmake ir_daemon.pro
    make
    sudo ./ir_daemon --use_standard_gpio_sensor_pins

## Build the Rails App

This is the main system app, and it provides the web UI & API.

To build it, perform the following steps (note: some of these steps will take a while to run, so be patient):

    cd ~/EasyRaceLapTimer/web/
    sudo apt-get update
    sudo apt-get install ruby2.1-dev libssl-dev apache2 apache2-threaded-dev libapr1-dev redis-server libaprutil1-dev imagemagick libsqlite3-dev bridge-utils wkhtmltopdf hostapd dnsmasq
    sudo gem install bundler
    bundle config build.nokogiri --use-system-libraries
    sudo  gem install nokogiri -v "1.6.6.2"
    bundle
    RAILS_ENV=production rake db:create db:migrate db:seed assets:precompile
    sudo gem install passenger
    sudo passenger-install-apache2-module

## Configure Apache Webserver

First you need to setup the new site in Apache:

    cd ~/EasyRaceLapTimer
    sudo cp config_files/000-default.conf /etc/apache2/sites-available/000-default.conf

Then, open /etc/apache2/apache2.conf using this command:

    sudo nano /etc/apache2/apache2.conf

In that file, find the following lines:

    # Include module configuration:
    IncludeOptional mods-enabled/*.load
    IncludeOptional mods-enabled/*.conf

and paste the following just before them

    LoadModule passenger_module /var/lib/gems/2.1.0/gems/passenger-5.0.21/buildout/apache2/mod_passenger.so
    <IfModule mod_passenger.c>
      PassengerRoot /var/lib/gems/2.1.0/gems/passenger-5.0.21
      PassengerDefaultRuby /usr/bin/ruby2.1
    </IfModule>

## Configure Linux Networking

The easiest way to setup the network is to use the provided interfaces file:

    sudo cp config_files/network_interfaces /etc/network/interfaces

But if you know linux networking, you might want to just compare the existing file with
the provided one and setup the network accordingly.

## Configure the Wireless Hotspot

If you are using the recommended EDIMAX WiFi adapter, you should skip to the section "Configuring
the EDIMAX WiFi Adapter".

If you are using another WiFi interface with your Pi, you should look at the following articles
to learn how to configure your interface for AP mode.

* http://jacobsalmela.com/raspberry-pi-and-routing-turning-a-pi-into-a-router/
* http://elinux.org/RPI-Wireless-Hotspot

You will then want to adapt the instructions below for your adapter.

### Configuring the EDIMAX WiFi Adapter

Source: http://www.daveconroy.com/turn-your-raspberry-pi-into-a-wifi-hotspot-with-edimax-nano-usb-ew-7811un-rtl8188cus-chipset/

First you need to get the updated driver for the RTL8188CUS chipset used in this interface:

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

Then reboot your Pi:

    sudo reboot

After rebooting, you can test your configuration using the following command:

    sudo hostapd -dd /etc/hostapd/hostapd.conf

If it runs as expected, add it to your system startup:

    sudo nano /etc/default/hostapd

Then uncomment and update the following line:

    DAEMON_CONF="/etc/hostapd/hostapd.conf"

Next you will configure the DNS & DHCP settings:

    sudo nano /etc/dnsmasq.conf

Find the line that begins with "#interface" and edit it as follows:

    interface=wlan0

In the same file, find the line that begins with "#dhcp-range" and edit it as follows:

    dhcp-range=192.168.42.2,192.168.42.100,255.255.255.0,12h    

Save and close the file.

## Configure the IR Daemon to launch at startup

Edit the following file:

    sudo nano /etc/rc.local

Then add the following to the bottom of the file, just before "exit":

    _IR_DAEMON=$(/home/pi/EasyRaceLapTimer/ir_daemon/ir_daemon &)

*You are done!*
