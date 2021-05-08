public abstract class State {
  
  private String name;
  private PApplet context;
  private StateSingleton currentState;
  private Star[] stars;
  PImage background = loadImage("background-new.png");
  
  public State(String name, PApplet context) {
    this.name = name;
    this.context = context;
    this.context.registerMethod("mouseEvent", this);
    this.context.registerMethod("keyEvent", this);
    this.currentState = StateSingleton.getInstance(context);
    
    this.stars = new Star[500];
    for (int i = 0; i < this.stars.length; i++) {
      this.stars[i] = new Star();
    }
  }
  
  abstract public void setup();
  
  abstract void draw();
  
  abstract void mouseEvent(MouseEvent event);
  abstract void keyEvent(KeyEvent event);
  
  protected void drawBackground(color c) {
    cam.beginHUD();
    translate(0, -200);
      background(c);
      translate(width/2, height/2);
      for (int i = 0; i < stars.length; i++) {
        stars[i].update();
        stars[i].show();
      }
    cam.endHUD();
  }
  
  protected void setCurrentState(String state) {
    this.currentState.state = state;
    this.currentState.states.get(state).setup();
  }
  
  protected String getCurrentState() {
    return this.currentState.state;
  }
  
  protected void setCurrentScore(int score) {
    this.currentState.setScore(score);
  }
  
  protected int getCurrentScore() {
    return this.currentState.getScore();
  }
  
  protected boolean isActive() {
    return this.name.equals(getCurrentState());
  }
  
  public String getName() {
    return this.name;
  }


}
