class Button {

  PVector position;
  int h;
  int w;
  String text;
  color bgColor = Colours.DARK_PURPLE.getColour();
  color textColor = Colours.YELLOW.getColour();
  
  public Button(PVector position, int w, int h, String text) {
    this.position = position;
    this.w  = w;
    this.h = h;
    this.text = text;
  }
  
  public void render() {
    
    push();
    translate(this.position.x, this.position.y);
    noStroke();
    rectMode(CENTER);
    fill(bgColor);
    rect(0,0,this.w, this.h);
    fill(textColor);
    textAlign(CENTER, CENTER);
    text(this.text, 0, 0);
    pop();
    
  }
  
  boolean isMouseHover(PVector mousePosition) {
    boolean res = mousePosition.x > this.position.x - w/2 && mousePosition.x < this.position.x + w/2 && mousePosition.y > this.position.y - h /2 && mousePosition.y < this.position.y + h/2;
    if (res) {
      this.bgColor = Colours.DARK_PURPLE.getColour();
      this.textColor =  Colours.YELLOW.getColour();
    } else {
      this.bgColor = Colours.YELLOW.getColour();
      this.textColor = Colours.DARK_PURPLE.getColour();
    }
    
    return res;
  }

}
