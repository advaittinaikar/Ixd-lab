import netP5.*;
import oscP5.*;

import de.voidplus.leapmotion.*;

LeapMotion leap;

int intervalGap = 5000;

float leapXmax = 1000;
float leapYmax = 500;

// OscP5 oscP5;
// NetAddress myRemoteLocation;

ArrayList<PVector> points,notOccupied,occupied;
PGraphics letter;
String message = "design";
PImage p;
float s=400,max=0;
boolean endOfStory=false;
boolean disperse=true;
int handsDetectedAt=0;
int glowStartedAt=0;
int threshold=0;
int pointsSize=0;

float prevHandNum=0;
float textWidth=0;

star newStar;
ArrayList<star> starArray = new ArrayList<star>();
float h2,w2,d2;//=height/2,weight/2,diagonal/2
int numberOfStars = 10000;
int newStars = 50;
PFont font;
ArrayList<star> starsInLetter = new ArrayList<star>();

int defaultX = width/2+5;
int defaultY = height/2-10;

PVector handPosition1,handPosition2;
Hand hand;
float hand1X,hand1Y,hand2X,hand2Y;
float handDiffX, handDiffY;
boolean handDetected=false;
boolean firstDetection=true;
boolean glowing=false;

void setup(){
  
  size(1300, 800,P2D);
  
  w2 = width/2;
  h2 = height/2;
  d2 = dist(0, 0, w2, h2);
  
  // oscP5 = new OscP5(this,9000);
  // myRemoteLocation = new NetAddress("128.237.178.108",3000);

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
  
   float handNum=0;

   for(int i=0;i<10;i++) //Sampling value to reduce variation
   {
     handNum += float(leap.getHands().size());
   }
   println("Hand num sum is:"+handNum);
   handNum = handNum/10.0;

   println("Hand num is: "+handNum);

  //int handNum = leap.getHands().size();

  if(handNum>1)
  {
    handDetected=true;
    
    handsDetectedAt=millis();  

    Hand hand1 = leap.getHands().get(0);
    Hand hand2 = leap.getHands().get(1);
    
    float hx1 = getSmoothXValue(hand1);
    float hy1 = getSmoothYValue(hand1);
    
    float hx2 = getSmoothXValue(hand2);
    float hy2 = getSmoothYValue(hand2);
    
    handDiffX = abs(hx2-hx1);
    handDiffY = abs(hy2-hy1);
    
    handDiffX = abs(map(handDiffX,200,width,0,width));
    handDiffY = abs(map(handDiffY,20,600,0,height));
    
    //println("The difference between hand x positions is:"+handDiffX);
    //println("The difference between hand y positions is:"+handDiffY);    
  }
  else
  {
    handDetected=false;
  }
      
  if(handDetected)
    fill(0, map(dist(handDiffX, handDiffY, w2, h2), 0, d2, 255, -10)); // Mapping distance of cursor from center to 255,-10. The opacity is the mapped distance
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
  }
  else
  {
    if(notOccupied.size() < threshold)
    {  
       if(!glowing)
       {
        glowing=true;
        glowStartedAt=millis();
       }

       if((millis() > glowStartedAt + intervalGap) && s.state=="stay_glow")
       {
         s.state="float";
         glowing=false;
         createLetter();
         // numberOfStars=10000;
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

         // if((starArray.size()<13000) && (j<notOccupied.size()/2))
         // {
         //   fillUpLetter(j*2);
         // }
                 
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
         if((handDiffX<w2 && handDiffY<h2)||s.state=="float")
         {
           s.state="move";
         }
         
       }
       else
       {
         if(millis() > handsDetectedAt + intervalGap)
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

    if(handNum==1 && prevHandNum==1 && !glowing)
    {
      String handsInside = "Place both hands over the table.";
      float t=textWidth(handsInside);
      fill(200);
      textSize(20);
      text(handsInside,w2-t/2,h2);
    }
  }
  
  removeExtraStars();

  prevHandNum = handNum;
}

//int checkHandNum(int[] handNumArray)
//{
//   for(int i=0;i<handNumArray.length;i++)
//   {
//     handNumArray
//   }
//}

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

void oscEvent(OscMessage oscM){
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
  starArray.add(s); 
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
  letter.text(message, w2, height*.45);
  letter.endDraw();
  letter.loadPixels();
  
  points = new ArrayList(); //creates a new arraylist of vectors....refreshing page
  p=letter;//assigns the image to the graphics
  p.loadPixels(); //loads the image
  
  for(int x=0;x<p.width;x=x+2){//this loop converts all pixels of the image into vectors
    for(int y=0;y<p.height;y+=2){
      
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
    
    while((i<extraStars+1)&&(j<numberOfStars))
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
  
      notOccupied.remove(i);          
}

int insideLetter(star s) {
  float sX = s.x;
  float sY = s.y;

  for(int i=0;i<notOccupied.size();i++)
  {
    float pX = notOccupied.get(i).x;
    float pY = notOccupied.get(i).y;
    
    if(abs(sX-pX)<0.5 && abs(sY-pY)<0.5)
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

float getSmoothXValue(Hand hand)
{
  float hx=0;
  for(int i=0;i<10;i++)
  {
    PVector h = hand.getPosition();
    float handX = constrain(h.x,0,width);
    handX = map(handX,0,leapXmax,0,width);
    
    hx+=handX;
  }
  
  //println("Average value of x: "+hx/6);
  return hx/10;
}

float getSmoothYValue(Hand hand)
{
  float hy=0;
  for(int i=0;i<10;i++)
  {
    PVector h = hand.getPosition();
    float handY = constrain(h.y,0,height);
    handY = map(handY,0,leapYmax,0,height);
    
    hy+=handY;
  }
  
  //println("Average value of y: "+hy/6);
  return hy/10;
}