class star {
  float x, y, speed, d, age,sizeIncr;
  int wachsen;
  boolean inLetter=false;
  color c;
  String state;
    
  star() {    
      x = random(width); // assigning the star a random location
      y = random(height);
      state="float";
      
      // if(hand_detected)
      // {
      //   while(insideLetter(x,y))
      //   {
      //     x=random(width);
      //     y=random(height);
      //   }
      // }      
      
      c = color(random(250),random(250),random(250));
      
      speed = random(0.2, 3); //assigning the star a random speed
      wachsen = int(random(0, 2)); //wachsen means to grow
      if(wachsen == 1)d = 0;
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
         //d= d+0.2-0.6*noise(x, y, frameCount);//framecount shows number of frames rendered since beginning
       }
       
     }
     else{
       if (d>3||d<-3) d=3;
     }
     
     if(state=="stay_glow")
     {
       float alpha=55*sin(float(millis())/2000*PI)+200;
       fill(alpha);       
     }
     else
     {
       fill(c);
     }
      
    ellipse(x, y, d*(map(noise(x, y,0.001*frameCount),0,1,0.2,2)), d*(map(noise(x, y,0.001*frameCount),0,1,0.2,2)));    
  }
  
  //Moves the star based on conditions
  void move() {
    
    if(state=="float" || state=="disperse")
    {
      x = x - map(width/2+5, 0, width, -0.05*speed, 0.05*speed)*(w2-x); 
      y = y - map(height/2-5, 0, height, -0.05*speed, 0.05*speed)*(h2-y);  
    }
    else if(state=="move")
    {
      x = x - map(handX, 0, width, -0.05*speed, 0.05*speed)*(w2-x);
      y = y - map(handY, 0, height, -0.05*speed, 0.05*speed)*(h2-y);
    }
    else
    {
      
    }
           
  }
}