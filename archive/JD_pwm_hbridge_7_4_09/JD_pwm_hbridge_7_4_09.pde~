
//4 wire control, high side mosfets are switched on/off, low side mosfets are PWM'd. 4 npn transistors switch the high/low mosfets.

#include <avr/interrupt.h>

//motor1 control pins
int motor1_p1 = 4;    // High side left
int motor1_n1 = 5;    // Low side left PWM
int motor1_p2 = 7;    // High side right
int motor1_n2 = 6;    // Low side right PWM

//motor2 control pins
int motor2_p1 = 8;    // High side left
int motor2_n1 = 9;    // Low side left PWM
int motor2_p2 = 11;    // High side right
int motor2_n2 = 10;    // Low side right PWM
//Neutral indicator LED's (FWD and REV LED's are on the motor driver board.
int ledPin1 = 12;      // LED1 
int ledPin2 = 13;      // LED2

int PPMin1 = 2;  // connect the desired channel (PPM signal) from your RC receiver to digital pin 2 on Arduino. 
int PPMin2 = 3;

int RCval1;  // store RC signal pulse length
int adj_val1;  // mapped value to be between 0-511

int RCval2;  // store RC signal pulse length
int adj_val2;  // mapped value to be between 0-511

int change_fx = 14;

int fx_state;

int potPin1 = 15;
int potPin2 = 16;

int pot_val1;
int pot_val2;

void setup() {
  
  Serial.begin(9600);  

  // set all the other pins you're using as outputs:
  //motor1 pins
  pinMode(motor1_p1, OUTPUT); 
  pinMode(motor1_n1, OUTPUT); 
  pinMode(motor1_p2, OUTPUT);
  pinMode(motor1_n2, OUTPUT);
  //motor2 pins
  pinMode(motor2_p1, OUTPUT); 
  pinMode(motor2_n1, OUTPUT); 
  pinMode(motor2_p2, OUTPUT);
  pinMode(motor2_n2, OUTPUT);  
  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT); 
  //PPM inputs from RC receiver
  pinMode(PPMin1, INPUT); //Pin 2 as input
  pinMode(PPMin2, INPUT); //Pin 3 as input
  
  pinMode(potPin1, INPUT);
  pinMode(potPin2, INPUT);
  
  interrupts();
  
  pinMode(change_fx, INPUT);

  attachInterrupt(0, rc1, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  attachInterrupt(1, rc2, RISING);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()
}

void loop() {
  
  fx_state = digitalRead(change_fx);

  adj_val1 = map(RCval1, 630, 1125, 0, 255);  // my observed RC values are between 630-1125.. these might need to be changed, depending on your RC system.
  adj_val2 = map(RCval2, 630, 1125, 0, 255);  // my observed RC values are between 630-1125.. these might need to be changed, depending on your RC system.
  
  if (change_fx == LOW) {
        
//write adj_val1 to motor1
  if (adj_val1 > 265) {
    //Forward
    digitalWrite(motor1_p1, HIGH);
    digitalWrite(motor1_n1, HIGH);
    
    digitalWrite(motor1_p2, LOW);
    analogWrite(motor1_n2, 511 - adj_val1);
    
    digitalWrite(ledPin1, LOW);
  } 
 
  else if (adj_val1 < 245) {
    //REVERSE
    digitalWrite(motor1_p1, LOW);
    analogWrite(motor1_n1, adj_val1);
    
    digitalWrite(motor1_p2, HIGH);
    digitalWrite(motor1_n2, HIGH);
    
    digitalWrite(ledPin1, LOW);
  }
  
  else {
  //STOP
  digitalWrite(ledPin1, HIGH);

  digitalWrite(motor1_p1, LOW);
  digitalWrite(motor1_n1, HIGH);
    
  digitalWrite(motor1_p2, LOW);
  digitalWrite(motor1_n2, HIGH);
 }

//write adj_val2 to motor2
  if (adj_val2 > 265) {
    //Forward
    digitalWrite(motor2_p1, HIGH);
    digitalWrite(motor2_n1, HIGH);
    
    digitalWrite(motor2_p2, LOW);
    analogWrite(motor2_n2, 511 - adj_val2);
    
    digitalWrite(ledPin2, LOW);
  } 
 
  else if (adj_val2 < 245) {
    //REVERSE
    digitalWrite(motor2_p1, LOW);
    analogWrite(motor2_n1, adj_val2);
    
    digitalWrite(motor2_p2, HIGH);
    digitalWrite(motor2_n2, HIGH);
    
    digitalWrite(ledPin2, LOW);
  }
  
  else {
  //STOP
  digitalWrite(ledPin2, HIGH);

  digitalWrite(motor2_p1, LOW);
  digitalWrite(motor2_n1, HIGH);
    
  digitalWrite(motor2_p2, LOW);
  digitalWrite(motor2_n2, HIGH);
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

 else {
   
   pot_val1 = analogRead(potPin1) / 2;
   pot_val2 = analogRead(potPin2) / 2;
   
   if (pot_val1 > 265) {
    //Forward
    digitalWrite(motor1_p1, HIGH);
    digitalWrite(motor1_n1, HIGH);
    
    digitalWrite(motor1_p2, LOW);
    analogWrite(motor1_n2, 511 - pot_val1);
    
    digitalWrite(ledPin1, LOW);
  } 
 
  else if (pot_val1 < 245) {
    //REVERSE
    digitalWrite(motor1_p1, LOW);
    analogWrite(motor1_n1, pot_val1);
    
    digitalWrite(motor1_p2, HIGH);
    digitalWrite(motor1_n2, HIGH);
    
    digitalWrite(ledPin1, LOW);
  }
  
  else {
  //STOP
  digitalWrite(ledPin1, HIGH);

  digitalWrite(motor1_p1, LOW);
  digitalWrite(motor1_n1, HIGH);
    
  digitalWrite(motor1_p2, LOW);
  digitalWrite(motor1_n2, HIGH);
 }

//write adj_val2 to motor2
  if (pot_val2 > 265) {
    //Forward
    digitalWrite(motor2_p1, HIGH);
    digitalWrite(motor2_n1, HIGH);
    
    digitalWrite(motor2_p2, LOW);
    analogWrite(motor2_n2, 511 - pot_val2);
    
    digitalWrite(ledPin2, LOW);
  } 
 
  else if (pot_val2 < 245) {
    //REVERSE
    digitalWrite(motor2_p1, LOW);
    analogWrite(motor2_n1, pot_val2);
    
    digitalWrite(motor2_p2, HIGH);
    digitalWrite(motor2_n2, HIGH);
    
    digitalWrite(ledPin2, LOW);
  }
  
  else {
  //STOP
  digitalWrite(ledPin2, HIGH);

  digitalWrite(motor2_p1, LOW);
  digitalWrite(motor2_n1, HIGH);
    
  digitalWrite(motor2_p2, LOW);
  digitalWrite(motor2_n2, HIGH);
 }
   //print values
  Serial.print("potval1:  ");
  Serial.print(pot_val1);
  Serial.print("        ");  
  Serial.print("potval2:  ");
  Serial.print(pot_val2);  
  Serial.println("        ");
 }

}

void rc1() {
  
    RCval1 = pulseIn(PPMin1, HIGH, 20000);      //read RC channel 1
}

void rc2() {
  
    RCval2= pulseIn(PPMin2, HIGH, 20000);      //read RC channel 1
}

