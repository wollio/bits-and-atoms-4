public class Spaceship extends Element {
 
  private PShape object;
  public float tiltY = 0;
  public float tiltX = 0;
  
  ArrayList<PShape> warpRings = new ArrayList<PShape>();
  
  public Spaceship(PVector position) {
    super(position, null);
    this.object = loadShape("ufo.obj");
    this.shape = createShape(BOX, 70, 70, 15);
  }
  
  protected void updateState() {
  
  }
  
  public void updatePosition(PVector direction) {
    this.position.add(direction);
  }
  
  public void render() {
    push();
    translate(position.x, position.y, position.z);
    warpRings.add(new PShape());
    //shape(this.shape);
    rotateY(radians(tiltY));
    rotateX(PI/2+radians(tiltX));
    lights();
    scale(0.1);
    this.object.rotateY(0.1);
    /*push();
    rotateX(PI/2);
      fill(0, 100, 100);
      og.triangle(size / 3, size / 3, size);
        push();
          translate(0, 0, -size-size/3);
          rotateX(PI);
          og.triangle(size / 3, size / 3, size / 3);    
        
        pop();
    pop();
    noFill();*/
    shape(this.object, 0, 0);
    pop();
  }
  
}
