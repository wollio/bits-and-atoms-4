/**
Task 1 - Find the Moon

Create a new processing sketch which loads this image and displays it. 
How can we find the position of the moon?

@author David Wollschlegel <david@wollschlegel.com>
*/
PImage img;
PVector moonPos; 
float brightesValue = 0.0;
void setup() {
  size(370, 1000);
  img = loadImage("moon.jpg");
  img.resize(0, width);
  println(img.width);
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      float btns = brightness(img.get(x, y));
      if (btns > brightesValue) {
        moonPos = new PVector(x, y);
        brightesValue = btns;
      } 
    }   
  }
 
  noFill();
  stroke(255, 0, 0);  
}

void draw() {
  background(0);
  image(img, 0, 0);
  circle(moonPos.x, moonPos.y, 30);
}
