int[] origin = { 100, 500 };
int segmentLength = 100;

float xOne, yOne, xTwo, yTwo, xThree, yThree;
int xOrigin = origin[0];
int yOrigin = origin[1]; 
float pointTwoXPosition, pointTwoYPosition;
int angle;
float vectorPointTwoX, vectorPointTwoY, vectorPointThreeX, vectorPointThreeY;

float thetaZeroGlobal, thetaOneGlobal, thetaTwoGlobal;
int thetaZeroLocal, thetaOneLocal, thetaTwoLocal;

int i;

void setup() {
  size(600,600);
}

void draw() {
  background(255);
  float[] output = calcArm(mouseX, mouseY, 1, angle);  //output[0]= xOne; output[1]= yOne; output[2]= xTwo; output[3]= yTwo;  
  //limits();
  drawArm();
  dashboard();
}

void drawArm(){
 
    //lines
  strokeWeight(14);
  stroke(100, 0, 100);
  line(xOrigin, yOrigin, xOne, yOne); // humerous
  stroke(0, 100, 100);
  line(xOne, yOne, xTwo, yTwo); // Unla
  line(xTwo, yTwo, xThree, yThree);
  //circles
  strokeWeight(4);
  stroke(0, 0, 0);
  fill(245, 255, 166);
  ellipse(xOrigin, yOrigin, 20, 20);
  ellipse(xOne, yOne, 20, 20);
  ellipse(xTwo, yTwo, 20, 20);
  ellipse(xThree, yThree, 20, 20);
}

float[] calcArm(int mouseXPosition,int mouseYPosition,int preferredRotation, int angle)
{
  vectorPointThreeX = segmentLength * cos(radians(-(float)angle));
  vectorPointThreeY = segmentLength * sin(radians(-(float)angle));
  pointTwoXPosition = (float)mouseXPosition - vectorPointThreeX;
  pointTwoYPosition = (float)mouseYPosition - vectorPointThreeY;
  
  println(vectorPointThreeX);
  
  
  if (mouseXPosition <= xOrigin+(int)round(vectorPointThreeX)  ){
    mouseXPosition = xOrigin+(int)round(vectorPointThreeX) ;
  }
  else if (mouseYPosition >= yOrigin){
    mouseYPosition = yOrigin;
  }
  println(mouseXPosition);

    
  float pointTwoXComponent = pointTwoXPosition - xOrigin;
  float pointTwoYComponent = pointTwoYPosition - yOrigin;
  float radiusPointTwo = sqrt(sq(pointTwoXComponent) + sq(pointTwoYComponent));
      
  vectorPointTwoX = pointTwoXComponent / radiusPointTwo;
  vectorPointTwoY = pointTwoYComponent / radiusPointTwo;
  
  float limit = 2 * segmentLength - radiusPointTwo;
  
  if(limit < 0)
  {
      xOne = xOrigin + vectorPointTwoX * segmentLength;
      yOne = yOrigin + vectorPointTwoY * segmentLength;
      xTwo = xOrigin + vectorPointTwoX * segmentLength * 2;
      yTwo = yOrigin + vectorPointTwoY * segmentLength * 2;
      xThree = xTwo + vectorPointThreeX;
      yThree = yTwo + vectorPointThreeY;     
  } 
  else 
  {
      xOne = xOrigin + vectorPointTwoX * radiusPointTwo / 2;
      yOne = yOrigin + vectorPointTwoY * radiusPointTwo / 2;
      xTwo = pointTwoXPosition;
      yTwo = pointTwoYPosition;
      float normalMagnitude = -sqrt(sq(segmentLength)-sq(radiusPointTwo/2));
      
      if(preferredRotation < 0){
          normalMagnitude =- normalMagnitude; // Make it a negative number
      }
      xOne -= vectorPointTwoY * normalMagnitude;
      yOne += vectorPointTwoX * normalMagnitude;
      xThree = mouseXPosition;
      yThree = mouseYPosition;
  }
  thetaZeroGlobal = abs(round(degrees(atan((yOne-yOrigin)/(xOne-xOrigin)))));
  thetaZeroLocal = (int)thetaZeroGlobal;
  thetaOneGlobal = round(degrees(atan((yTwo-yOne)/(xTwo-xOne))));
  thetaOneLocal = (int)(thetaZeroGlobal - (float)thetaOneGlobal);
  thetaTwoLocal = angle + (int)round(thetaOneGlobal);
  

  
  //output
  float[] output = { thetaZeroLocal, thetaOneLocal, thetaTwoLocal, xThree, yThree};
  return output;
}

//void limits(){
//  fill(255,0,0);
//  strokeWeight(13);
//  stroke(255, 0, 0);
//  ellipse(xOrigin, yOrigin, segmentLength-20, segmentLength-20);
//  fill(0,255,0);
//  strokeWeight(14);
//  stroke(0, 255, 0);
//  arc(xOrigin, yOrigin, segmentLength-20, segmentLength-20, PI+HALF_PI, 2*PI, PIE);

//  fill(255,0,0);
//  strokeWeight(13);
//  stroke(255, 0, 0);
//  ellipse(xOne, yOne, segmentLength-20, segmentLength-20); fill(0, 255, 0);
//  strokeWeight(14);
//  stroke(0, 255, 0);
//  arc(xOne, yOne, segmentLength-20, segmentLength-20, radians(-thetaZeroGlobal),radians(-thetaZeroGlobal+150), PIE);
  
//  fill(255,0,0);
//  strokeWeight(13);
//  stroke(255, 0, 0);
//  ellipse(xTwo, yTwo, segmentLength-20, segmentLength-20); fill(0, 255, 0);
//  strokeWeight(14);
//  stroke(0, 255, 0);
//  arc(xTwo, yTwo, segmentLength-20, segmentLength-20, radians(thetaOneGlobal-45),radians(thetaOneGlobal+45), PIE);
//}



void mouseWheel(MouseEvent event){
  i = event.getCount();
  angle = angle + i;
}

void dashboard(){
  textSize(20);
  fill(0);
  text ("Gripper Coordinates", 200, 100);
  text ("(" + round(xThree - 100) + "," + round(500 - yThree) + ")" , 400, 100);
  text ("mm" , 500, 100);
  text ("angle 0", 300, 130);
  text (thetaZeroLocal , 420, 130);
  text ("degrees" , 500, 130);
  text ("angle 1", 300, 160);
  text (thetaOneLocal , 420, 160);
  text ("degrees" , 500, 160);
  text ("angle 2", 300, 190);
  text (thetaTwoLocal , 420, 190);
  text ("degrees" , 500, 190);
}