![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# EasyRaceLapTimer web application

this setup is based on Raspian JESSIE

## install requirements

switch to the **web** folder in your EasyRaceLapTimer folder

    sudo apt-get install ruby2.1-dev libssl-dev apache2 apache2-threaded-dev libapr1-dev redis-server libaprutil1-dev  imagemagick
    sudo gem install bundler
    bundle config build.nokogiri --use-system-libraries
    sudo  gem install nokogiri -v "1.6.6.2"
    bundle
    sudo gem install passenger
    sudo passenger-install-apache2-module
    RAILS_ENV=production rake db:create
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production rake db:seed
    RAILS_ENV=production rake assets:precompile

## Apache setup

copy this code

    LoadModule passenger_module /var/lib/gems/2.1.0/gems/passenger-5.0.21/buildout/apache2/mod_passenger.so
    <IfModule mod_passenger.c>
      PassengerRoot /var/lib/gems/2.1.0/gems/passenger-5.0.21
      PassengerDefaultRuby /usr/bin/ruby2.1
    </IfModule>

and add it to the apache2 config via

    sudo nano /etc/apache2/apache2.conf

place the code near the following lines in the file

    # Include module configuration:
    IncludeOptional mods-enabled/*.load
    IncludeOptional mods-enabled/*.conf

## Rails Webapp setup

    rake db:create
    rake db:migrate
    rake db:seed

default credentials are:

    user: admin@easyracelaptimer.com
    password: defaultpw


## Rails Webapp development
for running rails in dev mode, you need to run these two commands in seperate processes (e.g. terminal windows). The app uses sqlite for it's database

    ./bin/cable
    rails s

## API

be sure to change **localhost:3000** to the correct ip of the host station

**tracking a lap**

    POST http://localhost:3000/api/v1/lap_track

or

    GET http://localhost:3000/api/v1/lap_track/create

**starting a new race**

    GET http://localhost:3000/api/v1/race_session/new

**getting data of the current race session**

    GET http://localhost:3000/api/v1/monitor

needed params
 * transponder_token
 * lap_time_in_ms
