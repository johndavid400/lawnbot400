//read PPM signals from 2 channels of an RC reciever and convert the values to PWM in either direction.
// 

#include "WProgram.h"
void setup();
void loop();
int motor1_a = 5;    
int motor1_b = 6;    
int motor2_a = 9;
int motor2_b = 11;    

//Neutral indicator LED's (FWD and REV LED's are on the motor driver board.
int ledPin1 = 7;      
int ledPin2 = 10;

int PPMin1 = 2;  // connect the desired channel (PPM signal) from your RC receiver to digital pin 2 on Arduino. 
int PPMin2 = 3;

volatile int RCval1;  // store RC signal pulse length
int lastgood1;
int adj_val1;  // mapped value to be between 0-511

volatile int RCval2;  // store RC signal pulse length
int lastgood2;
int adj_val2;  // mapped value to be between 0-511


void setup() {
  
  Serial.begin(9600);  

  // set all the other pins you're using as outputs:
  //motor1 pins
  pinMode(motor1_a, OUTPUT); 
  pinMode(motor2_a, OUTPUT); 
  pinMode(motor1_b, OUTPUT); 
  pinMode(motor2_b, OUTPUT); 

  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  
  //PPM inputs from RC receiver
  pinMode(PPMin1, INPUT); //Pin 2 as input
  pinMode(PPMin2, INPUT); //Pin 3 as input
    
  //attachInterrupt(0, rc1, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  //attachInterrupt(1, rc2, RISING);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()
}

void loop() {
  
///////// MOTOR1 /////////

  RCval1 = pulseIn(PPMin1, HIGH, 20000);      //read RC channel 1 
  if (RCval1 == 0) {RCval1 = lastgood1;} else {lastgood1 = RCval1;}
  adj_val1 = map(RCval1, 1000, 2000, 0, 511);
  constrain (adj_val1, 0, 511);

  if (adj_val1 > 260) {  
    //Forward
    analogWrite(motor1_a, adj_val1 - 260); //write adj_val1 to motor1
    digitalWrite(motor1_b, LOW);
    digitalWrite(ledPin1, LOW);
  } 
  else if (adj_val1 < 250) {
    //REVERSE
    digitalWrite(motor1_a, LOW);    
    analogWrite(motor1_b, 250 - adj_val1); //write adj_val1 to motor1
    digitalWrite(ledPin1, LOW);
  }
  else {
  //STOP
  digitalWrite(ledPin1, HIGH); // turn on neutral light, turn motor pins off
  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, LOW);
 }

  /////// MOTOR 2 //////////
  
  RCval2 = pulseIn(PPMin2, HIGH, 20000);      //read RC channel 2
  if (RCval2 == 0) {RCval2 = lastgood2;} else {lastgood2 = RCval2;}
  adj_val2 = map(RCval2, 1000, 2000, 0, 511);  
  constrain (adj_val2, 0, 511);

  if (adj_val2 > 260) {
    //Forward
    analogWrite(motor2_a, adj_val2 - 260);  //write adj_val2 to motor2
    digitalWrite(motor2_b, LOW);
    digitalWrite(ledPin2, LOW);
  } 
 
  else if (adj_val2 < 250) {
    //REVERSE
    digitalWrite(motor2_a, LOW);
    analogWrite(motor2_b, 250 - adj_val2);
    digitalWrite(ledPin2, LOW);
  }
  
  else {
  //STOP
  digitalWrite(ledPin2, HIGH);
  digitalWrite(motor2_a, LOW);
  digitalWrite(motor2_b, LOW);

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

  delay(10);

}

/*
void rc1() {
    RCval1 = pulseIn(PPMin1, HIGH, 20000);      //read RC channel 1
}

void rc2() { 
    RCval2= pulseIn(PPMin2, HIGH, 20000);      //read RC channel 1
}
*/

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

