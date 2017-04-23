/**
 * oscP5oscArgument by andreas schlegel
 * example shows how to parse incoming osc messages "by hand".
 * it is recommended to take a look at oscP5plug for an alternative way to parse messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 8080 */
  oscP5 = new OscP5(this,8080);
  myRemoteLocation = new NetAddress("127.0.0.1",8000);
}

void draw() {
  background(0);
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  if(theOscMessage.checkAddrPattern("/accelerometer"))
  {
    String firstValue = theOscMessage.get(0).stringValue();
    float secondValue = theOscMessage.get(1).floatValue();
    float thirdValue = theOscMessage.get(2).floatValue();
    float fourthValue = theOscMessage.get(3).floatValue();
    
    println("### received accel message from particle");
    println(firstValue+secondValue+", "+thirdValue+", "+fourthValue+".");
    return;
  }  
}