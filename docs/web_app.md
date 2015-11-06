![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# EasyRaceLapTimer web application

this setup is based on Raspian JESSIE

## install requirements

switch to the **web** folder in your EasyRaceLapTimer folder

    sudo apt-get install ruby2.1-dev
    sudo gem install bundler
    bundle config build.nokogiri --use-system-libraries
    sudo  gem install nokogiri
    bundle

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

**tracking a lap**

    POST http://localhost:3000/api/v1/lap_track

or

    GET http://localhost:3000/api/v1/lap_track/create

needed params
 * transponder_token
 * lap_time_in_ms
