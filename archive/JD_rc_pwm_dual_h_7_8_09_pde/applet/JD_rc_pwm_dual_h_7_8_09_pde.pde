
//4 wire control, high side mosfets are switched on/off, low side mosfets are PWM'd. 4 npn transistors switch the high/low mosfets.

int motor1_p1 = 4;    // High side left
int motor1_n2 = 5;
int motor1_p3 = 7;    // High side right
int motor1_n4 = 6;

int motor2_p1 = 8;    // High side left
int motor2_n2 = 9;
int motor2_p3 = 10;    // High side right
int motor2_n4 = 11;

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

void setup() {
  
	Serial.begin(9600);  

	// set all the other pins you're using as outputs:
	pinMode(motor1_p1, OUTPUT); 
	pinMode(motor1_n2, OUTPUT); 
	pinMode(motor1_p3, OUTPUT);
	pinMode(motor1_n4, OUTPUT);

	pinMode(motor2_p1, OUTPUT); 
	pinMode(motor2_n2, OUTPUT); 
	pinMode(motor2_p3, OUTPUT);
	pinMode(motor2_n4, OUTPUT);

        //led's
        pinMode(ledPin1, OUTPUT);
        pinMode(ledPin2, OUTPUT);
  
        //PPM inputs from RC receiver
        pinMode(PPMin1, INPUT); //Pin 2 as input
        pinMode(PPMin2, INPUT); //Pin 3 as input
}

void loop() {
  
	RCval1 = pulseIn(PPMin1, HIGH, 20000);      //read RC channel 1 
	if (RCval1 == 0) {RCval1 = lastgood1;} else {lastgood1 = RCval1;}
	adj_val1 = map(RCval1, 1000, 2000, 0, 511);
	constrain (adj_val1, 0, 511);

	RCval2 = pulseIn(PPMin2, HIGH, 20000);      //read RC channel 2
	if (RCval2 == 0) {RCval2 = lastgood2;} else {lastgood2 = RCval2;}
	adj_val2 = map(RCval2, 1000, 2000, 0, 511);  
	constrain (adj_val2, 0, 511);

  ///////////////////////////////////////// motor1

	if (adj_val1 > 260) {
	//Forward
	digitalWrite(motor1_p1, HIGH);
	digitalWrite(motor1_n2, HIGH);

	digitalWrite(motor1_p3, LOW);
	analogWrite(motor1_n4, 511 - adj_val1);

	digitalWrite(ledPin1, LOW);
  } 
 
	else if (adj_val1 < 250) {
	//REVERSE
	digitalWrite(motor1_p1, LOW);
	analogWrite(motor1_n2, adj_val1);

	digitalWrite(motor1_p3, HIGH);
	digitalWrite(motor1_n4, HIGH);

	digitalWrite(ledPin1, LOW);
  }
  
	else {
	//STOP
	digitalWrite(ledPin1, HIGH);

	digitalWrite(motor1_p1, LOW);
	digitalWrite(motor1_n2, HIGH);

	digitalWrite(motor1_p3, LOW);
	digitalWrite(motor1_n4, HIGH);
  }

  /////////////////////////////////////////////////////// motor2

	if (adj_val2 > 260) {
	//Forward
	digitalWrite(motor2_p1, HIGH);
	digitalWrite(motor2_n2, HIGH);

	digitalWrite(motor2_p3, LOW);
	analogWrite(motor2_n4, 511 - adj_val2);

	digitalWrite(ledPin2, LOW);
  } 
 
	else if (adj_val2 < 250) {
	//REVERSE
	digitalWrite(motor2_p1, LOW);
	analogWrite(motor2_n2, adj_val2);

	digitalWrite(motor2_p3, HIGH);
	digitalWrite(motor2_n4, HIGH);

	digitalWrite(ledPin2, LOW);
  }

	else {
	//STOP
	digitalWrite(ledPin2, HIGH);

	digitalWrite(motor2_p1, LOW);
	digitalWrite(motor2_n2, HIGH);

	digitalWrite(motor2_p3, LOW);
	digitalWrite(motor2_n4, HIGH);
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

	//delay(20);

}
