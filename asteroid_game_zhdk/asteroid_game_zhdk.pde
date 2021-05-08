import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.net.*;

import peasy.PeasyCam;
import de.voidplus.leapmotion.*;

PeasyCam cam;
LeapMotion leap;

public HashMap<String, State> states = new HashMap<String, State>();
StateSingleton stateSingleton = StateSingleton.getInstance(this);

ObjectGenerator3D og;
Minim minim;

//gameengine --> logic and render function.
//lerp
//millis for animations.

public void settings(){
  delay(5000);
  fullScreen(P3D);
  pixelDensity(2);
}

public void setup() {
  
  //size(1200, 600, P3D);
  //fullScreen(P3D);
  frameRate(25);
  colorMode(HSB, 360, 100, 100);
  cam = new PeasyCam(this, 400);
  minim = new Minim (this);
  
  cam.setLeftDragHandler(null);
  cam.setRightDragHandler(null);
  cam.setCenterDragHandler(null);
  cam.setWheelHandler(null);
  
  this.stateSingleton.states.put("game", new GameState(this, minim));
  this.stateSingleton.states.put("start", new StartState(this));
  this.stateSingleton.states.put("end", new EndState(this));
  
  stroke(255);
  noFill();
  leap = new LeapMotion(this);
  og = new ObjectGenerator3D();
  hint(DISABLE_DEPTH_TEST);
}

public void draw() {
  this.stateSingleton.states.get(this.stateSingleton.getState()).draw();
  
  /*cam.beginHUD();
  fill(255);
  text(frameRate, 50, 50);
  cam.endHUD();*/
}

public void stop() {
  minim.stop();
  super.stop();
}
