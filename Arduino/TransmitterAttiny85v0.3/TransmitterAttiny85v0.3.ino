/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * Author: Alexander B. Bierbrauer
 *
 * This file is part of EasyRaceLapTimer.
 * 
 * Vresion: 0.3
 *
 * EasyRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * EasyRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/
// use 8MHZ internal clock of the Attiny
// Timer code from http://forum.arduino.cc/index.php?topic=139729.0
#include <EEPROM.h>

#define BIT_SET(a,b) ((a) |= (1<<(b)))
#define BIT_CLEAR(a,b) ((a) &= ~(1<<(b)))
#define BIT_FLIP(a,b) ((a) ^= (1<<(b)))
#define BIT_CHECK(a,b) ((a) & (1<<(b)))

// CHANGE HERE THE ID OF TRANSPONDER 
// possible values are 1 to 63 
#define TRANSPONDER_ID 21

// DEFINITIONS FOR TRANSPONDERS WITH PUSH BUTTON CONFIGURATION
//#define CLEAR_EEPROM
#define ENABLE_BUTTON_CONFIGURATION
#define BUTTON_PIN PB2
#define STATUS_LED_PIN PB0
#define BUTTON_INC_ID_PUSH_TIME 750
#define LED_BLINK_CONFIRM_TIME 750
#define ENABLE_PROGRAMMING_MODE_TIME 8000 // 8 seconds

// DO NOT CHANGE ANYTHING BELOW
#define NUM_BITS  9
#define ZERO 250
#define ONE  650

unsigned int buffer[NUM_BITS];
unsigned int num_one_pulses = 0;
unsigned int transponder_id = TRANSPONDER_ID;
unsigned long buttonPushTime = 0;
int buttonState = 0;
unsigned long ledBlinkStartTime = 0;

void EEPROMWriteInt(int p_address, int p_value);
unsigned int EEPROMReadInt(int p_address);

void encodeIdToBuffer(){
  buffer[0] = ZERO;    
  buffer[1] = ZERO;    
  buffer[2] = get_pulse_width_for_buffer(5);
  buffer[3] = get_pulse_width_for_buffer(4);
  buffer[4] = get_pulse_width_for_buffer(3);
  buffer[5] = get_pulse_width_for_buffer(2);
  buffer[6] = get_pulse_width_for_buffer(1);
  buffer[7] = get_pulse_width_for_buffer(0);
  buffer[8] = control_bit(); 
}

void readConfigButtonState(){
  if(ledBlinkStartTime != 0){
    return;
  }
    
  int state = digitalRead(BUTTON_PIN);
  if(state == LOW){
    if(state != buttonState){
      buttonState = state;
      buttonPushTime = millis();
    }
  }else{
    buttonPushTime = millis();
  }

  buttonState = state;

  if(buttonPushTime + BUTTON_INC_ID_PUSH_TIME <= millis()){
    transponder_id += 1;
    if (transponder_id > 63){
      transponder_id = 1;
    }
    EEPROMWriteInt(0, transponder_id);
    
    buttonState = HIGH; // RESET
    buttonPushTime = millis(); // RESET
    ledBlinkStartTime = millis(); // Enable confirmation LED
    digitalWrite(STATUS_LED_PIN, HIGH);
    encodeIdToBuffer();
  }
}


void updateConfirmationLed(){
  if(ledBlinkStartTime != 0 && ledBlinkStartTime + LED_BLINK_CONFIRM_TIME <= millis()){
    digitalWrite(STATUS_LED_PIN, LOW);
    ledBlinkStartTime = 0;
  }
}

unsigned int get_pulse_width_for_buffer(int bit){
  if(BIT_CHECK(transponder_id,bit)){
    num_one_pulses += 1;
    return ONE;
  }

  return ZERO;
}

unsigned int control_bit(){
  if(num_one_pulses % 2 >= 1){
    return ONE;  
  }else{
    return ZERO;
  }
}

