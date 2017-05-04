#include "simple-OSC.h"

// create OSC object
UDP osc;

// set IP addresses and ports for I/O
IPAddress outIp(128, 237, 130, 212);
unsigned int outPort = 8080;
unsigned int inPort = 8000;

// create named variables for pins
int accelXPin = A0;
int accelYPin = A1;
int accelZPin = A2;

float accel_x,accel_y,accel_z;

// runs once at the beginning of the program
void setup() {

	// start serial & OSC
	Serial.begin(9600);
	osc.begin(inPort);

	pinMode(accelXPin, INPUT);
	pinMode(accelYPin, INPUT);
	pinMode(accelZPin, INPUT);

	// You can view Serial.print() commands sent from the Photon via your computer's console (while it's plugged in to the computer).
	// Do `ls /dev/tty.usb*` in terminal to find the address of the Photon,
	// then do `screen ADDRESS BAUD` to make a serial monitor.
	// For example, if my Photon is "/dev/tty.usbmodem331", I'd do 'screen /dev/tty.usbmodem331 115200'.

	// while waiting for connection to be set up
	while (!WiFi.ready()) {
		// wait and print to console
		delay(500);
		Serial.print(".");
	}
	// print to console when connection is started
	Serial.println("");
	Serial.println("WiFi connected");
	// get Photon's IP:PORT and print it to console
	IPAddress ip = WiFi.localIP();
	Serial.print(F("ip : "));
	Serial.print(ip);
	Serial.print(F(" : "));
	Serial.println(inPort);
}


// continuously runs throughout the life of the program, after setup()
void loop() {

	accel_x = analogRead(accelXPin);
	accel_y = analogRead(accelYPin);
	accel_z = analogRead(accelZPin);

	// SEND ===

	// To test sending messages, you can use `nc -ul PORT` in terminal to listen to incoming messages on localhost.
	// For example, if outIp is my computer's IP address (128.237.246.8), and outPort is the port I'm sending to (9000),
	// then I'd run `nc -ul 9000` in terminal, and send a message from the Photon using the following example.
	//
	// For TouchOSC, you'd want to send the appropriate route to your mobile device's IP. Follow instructions [here](http://hexler.net/docs/touchosc)

	// create an outgoing message object
	OSCMessage outMessage("/accelerometer");

	// add parameters to the object
	outMessage.addString("The accelerometer values are: ");
	outMessage.addFloat(accel_x);
	outMessage.addFloat(accel_y);
	outMessage.addFloat(accel_z);

	// send the object
	outMessage.send(osc, outIp, outPort);

	Serial.printf("Accelerometer values are: %f, %f, %f \n",accel_x,accel_y,accel_z);
	delay(500);
}
