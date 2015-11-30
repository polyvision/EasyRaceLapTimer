![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

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
