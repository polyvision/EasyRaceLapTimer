// COM 6
#include <IRremote.h>
#include <IRremoteInt.h>

IRsend irsend;

unsigned int buffer[7];

#define ZERO 320
#define ONE  850
#define SPACE 30

void setup() {
  pinMode(13, OUTPUT);
  
  // put your setup code here, to run once:
  buffer[0] = ZERO;
  buffer[1] = ZERO;
  buffer[2] = ONE;
  buffer[3] = ONE;
  buffer[4] = ONE;
  buffer[5] = ZERO;
  buffer[6] = ONE;
}

void loop() {
   for(int i = 0; i < 3; i++){
    irsend.sendRaw(buffer,7,38);
    digitalWrite(13, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(20);
    digitalWrite(13, LOW);    // turn the LED off by making the voltage LOW
   }
}
