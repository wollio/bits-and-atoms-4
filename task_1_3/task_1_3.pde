/**
Task 3 Interactive Paint

a) Combine brightest point tracking with the webcam capture to track 
the brightest point in your webcam video.

b) Create an own drawing software that is controlled by the light 
of your smartphone flashlight.

Think about additional features you could implement!

@author David Wollschlegel <david@wollschlegel.com>
*/
import processing.video.*;
String[] cameras = Capture.list();
PVector moonPos = new PVector(0, 0);
float brightestValue = 0.0;

Capture cam;

void setup() {
  size(640, 480, FX2D);
  cam = new Capture(this, 640, 480, cameras[0]);
  cam.start();
}

void draw() {
  if (cam.available()) {
    cam.read();
  }
  cam.filter(BLUR, 6);
  //image(cam, 0, 0);
  
  
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++) {
      float btns = brightness(cam.get(x, y));
      if (btns > brightestValue) {
        moonPos = new PVector(x, y);
        brightestValue = btns;
      } 
    }
  }
  
  if (brightestValue > 253) {
    circle(moonPos.x, moonPos.y, 30);
  }
  
  brightestValue = 0.0;
  
  
  
}
