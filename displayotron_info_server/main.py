import socket
import sys
import dothat.backlight as backlight
import dothat.lcd as lcd
import dothat.touch as j
import time
import math
import signal

TCP_IP = '127.0.0.1'
TCP_PORT = 3007
BUFFER_SIZE = 1024
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))



backlight.graph_off()
backlight.graph_set_led_duty(0, 1)
lcd.clear()
lcd.set_cursor_position(0, 0)
lcd.write("EasyRaceLapTimer")


@j.on(j.UP)
def handle_up(ch, evt):
    print("Up pressed!")
    lcd.clear()
    backlight.rgb(255, 0, 0)
    lcd.write("Up up and away!")


@j.on(j.DOWN)
def handle_down(ch, evt):
    print("Down pressed!")
    lcd.clear()
    backlight.rgb(0, 255, 0)
    lcd.write("Down down doobie down!")


@j.on(j.LEFT)
def handle_left(ch, evt):
    print("Left pressed!")
    lcd.clear()
    backlight.rgb(0, 0, 255)
    lcd.write("Leftie left left!")


@j.on(j.RIGHT)
def handle_right(ch, evt):
    print("Right pressed!")
    lcd.clear()
    backlight.rgb(0, 255, 255)
    lcd.write("Rightie tighty!")


@j.on(j.BUTTON)
def handle_button(ch, evt):
    print("Button pressed!")
    lcd.clear()
    backlight.rgb(255, 255, 255)
    lcd.write("Ouch!")


@j.on(j.CANCEL)
def handle_cancel(ch, evt):
    print("Cancel pressed!")
    lcd.clear()
    backlight.rgb(0, 0, 0)
    lcd.write("Boom!")



while True:
    data = s.recv(BUFFER_SIZE)
    
    if str.find(data,"#") != -1:
        data = data.replace("#","").replace("\n","")
        list= data.split(" ",5)
        if list[0] == "NEW_LAP_TIME":
            lcd.set_cursor_position(0, 1)
            lcd.write(list[1]+ " " + str(float(list[2]) / 1000)+"secs")
