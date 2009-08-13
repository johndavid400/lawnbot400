//read PPM signals from 2 channels of an RC reciever and convert the values to PWM in either direction.
// to test out, plug yellow led's for neutral (pins 12, 13), green for forward (pins 5, 9), and red for reverse (pins 6, 11).

int motor1_a = 5;    
int motor1_b = 6;    
int motor2_a = 9;
int motor2_b = 11;    

//Neutral indicator LED's (FWD and REV LED's are on the motor driver board.
int ledPin1 = 12;      
int ledPin2 = 13;

int PPMin1 = 2;  // connect the desired channel (PPM signal) from your RC receiver to digital pin 2 on Arduino. 
int PPMin2 = 3;

volatile int RCval1;  // store RC signal pulse length
int lastgood1;
int adj_val1;  // mapped value to be between 0-511

volatile int RCval2;  // store RC signal pulse length
int lastgood2;
int adj_val2;  // mapped value to be between 0-511

volatile int RC1PulseStartTicks;
int RC1InputReady;
int rcval1_prev;

volatile int RC2PulseStartTicks;
int RC2InputReady;
int rcval2_prev;

int deadband_high = 265; // set the desired deadband ceiling (ie. if adj_val is above this, you go forward)
int deadband_low = 245;  // set deadband floor (ie. below this, go backward)

void setup() {
  
  Serial.begin(9600);  

  // set all the other pins you're using as outputs:
  //motor1 pins
  pinMode(motor1_a, OUTPUT); 
  pinMode(motor1_b, OUTPUT); 
  pinMode(motor2_a, OUTPUT); 
  pinMode(motor2_b, OUTPUT); 

  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  
  //PPM inputs from RC receiver
  pinMode(PPMin1, INPUT); //Pin 2 as input
  pinMode(PPMin2, INPUT); //Pin 3 as input
    
  attachInterrupt(0, rc1, CHANGE);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  attachInterrupt(1, rc2, CHANGE);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()

  

}


void rc1()
{
  // did the pin change to high or low?
  if (digitalRead( PPMin1 ) == HIGH)
  {
    // store the current micros() value
    RC1PulseStartTicks = micros();    
  }
  else
  {
    // Pin transitioned low, calculate the duration of the pulse
    RCval1 = micros() - RC1PulseStartTicks; // may glitch during timer wrap-around
    // Set flag for main loop to process the pulse
    RC1InputReady = true;
  }
}

void rc2()
{
  // did the pin change to high or low?
  if (digitalRead( PPMin2 ) == HIGH)
  {
    // store the current micros() value
    RC2PulseStartTicks = micros();    
  }
  else
  {
    // Pin transitioned low, calculate the duration of the pulse
    RCval2 = micros() - RC2PulseStartTicks; // may glitch during timer wrap-around
    // Set flag for main loop to process the pulse
    RC2InputReady = true;
  }
}


void loop() {
  
//////////////////////////////////signal1  
    if (RC1InputReady)
  {
    // reset input flag
    RC1InputReady = false;

    // constrain and map the pulse length
    adj_val1 = map(constrain(RCval1, 1000, 2000), 1000, 2000, 0, 511);
    
    if (adj_val1 == 0) {adj_val1 = lastgood1;} else {lastgood1 = adj_val1;}   
    if (adj_val1 == 511) {adj_val1 = lastgood1;} else {lastgood1 = adj_val1;}   
    // Update motor outputs.    
  
///////// MOTOR1 /////////

  if (adj_val1 > deadband_high) {  
    //Forward
    analogWrite(motor1_a, adj_val1 - deadband_high); //write adj_val1 to motor1
    digitalWrite(motor1_b, LOW);
    digitalWrite(ledPin1, LOW);
  } 
  else if (adj_val1 < deadband_low) {
    //REVERSE
    digitalWrite(motor1_a, LOW);    
    analogWrite(motor1_b, deadband_low - adj_val1); //write adj_val1 to motor1
    digitalWrite(ledPin1, LOW);
  }
  else {
  //STOP
  digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, LOW);
 }

}

//////////////////////////////////signal2  
    if (RC2InputReady)
  {
    // reset input flag
    RC2InputReady = false;

    // constrain and map the pulse length
    adj_val2 = map(constrain(RCval2, 1000, 2000), 1000, 2000, 0, 511);

    if (adj_val2 == 0) {adj_val2 = lastgood2;} else {lastgood2 = adj_val2;}   
    if (adj_val2 == 511) {adj_val2 = lastgood2;} else {lastgood2 = adj_val2;} 

    // Update motor outputs.    
  
///////// MOTOR2 /////////
 
  if (adj_val2 > deadband_high) {  
    //Forward
    analogWrite(motor2_a, adj_val2 - deadband_high); //write adj_val1 to motor1
    digitalWrite(motor2_b, LOW);
    digitalWrite(ledPin2, LOW);
  } 
  else if (adj_val2 < deadband_low) {
    //REVERSE
    digitalWrite(motor2_a, LOW);    
    analogWrite(motor2_b, deadband_low - adj_val2); //write adj_val1 to motor1
    digitalWrite(ledPin2, LOW);
  }
  else {
  //STOP
  digitalWrite(ledPin2, HIGH); // turn on neutral light, turn motor pins off
  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, LOW);
 }

}

  //print values
  Serial.print("channel 1:  ");
  Serial.print(adj_val1);
  Serial.print("        ");  
  Serial.print("RCval1 raw:  ");
  Serial.print(RCval1);  
  Serial.print("        ");
  Serial.print("channel 2:  ");   
  Serial.print(adj_val2);
  Serial.print("        ");
  Serial.print("RCval2 raw:  ");
  Serial.print(RCval2);  
  Serial.println("        ");

}

