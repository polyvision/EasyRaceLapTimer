// COM 7
#include <IRremote.h>

int RECV_PIN = 11;
IRrecv irrecv(RECV_PIN);
decode_results results;

#define ZERO 320
#define ONE  850

#define TOLERANCE 200

#define BIT_SET(a,b) ((a) |= (1<<(b)))
#define BIT_CLEAR(a,b) ((a) &= ~(1<<(b)))
#define BIT_FLIP(a,b) ((a) ^= (1<<(b)))
#define BIT_CHECK(a,b) ((a) & (1<<(b)))

void setup(){
  irrecv.enableIRIn(); // Start the receiver
  Serial.begin(9600);
  Serial.println("started");
}

void loop(){
  if (irrecv.decode(&results)) {
    Serial.print("got data: ");
    Serial.print(results.rawlen-1,DEC);
    Serial.println(" bits");
    
    int codeType = results.decode_type;
    unsigned char received_value = 0;
    unsigned int set_bits = 0;
    for(int i = 1; i <= results.rawlen -1; i++){
      unsigned int signal_length = results.rawbuf[i]*USECPERTICK;
      
      Serial.print(i);
      Serial.print(":");
      Serial.print(signal_length,DEC);

      if(set_bits < 6){
        if(signal_length > (ONE - TOLERANCE)){ // ONE
          BIT_SET(received_value,6 - i);
          Serial.println(" ONE");
        }else{ // ZERO
          BIT_CLEAR(received_value,6-i);
          Serial.println(" ZERO");
        }
        set_bits++;
      }else{
        Serial.println("");
      }
    }
    Serial.print("value: ");
    Serial.println(received_value,DEC);
      
    irrecv.resume(); // resume receiver
  }
}

