// This is the main code, it should run on the main processor.
// Read PPM signals from 2 channels of an RC reciever and convert the values to PWM in either direction.
// digital pins 5 & 9 control motor1, digital pins 6 & 10 control motor2. 
// DP 12 and 13 are neutral indicator lights. 
// DP 2 and 3 are inputs from the R/C receiver. 
// All analog pins are open. 
// When motor pin is HIGH, bridge is open.
// JDW 2010

// leave pins 0 and 1 open for serial communication

int ppm1 = 2;
int ppm2 = 3;

int motor1_BHI = 4;
int motor1_BLI = 5;  // PWM pin
int motor1_ALI = 6;  // PWM pin
int motor1_AHI = 7;

int motor2_BHI = 8;
int motor2_BLI = 9;   //PWM pin
int motor2_ALI = 10;  //PWM pin
int motor2_AHI = 11;

int ledPin1 = 12;
int ledPin2 = 13;

unsigned int servo1_val;
int yVal;
int left_motor = 0;

unsigned int servo2_val;
int xVal;
int right_motor = 0;

int deadband = 25;  // a deadband of 25 is 10% of the maximum 255

// You can adjust these values to calibrate the code to your specific radio - check the Serial Monitor to see your min/max channel 1 and 2 values.
int low = 1000;
int high = 2000;

void setup() {

  Serial.begin(9600);

  //motor1 pins
  pinMode(motor1_ALI, OUTPUT);
  pinMode(motor1_AHI, OUTPUT);
  pinMode(motor1_BLI, OUTPUT);
  pinMode(motor1_BHI, OUTPUT);

  //motor2 pins
  pinMode(motor2_ALI, OUTPUT);
  pinMode(motor2_AHI, OUTPUT);
  pinMode(motor2_BLI, OUTPUT);
  pinMode(motor2_BHI, OUTPUT);

  //led's
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);

  //PPM inputs from RC receiver
  pinMode(ppm1, INPUT); //Pin 2 as input
  pinMode(ppm2, INPUT); //Pin 3 as input

  delay(100);
}

void pulse(){
  // left/right channel
  servo1_val = pulseIn(2, HIGH, 20000);
  if (servo1_val > 1000 && servo1_val < 2000){
    yVal = map(servo1_val, low, high, -255, 255);
    if (yVal > 255) {
      yVal = 255;
    }
    if (yVal < -255) {
      yVal = -255;
    }
  }
  else {
    yVal = 0;
  }

  // forward/reverse channel
  servo2_val = pulseIn(3, HIGH, 20000);
  if (servo2_val > 1000 && servo2_val < 2000){
    xVal = map(servo2_val, low, high, -255, 255);
    if (xVal > 255) {
      xVal = 255;
    }
    if (xVal < -255) {
      xVal = -255;
    }
  }
  else {
    xVal = 0;
  }

  // transpose the X and Y values into Left and Right 
  left_motor = xVal + yVal;
  right_motor = xVal - yVal;

  if (left_motor > 255){
    left_motor = 255;
  }
  else if (left_motor < -255){
    left_motor = -255;
  }

  if (right_motor > 255){
    right_motor = 255;
  }
  else if (right_motor < -255){
    right_motor = -255;
  }
}

void loop() {

  pulse();

  if (left_motor > deadband){
    motor1_fwd(left_motor);
  }
  else if (right_motor < -deadband){
    motor1_rev(-left_motor);
  }
  else {
    motor1_stop();
  }

  if (right_motor > deadband){
    motor2_fwd(right_motor);
  }
  else if (right_motor < -deadband){
    motor2_rev(-right_motor);
  }
  else {
    motor2_stop();
  }
}

void serial_print(){
  Serial.print("ch1:  ");
  Serial.print(servo1_val);
  Serial.print("  ");
  Serial.print("Left/Right:  ");
  Serial.print(yVal);
  Serial.print("  ");

  Serial.print("ch2:  ");
  Serial.print(servo2_val);
  Serial.print("  ");
  Serial.print("Up/Down:  ");
  Serial.print(xVal);
  Serial.println("  ");
}

void motor1_fwd(int x){
  digitalWrite(motor1_AHI, LOW);
  digitalWrite(motor1_BLI, LOW);
  digitalWrite(motor1_BHI, HIGH);
  analogWrite(motor1_ALI, x);
  digitalWrite(ledPin1, LOW);
}
void motor1_rev(int x){
  digitalWrite(motor1_BHI, LOW);
  digitalWrite(motor1_ALI, LOW);
  digitalWrite(motor1_AHI, HIGH);
  analogWrite(motor1_BLI, x);
  digitalWrite(ledPin1, LOW);
}
void motor1_stop(){
  digitalWrite(ledPin1, HIGH);
  digitalWrite(motor1_BHI, LOW);
  digitalWrite(motor1_ALI, LOW);
  digitalWrite(motor1_AHI, LOW);
  digitalWrite(motor1_BLI, LOW);
}
void motor2_fwd(int x){
  digitalWrite(motor2_AHI, LOW);
  digitalWrite(motor2_BLI, LOW);
  digitalWrite(motor2_BHI, HIGH);
  analogWrite(motor2_ALI, x);
  digitalWrite(ledPin2, LOW);
}
void motor2_rev(int x){
  digitalWrite(motor2_BHI, LOW);
  digitalWrite(motor2_ALI, LOW);
  digitalWrite(motor2_AHI, HIGH);
  analogWrite(motor2_BLI, x);
  digitalWrite(ledPin2, LOW);
}
void motor2_stop(){
  digitalWrite(ledPin2, HIGH);
  digitalWrite(motor2_BHI, LOW);
  digitalWrite(motor2_ALI, LOW);
  digitalWrite(motor2_AHI, LOW);
  digitalWrite(motor2_BLI, LOW);
}