void setup()
{
  PORTB = 0;
#ifdef CLEAR_EEPROM
  for (int i = 0 ; i < EEPROM.length() ; i++) {
    EEPROM.write(i, 0);
  }
#endif

#ifdef ENABLE_BUTTON_CONFIGURATION
  transponder_id = EEPROMReadInt(0);
  if(transponder_id == 0){
    transponder_id = 1;
    EEPROMWriteInt(0, transponder_id);
  }
  
  // put your setup code here, to run once:
  pinMode(STATUS_LED_PIN, OUTPUT);
  // initialize the pushbutton pin as an input:
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  PORTB |= (1 << BUTTON_PIN);    // enable pull-up resistor

  for(int i=0; i < 3; i++){
    digitalWrite(STATUS_LED_PIN, HIGH);
    delay(250);
    digitalWrite(STATUS_LED_PIN, LOW);
    delay(250);
  }
#endif


  pinMode(PB1, OUTPUT);
  //DDRB =  0b00000010;    // set PB1 (= OCR1A) to be an output

  setFrequency(38000); // 38 kHz

  encodeIdToBuffer();
}

// Set the frequency that we will get on pin OCR1A but don't turn it on
void setFrequency(uint16_t freq)
{
 uint32_t requiredDivisor = (F_CPU/2)/(uint32_t)freq;

 uint16_t prescalerVal = 1;
 uint8_t prescalerBits = 1;
 while ((requiredDivisor + prescalerVal/2)/prescalerVal > 256)
 {
   ++prescalerBits;
   prescalerVal <<= 1;
 }
 
 uint8_t top = ((requiredDivisor + (prescalerVal/2))/prescalerVal) - 1;
 TCCR1 = (1 << CTC1) | prescalerBits;
 GTCCR = 0;
 OCR1C = top;
}

// Turn the frequency on
void ir_pulse_on()
{
 TCNT1 = 0;
 TCCR1 |= (1 << COM1A0);
}

// Turn the frequency off and turn off the IR LED.
// We let the counter continue running, we just turn off the OCR1A pin.
void ir_pulse_off()
{
 TCCR1 &= ~(1 << COM1A0);
}

void loop(){
  for(int i = 0; i < 3; i++){
    for(int b = 0; b < NUM_BITS; b++){
      switch(b){
        case 0:
          ir_pulse_on();
          delayMicroseconds(buffer[b]);
          break;
        case 1:
          ir_pulse_off();
          delayMicroseconds(buffer[b]);
          break;
        case 2:
          ir_pulse_on();
          delayMicroseconds(buffer[b]);
          break;
        case 3:
          ir_pulse_off();
          delayMicroseconds(buffer[b]);
          break;
        case 4:
          ir_pulse_on();
          delayMicroseconds(buffer[b]);
          break;
        case 5:
          ir_pulse_off();
          delayMicroseconds(buffer[b]);
          break;
        case 6:
          ir_pulse_on();
          delayMicroseconds(buffer[b]);
          break;
        case 7:
          ir_pulse_off();
          delayMicroseconds(buffer[b]);
          break;
        case 8:
          ir_pulse_on();
          delayMicroseconds(buffer[b]);
          break;
      }
      ir_pulse_off();
    } // going through the buffer
    
    delay(20 + random(0, 5));
  } // 3 times

#ifdef ENABLE_BUTTON_CONFIGURATION
  readConfigButtonState();
  updateConfirmationLed();
#endif
} // end of main loop

void EEPROMWriteInt(int p_address, int p_value)
{
     byte lowByte = ((p_value >> 0) & 0xFF);
     byte highByte = ((p_value >> 8) & 0xFF);

     EEPROM.write(p_address, lowByte);
     EEPROM.write(p_address + 1, highByte);
}

unsigned int EEPROMReadInt(int p_address)
{
     byte lowByte = EEPROM.read(p_address);
     byte highByte = EEPROM.read(p_address + 1);

     return ((lowByte << 0) & 0xFF) + ((highByte << 8) & 0xFF00);
}
