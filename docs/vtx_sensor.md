![alt text](http://www.easyracelaptimer.com/wp-content/uploads/2016/01/easy_race_lap_timer_logo-1.png "EasyRaceLapTimer")

# VTX Sensoring

In order to enable & use VTX sensoring you need an EasyRaceLapTimer PocketEdition or compatible device.

## enabling VTX sensoring

    cd /home/pi/EasyRaceLapTimer/ir_daemon
    sudo ./ir_daemon --enable_vtx_sensoring

## disabling VTX sensoring

    cd /home/pi/EasyRaceLapTimer/ir_daemon
    sudo ./ir_daemon --disable_vtx_sensoring


## GPIO Pins on a PI 2

    VTX_SENSOR_PIN_1 GPIO-PIN: 25
    VTX_SENSOR_PIN_2 GPIO-PIN: 24
    VTX_SENSOR_PIN_3 GPIO-PIN: 23
    VTX_SENSOR_PIN_4 GPIO-PIN: 22
    VTX_SENSOR_PIN_5 GPIO-PIN: 21
    VTX_SENSOR_PIN_6 GPIO-PIN: 3
    VTX_SENSOR_PIN_7 GPIO-PIN: 2
    VTX_SENSOR_PIN_8 GPIO-PIN: 0

## How to configure the host system

Assign a pilot the token **VTX_1** and he will be using the first VTX sensor. If you assign a pilot the token **VTX_3**, he will be using the third one.
