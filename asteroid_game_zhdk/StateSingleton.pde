static class StateSingleton {
 
  private static StateSingleton inst;
  private static PApplet p;
  public HashMap<String, State> states = new HashMap<String, State>(); 
  private String state = "start";
  private int score;
 
  private StateSingleton() {
  } 
 
  static StateSingleton getInstance(PApplet papp) { 
    if (inst == null) {
      inst = new StateSingleton();
      p = papp;
    }
    return inst;
  }
  
  public void updateState(String name) {
    this.state = name;
  }
  
  public String getState() {
    return this.state;
  }
  
  public int getScore() {
    return this.score;
  }
  
  public void setScore(int score) {
    this.score = score;
  }
 
}
