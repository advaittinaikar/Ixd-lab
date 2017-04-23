#include "simple-OSC.h"
/*#include <I2Cdev.h>*/
// create OSC object
UDP osc;

// set IP addresses and ports for I/O
IPAddress outIp(128, 237, 178, 108);
IPAddress inIp(128, 237, 178, 108);
unsigned int outPort = 9000;
unsigned int inPort = 3000;

// create named variables for pins
int ledStrips[] = {D0,D1,D2,D3,D4,D5,D6};

// runs once at the beginning of the program
void setup() {

	// start serial & OSC
	Serial.begin(9600);
	osc.begin(inPort);

	for(int i=0;i<sizeof(ledStrips);i++)
		pinMode(ledStrips[i], INPUT);

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
	Serial.println("Loop is running");
	//RECEIVE
  int size = 0;
  OSCMessage inMessage;
  if ( ( size = osc.parsePacket()) > 0)
  {
			Serial.println("Receiving osc message");

      while (size--)
      {
					char c=osc.read();
          inMessage.fill(c);
					Serial.println("Received osc message: ");
					Serial.println(c);
      }
      if( inMessage.parse())
      {
          /*float handX = inMessage.get(0).floatValue();*/
					/*float handY = inMessage.get(1).floatValue();*/
					/*Serial.printf("Can be parsed.");*/
					/*inMessage.getFloat(1);*/
					/*inMessage.prinOutputDatas();*/
      }
  }

	OSCMessage outMessage("/leappatterns");

	// add parameters to the object
	outMessage.addFloat(128.0);
	outMessage.addFloat(220.0);

	// send the object
	outMessage.send(osc, outIp, outPort);

	delay(500);
}
