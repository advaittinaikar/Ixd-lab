import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Arduino arduino;

float accel_x,accel_y,accel_z;
Serial myserial;

void setup() {  
  printArray(Serial.list());
  myserial = new Serial(this, Serial.list()[1], 57600);
  
  println(myserial.read());
  //arduino = new Arduino(this, Arduino.list()[0], 57600);
  //println("It's working.");
  //size(900, 900);
  //background(0);  
}

void draw() {
   
  accel_x = map(arduino.analogRead(0),0,1023,100,height);
  accel_y = map(arduino.analogRead(1),0,1023,100,width);
  //accel_z = arduino.analogRead(2);
  
  //accel_x=arduino.analogRead(0);
  //accel_y=arduino.analogRead(1);
  
  println("The accelerometer values are, x: "+accel_x+", "+"y: "+accel_y+", z: "+accel_z);
  
  background(0);
  
  fill(255);
  ellipse(accel_x,accel_y,25,25);   
     
  //delay(500);  
}