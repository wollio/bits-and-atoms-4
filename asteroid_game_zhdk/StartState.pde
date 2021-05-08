public class StartState extends State {

  PFont pixelFont;
  Button b = new Button(new PVector(width/2, height/2), 200, 100, "start");
  AudioPlayer song;
  BeatDetect beat;
  BeatListener bl;
  float cRadius;
  color c;
  
  public StartState(PApplet context) {
    super("start", context);
    pixelFont = createFont("font-pixel.ttf",18);
    song = minim.loadFile("blade.mp3", 2048);
    song.loop();
    beat = new BeatDetect(song.bufferSize(), song.sampleRate());
    beat.setSensitivity(40);
    // make a new beat listener, so that we won't miss any buffers for the analysis
    bl = new BeatListener(beat, song);
    this.c = color(0, 0, 0);
  }
  
  public void setup() {
    
  }
  
  public void draw() {
    drawBackground(c);
    cam.beginHUD();
    
    // draw an orange rectangle over the bands in 
    // the range we are querying
    int lowBand = 20;
    int highBand = 25;
    // at least this many bands must have an onset 
    // for isRange to return true
    int numberOfOnsetsThreshold = 3;
    if ( beat.isRange(lowBand, highBand, numberOfOnsetsThreshold) )
    {
      c = color(0, 0, random(0,10));
      //rect(rectW*lowBand, 0, (highBand-lowBand)*rectW, height);
    }
      
      textFont(this.pixelFont);
      textAlign(CENTER, CENTER);
      textSize(45);
      text("flying saucer", width/2,height/2 - 200);
      textSize(32);
      this.b.render();
    cam.endHUD();
  }
  
  public void mouseEvent(MouseEvent event) {
    if (b.isMouseHover(new PVector(event.getX(), event.getY()))) {
      if (event.getAction() == MouseEvent.CLICK) {
        this.setCurrentState("game");
      }
    }
  }
  
  public void keyEvent(KeyEvent event) {
  }
  
  
}
