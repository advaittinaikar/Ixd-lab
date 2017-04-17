String message ="Design";
float w,h;
int fontSize = 30;
int fontXPos = 25;
int fontSpacing = 20;
float max_distance;
PImage bg;

void setup()
{
  size(1280,720);
  textAlign(CENTER, CENTER);
  textSize(150.0);
  noStroke();
  fill(200);
  bg = loadImage("Project2design.png");
  w = textWidth(message);
  h = 0.5 * (textAscent()+textDescent());
  
  max_distance = dist(0, 0, width, height);
  
  fill(0);
  //textFont(createFont("Verdana", fontSize, true));  
}

void draw()
{
  background(bg); //black background
  //println(mouseX);
  //float col = map(width/2-abs(mouseX-width/2),260,640,0,200);
  //fill(200,col,col);
  //int fontSpacing = int(map(col,0,138,5,25));
  //drawText(message,mouseX,fontSpacing);
  
  fill(0,100);
  for(int i = 0; i <= width; i += 20) {
    for(int j = 0; j <= height; j += 20) {
      float size = dist(mouseX, mouseY, i, j);
      size = size/max_distance * 150;
      ellipse(i, j, size, size);
    }
  }
}

void drawText(String message, int fontXPos, int charSpacing){
  int charXPos;
  int[] charPos= new int[message.length()];
  int originalX = fontXPos;
  
  for (int i = 0; i < message.length(); i++) {
    char character = message.charAt(i);
    fontXPos += 0.5*textWidth(character);
    charPos[i]=fontXPos;
    fontXPos += 0.5*textWidth(character) + charSpacing;
  }
  
  int textWidth = fontXPos - charSpacing - originalX;
  
  for (int i=0; i< message.length();i++) {
    text(message.charAt(i),charPos[i]-textWidth/2,height/2);
  }
  
  //pushMatrix();
  //translate();
}