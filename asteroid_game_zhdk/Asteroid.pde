public class Asteroid extends Element {
  
  ObjectGenerator3D og = new ObjectGenerator3D();
  private float size;
  private color strokeColor;
  private boolean isExploding;
  
  //from rock
  private float[][][] points;
  private  float radius, rough, speed;
  private  int detail;
  private  boolean rebuild;
  private PImage skin;
  private PVector spin;
  private color colour;
  
  public Asteroid(PVector position, PVector velocity, int size) {
    super(position, velocity);
    this.size = size;
    this.strokeColor = color(0, 100, 0);
    this.shape = createShape(SPHERE, size);
    //this.shape.setFill(false);
    //this.sphere.setStroke(false);
    this.colour = color(random(275, 310), random(80, 100), random(20,40));
    
    //from rock
    this.radius = size;
    this.rough  = random(0.3, 1);
    this.detail = 30;
    this.spin   = new PVector(random(-PI, PI), random(-PI, PI), 0);
    this.speed  = random(0.2, 0.3);
    noiseSeed(frameCount);
    initPoints();
    initSkin();
  }
  
  protected void updateState() {
    this.position.add(this.velocity);
    if (this.position.y > 2000) {
      this.delete = true;
    }
  }
  
  public void render() {
    push();
    translate(this.position.x, this.position.y, this.position.z);
    //shape(this.shape);
    //og.compass();
    if(rebuild) { noLoop(); initPoints(); loop(); rebuild = false; }
    noStroke();
    rotateX(spin.x);
    rotateY(spin.y);
    rotateZ(spin.z += speed);
    for(int i = 0; i < points.length; i++)
    {
      float[][] pointSet = points[i];
      if(pointSet == null) continue;
      fill(colour);
      beginShape(TRIANGLE_STRIP);
      for(int j = 0; j < pointSet.length; j++)
      {
        float[] p = pointSet[j];
        vertex(p[0], p[1], p[2], p[3] * (skin.width - 1), p[4] * (skin.height - 1));
      }
      endShape();
      
    }
    pop();
    this.updateState();
  }
  
  public float getSize() {
    return this.size;
  }
  
  //From rock
  private void initPoints()
  {
    int i = 0;
    float uStep = 2.0 * PI / detail;
    float vStep = 1.0 * PI / detail;
    points = new float[int(sq(detail + 1))][4][6];
    for(float u = 0.0; u < TWO_PI; u += uStep)
    {
      for(float v = -HALF_PI; v < HALF_PI; v += vStep)
      {
        points[i][0] = getPoint(u +     0, v +     0); // Point as per equation
        points[i][1] = getPoint(u + uStep, v +     0); // Next point around
        points[i][2] = getPoint(u +     0, v + vStep); // Next point up
        points[i][3] = getPoint(u + uStep, v + vStep); // Next point up and around
        i++;
      }
    }
  }

  private void initSkin()
  {
    int d = 300;
    skin = createImage(d, d, RGB);
    skin.loadPixels();
    for(int i = 0; i < d; i++)
      for(int j = 0; j < d; j++)
        skin.pixels[i * d + j] = color(255 * noise(i / 5.0, j / 5.0));
    skin.updatePixels();
  }

  private float[] getPoint(float u, float v)
  {
    PVector p = new PVector(cos(v) * cos(u), cos(v) * sin(u), sin(v));
    float r = radius * ((1 - rough) + rough * 2 * noise(p.x + p.y, p.y + p.z, p.z + p.x));
    return new float[] { p.x * r, p.y * r, p.z * r, u / TWO_PI, (v + HALF_PI) / PI };
  }
}
