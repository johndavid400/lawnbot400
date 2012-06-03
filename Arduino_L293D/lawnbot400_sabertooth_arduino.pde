// This code is intended for use on a new Arduino control board that has an L293D onboard to control the peripheral relays.

boolean config_pin2 = 2;
boolean config_pin4 = 4;

boolean all_rc = false;

int rc1 = 5; // aileron
int rc2 = 4; // elevator
int rc3 = 3; // throttle
int rc4 = 2; // rudder
int rc5 = 1; // toggle switch
int rc6 = 0; // trainer switch

int rc1_raw;
int rc2_raw;
int rc3_raw;
int rc4_raw;
int rc5_raw;
int rc6_raw;

boolean rc1_val = false;
boolean rc2_val = false;
boolean rc3_val = false;
boolean rc4_val = false;
boolean rc5_val = false;
boolean rc6_val = false;

// L293D inputs
int out1 = 8;
int enable_12 = 9;
int out2 = 10;
int out3 = 12;
int enable_34 = 11;
int out4 = 13;

void setup(){

  pinMode(config_pin2, INPUT);
  pinMode(config_pin4, INPUT);

  pinMode(rc1, INPUT);
  pinMode(rc2, INPUT);  // let the elevator channel connect directly to the Sabertooth
  pinMode(rc3, INPUT);  // let the throttle channel connect directly to the Sabertooth
  pinMode(rc4, INPUT);
  pinMode(rc5, INPUT);
  pinMode(rc6, INPUT);

  pinMode(out1, OUTPUT);
  pinMode(enable_12, OUTPUT);
  pinMode(out2, OUTPUT);
  pinMode(out3, OUTPUT);
  pinMode(enable_34, OUTPUT);
  pinMode(out4, OUTPUT);

  digitalWrite(enable_12, HIGH);
  digitalWrite(enable_34, HIGH);

  run_config();
}

void run_config(){
  if (digitalRead(config_pin2) == LOW){
    all_rc = true;
  }
  else {
    all_rc = false;
  }
}

void loop(){
  // do stuff
  read_radio_signals();

  if (rc5_val == true){
    digitalWrite(out1, HIGH);
  }
  else {
    digitalWrite(out1, LOW);
  }

  if (rc6_val == true){
    digitalWrite(out2, HIGH);
  }
  else {
    digitalWrite(out2, LOW);
  }

}

void read_radio_signals(){
//  rc2_raw = pulseIn(rc5, HIGH, 20000);
//  rc3_raw = pulseIn(rc5, HIGH, 20000);

  if (all_rc == true){
    rc1_raw = pulseIn(rc5, HIGH, 20000);
    rc4_raw = pulseIn(rc5, HIGH, 20000);
    rc5_raw = pulseIn(rc5, HIGH, 20000);
    rc6_raw = pulseIn(rc5, HIGH, 20000);
  }
  else {
    rc5_raw = pulseIn(rc5, HIGH, 20000);
    rc6_raw = pulseIn(rc5, HIGH, 20000);
  }

  if (rc1_raw > 1700){
    rc1_val = true;
  }
  else {
    rc1_val = false;
  }

  if (rc4_raw > 1700){
    rc4_val = true;
  }
  else {
    rc4_val = false;
  }

  if (rc5_raw > 1700){
    rc5_val = true;
  }
  else {
    rc5_val = false;
  }

  if (rc6_raw > 1700){
    rc6_val = true;
  }
  else {
    rc6_val = false;
  }

}




