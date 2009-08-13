//read PPM signals from 2 channels of an RC reciever and convert the values to PWM in either direction.
// digital pins 4,5,6, & 7 control motor1, digital pins 8, 9, 10, & 11 control motor2. DP 12 and 13 are neutral indicator lights. 
// DP 2 and 3 are inputs from the R/C receiver. All analog pins are open. "enable1_a" and "motor1_a" are opposite legs of the H-bridge
// When a high-side mosfet is brought HIGH, it is ON (LOW = OFF). Low side mosfets: LOW = ON (HIGH = OFF). 
// Low side mosfets should be driven via PWM, and High side mosfets act as enable switches. 

// changes: created functions for testing the signal and writing values to motors. 

int enable1_a = 4;
int enable1_b = 7;

int motor1_a = 5;    
int motor1_b = 6;    

int enable2_a = 8;
int enable2_b = 11;

int motor2_a = 9;
int motor2_b = 10;    

//Neutral indicator LED's (FWD and REV LED's are on the motor driver board.
int ledPin1 = 12;      
int ledPin2 = 13;

int ppm1 = 2;  // connect the desired channel (PPM signal) from your RC receiver to digital pin 2 on Arduino. 
int ppm2 = 3;

volatile int rc1_PulseStartTicks;
volatile int rc1_val;  // store RC signal pulse length
int lastgood1;
int adj_val1;  // mapped value to be between 0-511
int rc1_InputReady;

volatile int rc2_PulseStartTicks;
volatile int rc2_val;  // store RC signal pulse length
int lastgood2;
int adj_val2;  // mapped value to be between 0-511
int rc2_InputReady;

int deadband_high = 265; // set the desired deadband ceiling (ie. if adj_val is above this, you go forward)
int deadband_low = 245;  // set deadband floor (ie. below this, go backward)

int delta_val = 400; //this value sets the range for discarding unwanted signals.

void setup() {

  Serial.begin(9600);  

  // set all the other pins you're using as outputs:
  //motor1 pins
  pinMode(motor1_a, OUTPUT); 
  pinMode(motor1_b, OUTPUT); 
  pinMode(enable1_a, OUTPUT);
  pinMode(enable1_b, OUTPUT);

  pinMode(motor2_a, OUTPUT); 
  pinMode(motor2_b, OUTPUT); 
  pinMode(enable2_a, OUTPUT);
  pinMode(enable2_b, OUTPUT);

  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(ppm1, INPUT); //Pin 2 as input
  pinMode(ppm2, INPUT); //Pin 3 as input

  attachInterrupt(0, rc1, CHANGE);    // catch interrupt 0 (digital pin 2) going HIGH and send to rc1()
  attachInterrupt(1, rc2, CHANGE);    // catch interrupt 1 (digital pin 3) going HIGH and send to rc2()

  lastgood1 = 255;
  lastgood2 = 255;

}


void rc1()
{
  // did the pin change to high or low?
  if (digitalRead( ppm1 ) == HIGH)
  {
    // store the current micros() value
    rc1_PulseStartTicks = micros();    
  }
  else
  {
    // Pin transitioned low, calculate the duration of the pulse
    rc1_val = micros() - rc1_PulseStartTicks; // may glitch during timer wrap-around
    // Set flag for main loop to process the pulse
    rc1_InputReady = true;
  }
}


void rc2()
{
  // did the pin change to high or low?
  if (digitalRead( ppm2 ) == HIGH)
  {
    // store the current micros() value
    rc2_PulseStartTicks = micros();    
  }
  else
  {
    // Pin transitioned low, calculate the duration of the pulse
    rc2_val = micros() - rc2_PulseStartTicks; // may glitch during timer wrap-around
    // Set flag for main loop to process the pulse
    rc2_InputReady = true;
  }
}


void loop() {

  test_signal(rc1_InputReady, rc1_val, adj_val1, lastgood1); // signal 1  

  motor_update(adj_val1, enable1_a, enable1_b, motor1_a, motor1_b, ledPin1);  // Update motor1 outputs.    

  test_signal(rc2_InputReady, rc2_val, adj_val2, lastgood2); // signal 2

  motor_update(adj_val2, enable2_a, enable2_b, motor2_a, motor2_b, ledPin2);  // Update motor2 outputs

}

void test_signal(int w, int x, int y, int z)
{
   if (w) // int w should be the rcx_InputReady
   {
     // reset input flag
     w = false;

     // constrain and map the pulse length
     y = map(constrain(x, 1000, 2000), 1000, 2000, 0, 511);

     if (y == 0){          // if value is 0, use last good value 
       y = z; 
     }
     else if (y == 511){   // if value is 511, use last good value
       y = z; 
     }
     else if (((y - z) * 2) > delta_val){   // make sure the new value is within range of the last known good value. 
       y = z;
    }
    else {
      z = y;   // if all conditions are met, use new value and set it as lastgood value.
    }
  }
}

void motor_update(int adj_val, int e1, int e2, int m1, int m2, int led)
  {

    if (adj_val > deadband_high) 
    {  
      //Forward
      digitalWrite(e2, LOW); // turn off unused mosfets first
      digitalWrite(m2, HIGH); // turn off

      digitalWrite(e1, HIGH); // then turn on mosfets to be used
      analogWrite(m1, 511 - adj_val); // turn on PWM
      digitalWrite(led, LOW); // turn off led
    } 
    else if (adj_val < deadband_low) 
    {
      //REVERSE
      digitalWrite(e1, LOW); // turn off unused mosfets first
      digitalWrite(m1, HIGH); // turn off 

      digitalWrite(e2, HIGH); // then turn on mosfets to be used
      analogWrite(m2, adj_val); // .... inverted formula
      digitalWrite(led, LOW); // turn off led
    }
    else 
    {
      //STOP
      digitalWrite(led, HIGH); // turn on neutral light
      digitalWrite(e1, LOW); // turn off all mosfets
      digitalWrite(e2, LOW);
      digitalWrite(m1, HIGH);
      digitalWrite(m2, HIGH);
    }
}

