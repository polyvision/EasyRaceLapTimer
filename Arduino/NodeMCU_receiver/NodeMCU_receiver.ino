#include <ESP8266WiFi.h>
#include "gpioreader.h"

GPIOReader gpioReader(3);
 
void setup() {
 gpioReader.setSensor(0,D1);
}
 
void loop() {
  gpioReader.update();
}
