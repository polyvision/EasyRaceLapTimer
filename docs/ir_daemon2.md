![alt text](http://www.easyracelaptimer.com/wp-content/uploads/2016/01/easy_race_lap_timer_logo-1.png "EasyRaceLapTimer")

# IR_DAEMON2

The ir_daemon2 is a complete nodejs rewrite of the C++ daemon.

Supported devices:

* PocketEditions, up to 8: check vtx_sensor.md in the docs for GPIO reference
* RaceBox, connector PDB for connection PocketEdition and other VTX sensors
* ERLT infrared transponders (currently in the works)

## installation

    cd ~/EasyRaceLapTimer/ir_daemon2

    curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
    sudo apt-get install -y nodejs

    npm install

    sudo cp /home/pi/EasyRaceLapTimer/config_files/ir_daemon2.json /etc/


# starting the daemon

it's recommended to use the "screen" app to run the daemon. If the cmd isn't available install it via

    sudo apt-get install screen


starting

    screen
    sudo node app.js

# available cmds

listing all ports for the race box

    sudo node app.js list_race_box_ports

setting the com port for the race box

    sudo node app.js set_race_box_port <PORT>

enable racebox mode

    sudo node app.js enable_race_box

disable racebox mode

    sudo node app.js disable_race_box