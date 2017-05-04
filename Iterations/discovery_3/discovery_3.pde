import netP5.*;
import oscP5.*;

import de.voidplus.leapmotion.*;

LeapMotion leap;

int intervalGap = 8000;

OscP5 oscP5;
NetAddress myRemoteLocation;

ArrayList<PVector> points,notOccupied,occupied;
PGraphics letter;
String message = "design";
PImage p;
float s=400,max=0;
boolean endOfStory=false;
boolean disperse=true;
int handDetectedAt=0;
int threshold=0;
int pointsSize=0;

star newStar;
ArrayList<star> starArray = new ArrayList<star>();
float h2,w2,d2;//=height/2,weight/2,diagonal/2
int numberOfStars = 10000;
int newStars = 50;
PFont font;
ArrayList<star> starsInLetter = new ArrayList<star>();

int defaultX = width/2+5;
int defaultY = height/2-10;

PVector handPosition;
Hand hand;
float handX,handY;
boolean handDetected=false;
boolean firstDetection=true;

void setup(){
  
  size(1400, 900,P2D);
  
  w2 = width/2;
  h2 = height/2;
  d2 = dist(0, 0, w2, h2);
  
  oscP5 = new OscP5(this,9000);
  myRemoteLocation = new NetAddress("128.237.178.108",3000);

  occupied = new ArrayList<PVector>();
  
  noStroke();
  font = createFont("Montserrat-regular",250);
  
  frameRate(25);
  background(0);
  
  letter = createGraphics(width,height,P2D);
  createLetter();
  
  leap = new LeapMotion(this);
  
  newStar = new star();
}

void draw(){
   
  if(leap.getHands().size()>0)
  {  
    handDetected=true;
    
    handDetectedAt=millis();
    handPosition = leap.getHands().get(0).getPosition();
  
    handX = map(handPosition.x,0,1000,0,width);
    handY = map(handPosition.y,100,500,0,height);
    
    OscMessage leapMessage = new OscMessage("/leappatterns");
    leapMessage.add(handX);
    leapMessage.add(handY);
    
    oscP5.send(leapMessage, myRemoteLocation);
  }
  else
  {
    handDetected=false;
  }
      
  if(handDetected)
    fill(0, map(dist(handX, handY, w2, h2), 0, d2, 255, -10)); // Mapping distance of cursor from center to 255,-10. The opacity is the mapped distance
  else
    fill(0);
    
  rect(0, 0, width, height); //Background
  fill(255); //White stars
  newStar.render();
  
  //Adds new stars
  int i=0;
  while(i<newStars)
  {
    star newStar = new star();
    
    starArray.add(newStar);
    i++;    
  }  
          
  //Moves and renders the new stars
  for (int j = 0; j<starArray.size(); j++) {
    star s = starArray.get(j);
    
    removeOutOfFrame(j);

  if(firstDetection && handDetected)
  {
    s.state="initial_sequence";
    firstDetection=false;
    // delay(1000);
  }
  else
  {
    if(notOccupied.size() < threshold)
         {
           if((millis() > handDetectedAt + 2*intervalGap) && s.state=="stay_glow")
           {
             s.state="float";
             createLetter();
             numberOfStars=10000;
             firstDetection=true;
           }
           else
           {        
             if(s.state=="stay" || s.state=="stay_glow")
             {
               s.state="stay_glow";
             }
             else
             {
               s.state="float";
             }
   
             if(j<notOccupied.size()/2)
             {
               fillUpLetter(j*2);
             }
                     
           }  
         }
         else
         {
           if(s.state=="move")
           {
             int pointToBeRemoved = insideLetter(s);
             
             if(pointToBeRemoved>=0)
             {
               //println("Point to be removed is: "+pointToBeRemoved);
               s.state="stay";
               // occupied.add(new PVector(s.x,s.y));
               removeNotOccupied(pointToBeRemoved);
             }      
           }
   
           if(handDetected)
           {      
             if(s.state=="float")
             {
               s.state="move";
             }
           }
           else
           {
             if(millis() > handDetectedAt + intervalGap)
             {
               s.state="float";
               firstDetection=true;
               
               if(notOccupied.size()<0.9*pointsSize)
               {
                 createLetter();
               }
             }  
           }     
         }
       } 
    
    // println("Total number of stars is: "+starArray.size());
      
    s.move();//move the star
    s.render(); //show the star after movement
  }
  
  removeExtraStars();
}

