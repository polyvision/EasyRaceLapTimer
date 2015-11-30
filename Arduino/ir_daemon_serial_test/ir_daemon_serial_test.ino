void setup() {
  Serial.begin(115200);
}

// the loop routine runs over and over again forever:
void loop() {

  Serial.println("START_NEW_RACE#");
  delay(1000);
  Serial.println("LAP_TIME 16 10000#");
  delay(1000);
  Serial.println("RESET#");
  delay(1000);
  Serial.println("LAP_TIME 16 20000#");
  delay(1000);
}



