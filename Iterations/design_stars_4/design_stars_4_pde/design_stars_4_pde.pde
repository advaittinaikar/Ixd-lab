import de.voidplus.leapmotion.*;
LeapMotion leap;

int time_duration = 5000;

ArrayList<PVector> points,notOccupied,Occupied;
PGraphics letter;
String message = "design";
PImage p;
float s=400,max=0;
boolean endOfStory=false;
boolean disperse=true;
int time_now=0;

star newStar;
ArrayList<star> starArray = new ArrayList<star>();
float h2,w2,d2;//=height/2,weight/2,diagonal/2
int numberOfStars = 10000;
int newStars = 50;
boolean[] occupied;
PFont font;
ArrayList<star> starsInLetter = new ArrayList<star>();

int defaultX = width/2+5;
int defaultY = height/2-10;

PVector handPosition;
Hand hand;
float hand_x,hand_y;
boolean hand_detected=false;

void setup() {
  
  size(1400, 900,P2D);
  
  w2 = width/2;
  h2 = height/2;
  d2 = dist(0, 0, w2, h2);
  
  noStroke();
  font = createFont("Montserrat-regular",250);
  
  frameRate(25);
  background(0);
  
  letter = createGraphics(width,height,P2D);
  createLetter();
  
  leap = new LeapMotion(this);
  
  occupied = new boolean[points.size()];
  initializeOccupied();
  
  newStar = new star();
}

void draw() {
   
  if(leap.getHands().size()>0)
  {
    time_now=millis();
    handPosition = leap.getHands().get(0).getPosition();
  
    hand_x = map(handPosition.x,0,1000,0,width);
    hand_y = map(handPosition.y,100,500,0,height);
    
    hand_detected=true;
  }
  else
  {
    hand_detected=false;
  }
  
  if(millis()< time_now + time_duration)
    disperse=false;
  else
    disperse=true;
    
  
  if(hand_detected)
    fill(0, map(dist(hand_x, hand_y, w2, h2), 0, d2, 255, -10)); // Mapping distance of cursor from center to 255,-10. The opacity is the mapped distance
  else
    fill(0);
    
  rect(0, 0, width, height); //Background
  fill(255); //White stars
  newStar.render();
  
  //Adds new stars
  for (int i = 0; i<newStars; i++) {   // star init
    starArray.add(new star());
  }
  
  if(notOccupied.size()<35660)
    endOfStory=true;
      
    
  //Moves and renders the new stars
  for (int i = 0; i<starArray.size(); i++) {
    if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) starArray.remove(i); //remove the star if it is out of the frame
    starArray.get(i).move();//move the star
    starArray.get(i).render(); //show the star after movement
  }
    
  //println("The number of stars is "+starArray.size());
  
  //Removes extra stars
  if (starArray.size()>numberOfStars) {
    //keeps the total number of stars constant    
    int extraStars=starArray.size()-numberOfStars;
    int i=0,j=0;
    
    while(i<extraStars)
    {
      star s = starArray.get(j);
      
      if(!s.inLetter)
      {
         i++;
         starArray.remove(j);
      } 
      else
         j++;
    }
        
  }
}

void lightUpLetters(){
  for(PVector v : points)
  {
    fill(255,255,0);
    ellipse(v.x,v.y,1,1);
  }
}

void initializeOccupied(){  
  for(int i=0;i<occupied.length;i++)
    occupied[i]=false;  
}

void createLetter(){
  
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
  
  for(int x=0;x<p.width;x++){//this loop converts all pixels of the image into vectors
    for(int y=0;y<p.height;y++){
      
      int index=x+y*p.width;
      color c1=p.pixels[index];
      float b=brightness(c1);
      if(b>1)
        points.add(new PVector(x,y));            
    }     
  }
  
  notOccupied = points;
  
  println("The size of points is "+points.size());
}

boolean insideLetter(float x, float y) {
  for(int i=0;i<notOccupied.size();i++)
  {
    int px=int(notOccupied.get(i).x);
    int py=int(notOccupied.get(i).y);
    
    if(abs(x-px)<1 && abs(y-py)<1)
    {
        if(i>2 && i<(notOccupied.size()-10))
        {
          for(int j=i-2;j<i+3;j++) //Remove 5 pixels neighboring and including i
            notOccupied.remove(i);          
        }
        println("Number of points that are not occupied are: "+notOccupied.size());
        return true;        
    }
  }
  return false;
}

boolean occupied (PVector p) {
  
  for(int i=0;i<notOccupied.size();i++)
  {
    
  }
  return true;
}