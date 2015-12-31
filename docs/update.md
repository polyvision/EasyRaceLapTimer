![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

Instructions for updating to the next stable version. After updating the system, you need to restart the Raspberry PI.

# updating from v0.3 to v0.4

    cd ~/EasyRaceLapTimer
    git pull origin master

    cd ~/EasyRaceLapTimer/ir_daemon
    qmake ir_daemon.pro
    make
    sudo ./ir_daemon --use_standard_gpio_sensor_pins (call this cmd after the update, this sets the standard pin layout for the sensors etc)

    cd ~/EasyRaceLapTimer/web
    bundle
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production rake assets:precompile

# updating to v0.3

    cd ~/EasyRaceLapTimer
    git pull origin master

    cd ~/EasyRaceLapTimer/ir_daemon
    sudo apt-get install libudev-dev
    qmake ir_daemon.pro
    make

    cd ~/EasyRaceLapTimer/web
    bundle
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production rake assets:precompile
