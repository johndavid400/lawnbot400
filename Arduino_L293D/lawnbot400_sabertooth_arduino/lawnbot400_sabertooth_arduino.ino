// This code is intended for use on a new Arduino control board that has an L293D onboard to control the peripheral relays.

int tog = 2; // toggle switch
int aux = 4; // trainer switch

int tog_raw;
int aux_raw;

boolean tog_val = false;
boolean aux_val = false;

// L293D inputs
int out1 = 8;
int enable_12 = 9;
int out2 = 10;
int out3 = 12;
int enable_34 = 11;
int out4 = 13;

int cutoff = 1650;

void setup(){

  Serial.begin(9600);
  
  pinMode(tog, INPUT);
  pinMode(aux, INPUT);

  pinMode(out1, OUTPUT);
  pinMode(enable_12, OUTPUT);
  pinMode(out2, OUTPUT);
  pinMode(out3, OUTPUT);
  pinMode(enable_34, OUTPUT);
  pinMode(out4, OUTPUT);

  digitalWrite(out1, LOW);
  digitalWrite(enable_12, LOW);
  digitalWrite(out2, LOW);
  digitalWrite(out3, LOW);
  digitalWrite(enable_34, LOW);
  digitalWrite(out4, LOW);
  
  delay(100);
  
  digitalWrite(enable_12, HIGH);
  digitalWrite(enable_34, HIGH);
 
}

void loop(){
  // do stuff
  read_radio_signals();
  check_signals();
  write_relay_values();
  //serial_print_stuff();
}

void write_relay_values(){
  if (tog_val == true){
    digitalWrite(out1, HIGH);
  }
  else {
    digitalWrite(out1, LOW);
  }

  if (aux_val == true){
    digitalWrite(out2, HIGH);
  }
  else {
    digitalWrite(out2, LOW);
  } 
}

void read_radio_signals(){
    //thr_raw = pulseIn(thr, HIGH, 20000);
    //ail_raw = pulseIn(ail, HIGH, 20000);
    //ele_raw = pulseIn(ele, HIGH, 20000);
    //rud_raw = pulseIn(rud, HIGH, 20000);
    tog_raw = pulseIn(tog, HIGH, 20000);
    aux_raw = pulseIn(aux, HIGH, 20000);
}

void check_signals(){

  /*
  if (ail_raw > cutoff){
    ail_val = true;
  }
  else {
    ail_val = false;
  }

  if (rud_raw > cutoff){
    rud_val = true;
  }
  else {
    rud_val = false;
  }
  */

  if (tog_raw > cutoff){
    tog_val = true;
  }
  else {
    tog_val = false;
  }

  if (aux_raw > cutoff){
    aux_val = true;
  }
  else {
    aux_val = false;
  }
}

void serial_print_stuff(){

Serial.print("  tog: ");
Serial.print(tog_val);

Serial.print("  aux: ");
Serial.println(aux_val);

}