void removeOutOfFrame(int i){
  if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) 
    starArray.remove(i); //remove the star if it is out of the frame
}

void doInitialSequence(){

}

void lightUpLetters(){
  for(PVector v : points)
  {
    fill(255,255,0);
    ellipse(v.x,v.y,1,1);
  }
}

void oscEvent(OscMessage oscM)
{
  if(oscM.checkAddrPattern("/leappatterns"))
  {
    println("OscMessage received");
    float firstValue = oscM.get(0).floatValue();
    float secondValue = oscM.get(1).floatValue();
    println("The Hand values are: "+firstValue+", "+secondValue);
  }
}

void fillUpLetter(int index){

  //println("Filling up letter.");

  star s=new star();
  s.state="stay_glow";
  s.x=notOccupied.get(index).x;
  s.y=notOccupied.get(index).y;

  numberOfStars++;    
}

void createLetter(){
  println("Creating letter...");
  letter.beginDraw();
  letter.noStroke();
  letter.background(0);
  letter.fill(255);
  letter.textSize(100);
  letter.textLeading((letter.textAscent()+letter.textDescent()));
  letter.textFont(font);
  letter.textAlign(CENTER,CENTER);
  letter.text(message, width/2, height*.45);
  letter.endDraw();
  letter.loadPixels();
 
  points = new ArrayList(); //creates a new arraylist of vectors....refreshing page
  p=letter;//assigns the image to the graphics
  p.loadPixels(); //loads the image
  
  for(int x=0;x<p.width;x=x+2){//this loop converts all pixels of the image into vectors
    for(int y=0;y<p.height;y=y+2){
      
      int index=x+y*p.width;
      color c1=p.pixels[index];
      float b=brightness(c1);
      if(b>1)
        points.add(new PVector(x,y));            
    }     
  }
  
  notOccupied = points;
  pointsSize = points.size();
  threshold = pointsSize/2;
  
  // println("The size of points is "+points.size());
}

void removeExtraStars(){
  //Removes extra stars
  if (starArray.size()>numberOfStars) {
    //keeps the total number of stars constant    
    int extraStars=starArray.size() - numberOfStars;
    int i=0,j=0;
    
    // println("Removing stars because # of stars is "+starArray.size());
    
    while(i<extraStars+1)
    {
      star s = starArray.get(j);
      
      if(s.state!="stay" && s.state!="stay_glow")
      {
        i++;
        starArray.remove(j);
      } 
      else
      {
        j++;
      }           
    }        
  }
}

void removeNotOccupied(int i){

  // if(i>2 && i<(notOccupied.size()-10))
  // {
  //   for(int j=i-1;j<i+2;j++) //Remove 3 pixels neighboring and including i
      notOccupied.remove(i);          
  // }

  //println("Number of points that are not occupied are: "+notOccupied.size());
  //println("Total number of points is: "+points.size());
}

int insideLetter(star s) {
  float sX = s.x;
  float sY = s.y;

  for(int i=0;i<notOccupied.size();i++)
  {
    float pX = notOccupied.get(i).x;
    float pY = notOccupied.get(i).y;
    
    if(abs(sX-pX)<1 && abs(sY-pY)<1)
    {  
      return i;        
    }
  }

  return -1;
}

boolean occupied (PVector p) {
  
  for(int i=0;i<notOccupied.size();i++)
  {
    
  }
  return true;
}