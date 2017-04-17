
ArrayList<PVector> points;
PGraphics letter;
String message = "design";
PImage p;
float s=400,max=0;

star neuerStern;
ArrayList<star> starArray = new ArrayList<star>();
float h2;//=height/2
float w2;//=width/2
float d2;//=diagonal/2
int numberOfStars = 20000;
int newStars =50;

void setup() {
  size(900, 900,P2D);
  letter = createGraphics(width,height,P2D);
  w2=width/2;
  h2= height/2;
  d2 = dist(0, 0, w2, h2);
  noStroke();
  neuerStern= new star();
  frameRate(10);
  background(0);
}

void draw() {
  fill(0, map(dist(mouseX, mouseY, w2, h2), 0, d2, 255, -10)); // Mapping distance of cursor from center to 255,-10. The opacity is the mapped distance.
  rect(0, 0, width, height); //Background
  fill(255);//White stars
  neuerStern.render();
  
  createLetter();
  
  for (int i = 0; i<newStars; i++) {   // star init
    starArray.add(new star());
  }

  for (int i = 0; i<starArray.size(); i++) {
    if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) starArray.remove(i); //remove the star if it is out of the frame
    starArray.get(i).move();//move the star
    starArray.get(i).render(); //show the star after movement
  }
  if (starArray.size()>numberOfStars) {//keeps the total number of stars constant
    for (int i = 0; i<newStars; i++) {//removes the first stars that were added
      starArray.remove(i);
    }
  }
}

void createLetter(){
  letter.beginDraw();
  letter.noStroke();
  letter.background(0);
  letter.fill(255);
  letter.textSize(s);
  letter.textLeading((letter.textAscent()+letter.textDescent()));
  letter.textAlign(CENTER,CENTER);
  letter.text(message, width/2, height*.45);
  letter.endDraw();
  letter.loadPixels();
 
  points=new ArrayList(); //creates a new arraylist of vectors....refreshing page
  p=letter;//assigns the image to the graphics
  p.loadPixels(); //loads the image
  image(p,0,0);
  println("The image width is: {{p.width}}, {{p.height}}",p.width," ",p.height);
  
  for(int x=0;x<p.width;x++){//this loop converts all pixels of the image into vectors
    for(int y=0;y<p.height;y++){
      int index=x+y*p.width;
      color c1=p.pixels[index];
      println("Color value is: "+c1);
      float b=brightness(c1);
      println("Brightness value is: "+b);
      if(b>1){
        points.add(new PVector(x,y));
        println("Adding vector to points: "+x+", "+y+".");
      }
    }
  }
}

class star {
  float x, y, speed, d, age,sizeIncr;
  int wachsen;
  
  star() {
    x = random(width); // assigning the star a random location
    y = random(height);
    
    //println("Size of points is: "+points.size());
    //for(int i=0;i<points.size();i++)
    //{
    //  float px=points.get(i).x;
    //  float py=points.get(i).y;
      
    //  if(x==px && y==py)
    //  {
    //    x = random(width); // assigning the star a random location
    //    y = random(height);
    //  }      
    //}
    speed = random(0.2, 5); //assigning the star a random speed
    wachsen= int(random(0, 2)); //wachsen means to grow
    if(wachsen==1)d = 0;
    else {
      d= random(50, 100);
    }
    age=0;
    sizeIncr= random(0,0.03);
  }
  
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
    
    ellipse(x, y, d*(map(noise(x, y,0.001*frameCount),0,1,0.2,1.5)), d*(map(noise(x, y,0.001*frameCount),0,1,0.2,1.5)));
  }
  
  void move() {
    
    if(x>width/2-200 && x<width/2+200 && y>height/2-100 && y<height/2+100)
    {}
    else
    {
        x =x-map(mouseX, 0, width, -0.05*speed, 0.05*speed)*(w2-x);
        y =y-map(mouseY, 0, height, -0.05*speed, 0.05*speed)*(h2-y);      
    }
    
  }
}

//boolean sketchFullScreen() {// force fullscreen
//  return true;
//}