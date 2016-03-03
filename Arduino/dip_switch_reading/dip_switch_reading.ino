#define BIT_SET(a,b) ((a) |= (1<<(b)))
#define BIT_CLEAR(a,b) ((a) &= ~(1<<(b)))
#define BIT_FLIP(a,b) ((a) ^= (1<<(b)))
#define BIT_CHECK(a,b) ((a) & (1<<(b)))

int dipPins[] = {2,3,4,5,6,7}; //DIP Switch Pins
#define NUM_DIP_SWITCH_PINS 6

unsigned int transponder_id = 0;

void setup_transponder_id_dip_switch(){
   

   for(int i = 0; i < NUM_DIP_SWITCH_PINS; i++){
    pinMode(dipPins[i], INPUT_PULLUP);      // sets the digital pin 2-5 as input
    digitalWrite(dipPins[i], HIGH); //Set pullup resistor on
   }
}

void read_transpoder_id_by_dip_switch(){
  for(int i = 0; i < NUM_DIP_SWITCH_PINS ; i++){
    if(digitalRead(dipPins[i]) == LOW){
      Serial.print("PIN ");
      Serial.print(i);
      Serial.print(" SWITCH ");
      Serial.print(i+1);
      Serial.println(" ON");
      BIT_SET(transponder_id,i);
    }else{
      BIT_CLEAR(transponder_id,i);
    }
  }
  

   Serial.print("transponder id: ");
   Serial.println(transponder_id);
   // we don't allow a transponder of 0
   if(transponder_id == 0){
    transponder_id = 1;
   }
}

void setup() {
  Serial.begin(9600);
  setup_transponder_id_dip_switch();
}

void loop() {
  // put your main code here, to run repeatedly:
  read_transpoder_id_by_dip_switch();
  delay(1000);
}
