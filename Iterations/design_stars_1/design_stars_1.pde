ArrayList<PVector> points,notOccupied;
PGraphics letter;
String message = "design";
PImage p;
float s=400,max=0;

star newStar;
ArrayList<star> starArray = new ArrayList<star>();
float h2;//=height/2
float w2;//=width/2
float d2;//=diagonal/2
int numberOfStars = 2000;
int newStars =50;
//int starsInLetter=0;
boolean[] occupied;
PFont font;
ArrayList<star> starsInLetter = new ArrayList<star>();

void setup() {
  
  size(900, 900,P2D);
  letter = createGraphics(width,height,P2D);
  w2=width/2;
  h2= height/2;
  d2 = dist(0, 0, w2, h2);
  noStroke();
  font=createFont("OpenSans-Light",150);
  createLetter();
  occupied= new boolean[points.size()];
  initializeOccupied();
  
  
  newStar= new star();
  frameRate(10);
  background(0);  
}

void draw() {
  
  fill(0, map(dist(mouseX, mouseY, w2, h2), 0, d2, 255, -10)); // Mapping distance of cursor from center to 255,-10. The opacity is the mapped distance.
  rect(0, 0, width, height);//Background
  fill(255);//White stars  
  newStar.render();
  createLetter();
  
  for (int i = 0; i<newStars; i++) {   // star init
    starArray.add(new star());
  }

  for (int i = 0; i<starArray.size(); i++) {
    if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) starArray.remove(i); //remove the star if it is out of the frame
    starArray.get(i).move();//move the star
    starArray.get(i).render(); //show the star after movement
  }
  
  if (starArray.size()>numberOfStars) {
    //keeps the total number of stars constant    
    int extraStars=starArray.size()-numberOfStars;
    int i=0;
    
    while(i<extraStars) 
    {
      if(!starArray.get(i).inLetter)
        starArray.remove(i);
      else  
        i++;  
    }
  }
  
  //if(starsInLetter>5*points.size()) {
  //  //alpha++;
  //  lightUpLetters();
  //  println("The limit has been reached..."+starsInLetter);
  //  println("The total number of stars is "+starArray.size());
  //}
  
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
  letter.textSize(150);
  letter.textLeading((letter.textAscent()+letter.textDescent()));
  letter.textFont(font);
  letter.textAlign(CENTER,CENTER);
  letter.text(message, width/2, height*.45);
  letter.endDraw();
  letter.loadPixels();
 
  points=new ArrayList(); //creates a new arraylist of vectors....refreshing page
  p=letter;//assigns the image to the graphics
  p.loadPixels(); //loads the image
  
  for(int x=0;x<p.width;x++){//this loop converts all pixels of the image into vectors
    for(int y=0;y<p.height;y++){
      int index=x+y*p.width;
      color c1=p.pixels[index];
      float b=brightness(c1);
      if(b>1){
        points.add(new PVector(x,y));
      }
    }     
  }
  
  notOccupied = points;
  
  //println("The size of points is: "+points.size()); 
}

class star {
  float x, y, speed, d, age,sizeIncr;
  int wachsen;
  boolean inLetter=false;
  color c;
    
  star() {    
      x = random(width); // assigning the star a random location
      y = random(height);
          
      while(insideLetter(x,y))
      {
        x=random(width);
        y=random(height);
      }
      
      c= color(random(250),random(250),random(250));
      
      speed = random(0.2, 5); //assigning the star a random speed
      wachsen= int(random(0, 2)); //wachsen means to grow
      if(wachsen==1)d = 0;
      else {
        d= random(50, 100);
      }
      age=0;
      sizeIncr= random(0,0.03);
  }
  
  //Renders the star
  void render() {
   age++;
     if (age<200){ //rendered at max 200 times
       if (wachsen==1){
         d+=sizeIncr;
         if (d>3||d<-3) d=3;
       }else {
         if (d>3||d<-3) d=3;
         d= d+0.2-0.6*noise(x, y, frameCount);
       }
       
     }
     else{
       if (d>3||d<-3) d=3;
     }
    
    if(inLetter) 
      fill(c);
      
    ellipse(x, y, d*(map(noise(x, y,0.001*frameCount),0,1,0.2,2.5)), d*(map(noise(x, y,0.001*frameCount),0,1,0.2,2.5)));
  }
  
  //Moves the star based on conditions
  void move() {
    
    if(!insideLetter(x,y))
    {
      x =x-map(mouseX, 0, width, -0.05*speed, 0.05*speed)*(w2-x); 
      y =y-map(mouseY, 0, height, -0.05*speed, 0.05*speed)*(h2-y);  
    }
    else
    {
       //Checks if the star overlaps another star
       for(star s : starsInLetter)
       {
         if(this.x==s.x && this.y==s.y)
         {
           //Move the star if it overlaps with another star
           println("Stars overlap!");
           
           //x =x-map(mouseX, 0, width, -0.05*speed, 0.05*speed)*(w2-x); 
           //y =y-map(mouseY, 0, height, -0.05*speed, 0.05*speed)*(h2-y); 
           return;
         }                         
       }
       
       inLetter=true;
       starsInLetter.add(this);
    }    
  }
}

boolean insideLetter(float x, float y)
{
  for(int i=0;i<notOccupied.size();i++)
  {
    int px=int(notOccupied.get(i).x);
    int py=int(notOccupied.get(i).y);
    
    if(abs(x-px)<1 && abs(y-py)<1)
    {
        //if(occupied[i])//Checks if the x,y position has been occupied by another star
        //  return false;
        //else
        //{
        //  occupied[i]=true;
          //starsInLetter++;
          notOccupied.remove(i);
          println("Inside letter.");
          return true;
        //}        
    }
  }
  return false;
}