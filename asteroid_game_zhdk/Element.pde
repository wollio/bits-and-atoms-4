public abstract class Element {
  protected PVector position;
  protected PVector velocity;
  protected PShape shape;
  public boolean delete;
  
  public Element(PVector pos, PVector velo) {
    this.position = pos;
    this.velocity = velo;
    if (this.velocity != null) {
      this.velocity.limit(100);
    }
    this.delete = false;
  }
  
  
  public abstract void render();
  protected abstract void updateState();
  
  public PVector getPosition() {
    return this.position;
  }
  
  public PVector getVelocity() {
    return this.velocity;
  }
  
  public PShape getShape() {
    return this.shape;
  }
}
