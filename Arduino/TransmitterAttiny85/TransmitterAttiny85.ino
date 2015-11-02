
#define ZERO          160
#define ONE           425
#define SPACE         270
#define SIGNAL_SPACE   20

#define LED_PIN PB0


void setup() {
  pinMode(LED_PIN,OUTPUT);
}

void pulseIR(long microsecs) {
 
  cli(); 

  while (microsecs > 0) { // 38 kHz is about 13 microseconds high and 13 microseconds low
   digitalWrite(LED_PIN, HIGH);  // this takes about 3 microseconds to happen
   delayMicroseconds(10);         // hang out for 10 microseconds
   digitalWrite(LED_PIN, LOW);   // this also takes about 3 microseconds
   delayMicroseconds(10);         // hang out for 10 microseconds

   // so 26 microseconds altogether
   microsecs -= 26;
  }
  sei();  // this turns them back on
}

void send_zero(){
  pulseIR(ZERO);
}

void send_one(){
  pulseIR(ONE);
}

void loop()
{
  // startbits
  //send_zero();
  //send_one();
  for(int i =0; i < 3; i++){
    pulseIR(1000);
    pulseIR(500);
  }
  delay(100);
}


