public class EndState extends State {

  PFont pixelFont;
  Button b = new Button(new PVector(width/2, height/2 + 200), 200, 100, "restart");
  Button saveResult = new Button(new PVector(width/2, height /2 + 200), 200, 100, "save result");
  AudioPlayer song;
  BeatDetect beat;
  BeatListener bl;
  float cRadius;
  color c;
  Table table;
  String file = "highscores.csv";
  String playerName = "";
  boolean saved = false;
  
  String highName = "";
  int highScore = 0;
  
  public EndState(PApplet context) {
    super("end", context);
    pixelFont = createFont("font-pixel.ttf",18);
    this.table = loadTable(file, "header");
    this.retrieveDate();
  }
  
  public void setup() {
    this.saved = false;
    if (this.table == null) {
      this.createTable();
    }
    this.retrieveDate();
  }
  
  public void draw() {
    drawBackground(color(0,0,0));
    cam.beginHUD();      
      textFont(this.pixelFont);
      textAlign(CENTER, CENTER);
      textSize(25);
      text("game over", width/2, height/2 - 250);
      
      if (this.highScore > 0 && this.getCurrentScore() > this.highScore) {
        pushStyle();
        fill(Colours.YELLOW.getColour());
        text("new highscore", width/2, height / 2 -200); 
        popStyle();
      }
      
      textSize(40);
      text(this.getCurrentScore(), width/2, height/2 -150);
      textSize(20);
      
      if (this.saved) {
        text("Highscore: " + this.highScore + " by " + this.highName, width/2, height / 2 - 50);
        this.b.render();
      } else {
        text("enter name:\n" + playerName, width/2, height/2 -50);
        textSize(16);
        this.saveResult.render();
      }
      
    cam.endHUD();
  }
  
  public void mouseEvent(MouseEvent event) {
    PVector mousePos = new PVector(event.getX(), event.getY());
    if (b.isMouseHover(mousePos) && this.saved) {
      if (event.getAction() == MouseEvent.CLICK) {
        this.setCurrentState("game");
      }
    }
    
    if (saveResult.isMouseHover(mousePos) && !this.saved) {
      if (event.getAction() == MouseEvent.CLICK) {
        this.saveScore(this.getCurrentScore(), this.playerName);
        this.retrieveDate();
        this.saved = true;
      }
    }
  }
  
  void keyEvent(KeyEvent event) {    
    if (!this.saved && event.getAction() == KeyEvent.RELEASE && event.getKeyCode() == 8 && (this.playerName != null && this.playerName.length() > 0)) {
      this.playerName = this.playerName.substring(0, this.playerName.length()-1);
    } else if (event.getAction() == KeyEvent.TYPE) {
      this.playerName += event.getKey();
    }
  }
  
  void retrieveDate() {
    if (this.table == null) {
      this.createTable();
    }
    for (TableRow row : table.rows()) {
      if (this.highScore < row.getInt("Score")) {
        this.highScore = row.getInt("Score");
        this.highName = row.getString("Name");
      }
    }
  }
  
  void createTable() {
    table = new Table();
    table.addColumn("Score");
    table.addColumn("Name");
    saveTable(table, file);
  }
  
  private void saveScore(int score, String name) {
    TableRow newRow = table.addRow();
    newRow.setString("Name", name);
    newRow.setInt("Score", score);
    saveTable(table, file);
    this.table = loadTable(file, "header");
  } 
  
}
