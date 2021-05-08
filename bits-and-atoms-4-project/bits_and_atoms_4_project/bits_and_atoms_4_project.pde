import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import processing.video.Capture;

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

 
// A reference to our box2d world
Box2DProcessing box2d;
Boundary wallBottom;
Boundary wallLeft;
Boundary wallRight;
Boundary wallPlayer;
Particle particle;

PVector location;  // Location of shape
PVector velocity;  // Velocity of shape
PVector gravity;   // Gravity acts at the shape's acceleration

Capture cam;
boolean start;
DeepVision vision;
ULFGFaceDetectionNetwork network;
ResultList<ObjectDetectionResult> detections;

public void setup() {
  size(640, 480, FX2D);
  smooth();
  colorMode(HSB, 360, 100, 100);

  println("creating network...");
  vision = new DeepVision(this);
  network = vision.createULFGFaceDetectorRFB320();

  println("loading model...");
  network.setup();

  println("setup camera...");
  cam = new Capture(this, "pipeline:autovideosrc");
  cam.start();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);

  // Turn on collision listening!
  box2d.listenForCollisions();
  
  particle = new Particle(random(width), -100, 20);

  wallBottom = new Boundary(width/2, height-5, width, 10, "bottom");
  wallLeft = new Boundary(0, height/2, 5, height, "left");
  wallRight = new Boundary(width-5, height/2, 5, height, "right");
  wallPlayer = new Boundary(width/2, height-20, 100, 30, "player");
}

public void draw() {
  background(55);
  

  if (cam.available()) {
    cam.read();
    start = true;
  }
  
  if (start) {
    // We must always step through time!
    box2d.step();
    
    image(cam, 0, 0);
  
    particle.display();
    
    if (cam.width == 0) {
      return;
    }
    
    detections = network.run(cam);
    
    strokeWeight(2f);
    
    stroke(200, 80, 100);
    for (ObjectDetectionResult detection : detections) {
      wallPlayer.x = detection.getX();
    }
    
    wallBottom.display();
    wallLeft.display();
    wallRight.display();
    wallPlayer.display();
    
  }

  
  

  surface.setTitle("Face Detector Test - FPS: " + Math.round(frameRate));
}

void mouseClicked() {
  particle = new Particle(mouseX, mouseY, 20);
}

// Collision event functions!
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  Boundary player;
  Particle ball;
  boolean isPlayerCollision = false;
  
  if (o1.getClass() == Boundary.class && o2.getClass() == Boundary.class) {
    return;
  }
  
  if (o1.getClass() == Boundary.class) {
    Boundary b = (Boundary) o1;
    if (b.name == "player"){
      player = b;
      isPlayerCollision = true;
    }
  } 
  // If object 2 is a Box, then object 1 must be a particle
  else if (o2.getClass() == Boundary.class) {
    Boundary b = (Boundary) o2;
    if (b.name == "player"){
      player = b;
      isPlayerCollision = true;
    }
  }

}

// Objects stop touching each other
void endContact(Contact cp) {
}
