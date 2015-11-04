// COM 6
#include <IRremote.h>
#include <IRremoteInt.h>

IRsend irsend;

#define BIT_SET(a,b) ((a) |= (1<<(b)))
#define BIT_CLEAR(a,b) ((a) &= ~(1<<(b)))
#define BIT_FLIP(a,b) ((a) ^= (1<<(b)))
#define BIT_CHECK(a,b) ((a) & (1<<(b)))


#define NUM_BITS  7
#define TRANSPONDER_ID 12
#define ZERO 300
#define ONE  600

unsigned int buffer[NUM_BITS];

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
  pinMode(13, OUTPUT);
  Serial.begin(9600);
  
  buffer[0] = ZERO;    
  buffer[1] = ZERO;    
  buffer[2] = get_pulse_width_for_buffer(3);
  buffer[3] = get_pulse_width_for_buffer(2);
  buffer[4] = get_pulse_width_for_buffer(1);
  buffer[5] = get_pulse_width_for_buffer(0);
  buffer[6] = control_bit();  
  

  for(int i= 0; i < NUM_BITS; i++){
    Serial.println(buffer[i],DEC);
  }
  Serial.println(TRANSPONDER_ID,BIN);
}

void loop() {
   for(int i = 0; i < 3; i++){
    irsend.sendRaw(buffer,NUM_BITS,38);
    digitalWrite(13, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(20);
    digitalWrite(13, LOW);    // turn the LED off by making the voltage LOW
   }
}
