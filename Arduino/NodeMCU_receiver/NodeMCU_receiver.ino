//#include <ESP8266WiFi.h>
#include "gpioreader.h"

GPIOReader gpioReader;
 
void setup() {
  delay(10);
  Serial.begin(115200);
  gpioReader.setSensor(0,D4);
  gpioReader.setDebug(true);
}
 
void loop() {
  gpioReader.update();
}
