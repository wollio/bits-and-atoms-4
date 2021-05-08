public class GameState extends State {
  
  Client myClient; 
  
  float widthTerrain;
  float heightTerrain;
  
  float startTime;
  
  PVector spaceshipDirection;
  Spaceship spaceship;
  AudioPlayer player;
  
  boolean isLoaded = false;
  
  int lvl = 0;
  
  private ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
  private ArrayList<Projectile> projectiles = new ArrayList();
  
  public GameState(PApplet context, Minim minim) {
    super("game", context);
    
    myClient = new Client(context, "127.0.0.1", 5204); 
    
    player = minim.loadFile("laser.wav");
    spaceship = new Spaceship(new PVector(0, height*1.2, 0));
  }

  public void setup() {
    if (this.isActive()) {
      this.startTime = millis();
    }
  }
  
  void mouseEvent(MouseEvent event) {
    if (event.getAction() == MouseEvent.CLICK && this.isActive()) {
      this.player.loop(0);
      this.projectiles.add(new Projectile(this.spaceship.position.copy(), new PVector(0, -60, 0)));
    }
  }
  
  void keyEvent(KeyEvent event) {
  }
  
  private PVector updatePlayerPosition() {
    
    PVector pp = new PVector(mouseX, mouseY);
    
    if (myClient.available() > 0) { 
      float[] data;
      String input = myClient.readString();
      input = input.substring(0,input.indexOf("\n"));  // Only up to the newline
      println(input);
      data = float(split(input, ':'));
      
      /*String[] parts = input.split(" ");
      data = new float[parts.length];
      for (int i = 0; i < parts.length; ++i) {
        float number = Float.parseFloat(parts[i]);
        //float rounded = (int) Math.round(number * 1000) / 1000f;
        data[i] = number;
      }*/
      
      
      println(data[0]);
      pp = new PVector(map(data[0], 0.2, 0.8, width, 0), map(data[1], 0, 0.6, height, 0));
    } 
    
    return pp;
  
  }
  
  public void draw() {
    
    PVector pp = updatePlayerPosition(); 
    
    lvl = (int) this.getCurrentScore() / 10000;
    
    if (random(-40 + lvl*2, 10) > 0) {
      int x = (int) random(this.spaceship.position.x - width/2, this.spaceship.position.x + width/2);
      int z = (int) random(this.spaceship.position.z - height, this.spaceship.position.z + height);
      asteroids.add(new Asteroid(new PVector(x, -height*2-lvl * 5, z), new PVector(random(-10, 10), random(20,50) + lvl * 5, random(-10, 10)), (int) random(30,200)));
    }
    
    spaceshipDirection = new PVector(map(pp.x, 0, width, -30, 30), 0,  map(pp.y, 0, height, 30, -30));
    spaceshipDirection.limit(10 + lvl);
    spaceshipDirection.limit(20);
    spaceship.updatePosition(spaceshipDirection);
    
    cam.lookAt(spaceship.position.x - width, -spaceship.position.z - 50, 0, 0);
    
    drawBackground(color(40, 100, 65));
    
    rotateX(PI/2); //-0.3
    
    translate(-width, -height);
    
    lights();
    spaceship.tiltY = map(pp.x, 0, width, -5, 5);
    spaceship.tiltX = map(pp.y, 0, height, -5, 5);
    spaceship.render();
    
    for(int i = 0; i < this.asteroids.size(); i++) {
      this.asteroids.get(i).render();
    }
    
    for (int i = 0; i < this.projectiles.size(); i++) {
      this.projectiles.get(i).render();
    }
    
    this.collisionDetecting();
    
    for(int i = 0; i < this.asteroids.size(); i++) {
      if(this.asteroids.get(i).delete) {
        this.asteroids.remove(this.asteroids.get(i));
      };
    }
    
    for (int i = 0; i < this.projectiles.size(); i++) {
       if(this.projectiles.get(i).delete) {
          this.projectiles.remove(this.projectiles.get(i));
        };
    }
    
    int score = (int) (millis() - startTime);
    //println(score);
    this.setCurrentScore(score);
    cam.beginHUD();
      pushStyle();
      textAlign(RIGHT, CENTER);
      text(this.getCurrentScore(), width - 50, 50);
      popStyle();
    cam.endHUD();
  }
  
  private void collisionDetecting() {
    Projectile p;
    Asteroid a;
    for (int j = 0; j < this.asteroids.size(); j++) {
      a = this.asteroids.get(j);
      for (int i = 0; i < this.projectiles.size(); i++) {
        p = this.projectiles.get(i);
        if (boxSphereCollision(a, p.getShape(), p.position)) {
          p.delete = true;
          a.delete = true;
        }
      }
      if (boxSphereCollision(a, spaceship.getShape(), spaceship.getPosition())) {
        this.asteroids.clear();
        this.projectiles.clear();
        this.setCurrentState("end");
      }
      
    }
  }
  
  private boolean boxSphereCollision(Asteroid a, PShape s, PVector position) {
    // get box closest point to sphere center by clamping
    float x = Math.max(position.x - s.getWidth() / 2, Math.min(a.position.x, position.x + s.getWidth() / 2));
    float y = Math.max(position.y - s.getHeight() / 2, Math.min(a.position.y, position.y + s.getHeight() / 2));
    float z = Math.max(position.z - s.getDepth() / 2, Math.min(a.position.z, position.z + s.getDepth() / 2));
  
    // this is the same as isPointInsideSphere
    double distance = Math.sqrt((x - a.position.x) * (x - a.position.x) +
                             (y - a.position.y) * (y - a.position.y) +
                             (z - a.position.z) * (z - a.position.z));
    
    return distance < a.size;
  }

}
