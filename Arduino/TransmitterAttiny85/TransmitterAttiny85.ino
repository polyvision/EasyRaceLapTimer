#define LED_PIN PB0
#define BIT_SET(a,b) ((a) |= (1<<(b)))
#define BIT_CLEAR(a,b) ((a) &= ~(1<<(b)))
#define BIT_FLIP(a,b) ((a) ^= (1<<(b)))
#define BIT_CHECK(a,b) ((a) & (1<<(b)))


#define NUM_BITS  7
#define TRANSPONDER_ID 15
#define ZERO 300
#define ONE  600

unsigned int buffer[NUM_BITS];

void send_pulse(long microsecs) {
 
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

void send_space(long microsecs){
  while (microsecs > 0) { // 38 kHz is about 13 microseconds high and 13 microseconds low
    delayMicroseconds(26);
   // so 26 microseconds altogether
   microsecs -= 26;
  }
}

unsigned int get_pulse_width_for_buffer(int bit){
  if(BIT_CHECK(TRANSPONDER_ID,bit)){
    return ONE;
  }

  return ZERO;
}

unsigned int control_bit(){
  if(TRANSPONDER_ID % 2 >= 1){
    return ONE;  
  }else{
    return ZERO;
  }
}

void setup() {
  pinMode(TRANSPONDER_ID,OUTPUT);
  
  /*buffer[0] = ZERO;    
  buffer[1] = ZERO;    
  buffer[2] = get_pulse_width_for_buffer(3);
  buffer[3] = get_pulse_width_for_buffer(2);
  buffer[4] = get_pulse_width_for_buffer(1);
  buffer[5] = get_pulse_width_for_buffer(0);
  buffer[6] = control_bit();  **/

  for(int i = 0; i < NUM_BITS; i++){
    buffer[i] = ONE;
  }
}

void loop() {
   for(int i = 0; i < 3; i++){
    for(int i = 0; i < NUM_BITS; i++){
      if(buffer[i] % 2 == 0){
        send_pulse(buffer[i]);
      }else{
        send_space(buffer[i]);
      }
    }
   }
   delay(100);
}


