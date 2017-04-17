float change=-0.5;
int diameter=50;
int numBalls=6;
float spring=0.01;
float easing=0.05;
int frame_left,frame_right;
Ball[] balls= new Ball[numBalls];
String message="design";

void setup()
{
  size(700,700);
  
  for(int i=0;i<numBalls;i++)
  {
    char temp = message.charAt(i);
    balls[i] = new Ball(int(random(width)),height/2,diameter,i,balls); //Need to change values here   
  }
  
  noStroke();
  fill(255,204);
}

void draw()
{
  background(10);
  frame_left = mouseX - 175;
  frame_right = mouseX + 175;
  
  int center = balls_center();
  int start = mouseX - 150;
  
  moveFrontBack(mouseY/10);
  
  //if(mouseY < height/2)
  //{
  //  text("design",0,0);
  //  //blur();
  //}
  //else
  
  
  if(center!=mouseX)
  {    
    for(int i=0;i<numBalls;i++)
    {
      float targetX = start + (Ball.spacing + 50)*i;
      float dx = targetX - balls[i].x;
      balls[i].x += easing*dx;
      
      balls[i].render();
    }
  }
  else if(mousePressed)
  {
    for(int i=0;i<numBalls;i++)
    {
      
      balls[i].collide();
      balls[i].move();
      balls[i].render();  
    }
  }
  else
  {
    for(Ball ball:balls)
    {
      
      ball.collide();
      ball.move();
      ball.render();
    }
  }  
}

static class Ball
{
  static int spacing;
  int x,y=0;
  int dia=0;
  int id;
  Ball[] balls;
  int vx,vy=0;
  boolean collided=false;
  char character;
  
  Ball(int x, int y , int dia , int id, Ball[] balls, char character)
  {
    this.x=x;
    this.y=y;
    this.id=id;
    this.dia=dia;
    this.balls=balls;
    this.character=character;
  }
  
  void collide()
  {    
    collided=false;
    
    for(int i=id+1;i<balls.length;i++)
    {
      float dx = balls[i].x-x;     
      float min_dist = balls[i].dia + dia;
      
      if(dx<min_dist)
      {
        collided=true;
        float targetX = x+min_dist;
        float ax = (targetX - balls[i].x)*spring;
        vx-=ax;        
        balls[i].vx +=ax;
      }
    }
  }
  
  void move()
  {
    x+=vx;
    //y+=vy;
    if(x > frame_right - dia/2)
    {
      x= frame_right - dia/2;
      x*=change;
    }
    else if(x<frame_left + dia/2)
    {
      x=frame_left + dia/2;
      x*=change;
    }    
  }
  
  void render()
  {
    println("The velocity is: "+vx);
    fill(255);
    
    if(collided)
      fill(150);
      
    ellipse(x,y,dia,dia);
  }
}

int balls_center()
{
  int sum=0;
  for(Ball ball : balls)
  {
    sum += ball.x;
  }
  
  return sum/numBalls;
}

void moveFrontBack(int size){
  
  Ball.spacing = (size*10)/35;
  
  for(Ball ball:balls)
  {
    ball.dia = size;    
  }
  
}