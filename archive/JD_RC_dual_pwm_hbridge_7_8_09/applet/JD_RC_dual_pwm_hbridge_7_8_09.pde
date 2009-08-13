
//4 wire control, high side mosfets are switched on/off, low side mosfets are PWM'd. 4 npn transistors switch the high/low mosfets.

//#include <avr/interrupt.h>


int motor1_a = 5;    // High side PWM
int motor1_b = 6;    // High side PWM
int motor2_a = 9;
int motor2_b = 11;    // Low side right PWM

//Neutral indicator LED's (FWD and REV LED's are on the motor driver board.
int ledPin1 = 10;      // LED1 
int ledPin2 = 7;

int PPMin1 = 3;  // connect the desired channel (PPM signal) from your RC receiver to digital pin 2 on Arduino. 
int PPMin2 = 2;

int RCval1;  // store RC signal pulse length
int adj_val1;  // mapped value to be between 0-511

int RCval2;  // store RC signal pulse length
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
  
  //interrupts();
  
  //attachInterrupt(0, rc1, RISING);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  //attachInterrupt(1, rc2, RISING);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()
}

void loop() {
  
  RCval1 = pulseIn(PPMin1, HIGH, 20000);      //read RC channel 1
  //RCval2 = pulseIn(PPMin2, HIGH, 20000);      //read RC channel 2
  adj_val1 = map(RCval1, 1000, 1900, 0, 511);  // my observed RC values are between 630-1125.. these might need to be changed, depending on your RC system.
  //adj_val2 = map(RCval2, 1100, 1900, 0, 511);  // my observed RC values are between 630-1125.. these might need to be changed, depending on your RC system.
 

//write adj_val1 to motor1
  if (adj_val1 > 265) {
    //Forward

    analogWrite(motor1_a, adj_val1 - 266);
    
    digitalWrite(ledPin1, LOW);
  } 
 
  else if (adj_val1 < 245) {
    //REVERSE
    analogWrite(motor1_b, 244 - adj_val1);
    
    digitalWrite(ledPin1, LOW);
  }
  
  else {
  //STOP
  digitalWrite(ledPin1, HIGH);

  digitalWrite(motor1_a, LOW);
  digitalWrite(motor1_b, LOW);

 }

//write adj_val1 to motor2
  if (adj_val2 > 265) {
    //Forward

    analogWrite(motor2_a, adj_val2 - 266);
    
    digitalWrite(ledPin2, LOW);
  } 
 
  else if (adj_val2 < 245) {
    //REVERSE
    analogWrite(motor2_b, 244 - adj_val2);
    
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

}



