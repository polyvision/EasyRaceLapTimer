/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * Author: Alexander B. Bierbrauer
 *
 * This file is part of EasyRaceLapTimer.
 * 
 * Vresion: 0.2
 *
 * EasyRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * EasyRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/
// use 8MHZ internal clock of the Attiny
// Timer code from http://forum.arduino.cc/index.php?topic=139729.0


#define BIT_SET(a,b) ((a) |= (1<<(b)))
#define BIT_CLEAR(a,b) ((a) &= ~(1<<(b)))
#define BIT_FLIP(a,b) ((a) ^= (1<<(b)))
#define BIT_CHECK(a,b) ((a) & (1<<(b)))

// CHANGE HERE THE ID OF TRANSPONDER 
// possible values are 1 to 63 
#define TRANSPONDER_ID 24




#define NUM_BITS  9
#define ZERO 250
#define ONE  650

unsigned int buffer[NUM_BITS];
unsigned int num_one_pulses = 0;

unsigned int get_pulse_width_for_buffer(int bit){
  if(BIT_CHECK(TRANSPONDER_ID,bit)){
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
  DDRB =  0b00000010;    // set PB1 (= OCR1A) to be an output

  setFrequency(38000); // 38 kHz

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
} // end of main loop
