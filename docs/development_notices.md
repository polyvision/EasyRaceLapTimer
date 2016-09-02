![alt text](http://www.easyracelaptimer.com/wp-content/uploads/2016/01/easy_race_lap_timer_logo-1.png "EasyRaceLapTimer")

# Version 0.6

Until we provide installation instructions and an PI image, both the web server and the ir_daemon2 must be run in a
screen session.

A quick notice for screen. When you start a screen session, you can detach from it via pressing *CTRL+A+D*. Reattaching 
works via *screen -x*.

## ir_daemon2

    cd ~/EasyRaceLapTimer/ir_daemon2
    screen
    sudo node app.js

## web server

    cd ~/EasyRaceLapTimer/web
    rails s -p 8080 -b 0.0.0.0