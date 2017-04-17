String message ="design";
float w,h;

void setup()
{
  size(1280,720);
  textAlign(CENTER, CENTER);
  textSize(150.0);
  fill(138);
  w = textWidth(message);
  h = 0.5 * (textAscent()+textDescent());
}

void draw()
{
  background(0);
  float col = map(width/2-abs(mouseX-width/2),0,640,0,138);
  fill(138,col,col);
  text(message,mouseX,height/2);   
}