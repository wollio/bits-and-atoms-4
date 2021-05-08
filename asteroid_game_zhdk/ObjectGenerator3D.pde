public class ObjectGenerator3D {

  private ObjectGenerator3D() {}
  
  public void compass() {    
    stroke(0, 100, 100);
    line(-300, 0, 0, 300, 0, 0);
    text("+x", 300, 0, 0);
    text("-x", -330, 0, 0);
    
    stroke(120, 100, 100);
    line(0, -300, 0, 0, 300, 0);
    text("+y", 0, 330, 0);
    text("-y", 0, -300, 0);
    
    stroke(240, 100, 100);
    line(0, 0, -300, 0, 0, 300);
    text("+z", 0, 0, 330);
    text("-z", 0, 0, -300);
  }
  
  public void triangle(int width1, int width2, int h) {
    push();
    translate(-width1/2,-width2/2,-h);
    //base
    rect(0,0,width1,width2);
    beginShape();
    vertex(0, 0, 0);
    vertex(width1/2, width2/2, h);
    vertex(width1, 0, 0);
    endShape();
    beginShape();
    vertex(width1, 0, 0);
    vertex(width1/2, width2/2, h);
    vertex(width1, width2, 0);
    endShape();
    beginShape();
    vertex(0, width2, 0);
    vertex(width1/2, width2/2, h);
    vertex(width1, width2, 0);
    endShape();
    beginShape();
    vertex(0, width2, 0);
    vertex(width1/2, width2/2, h);
    vertex(0, 0, 0);
    endShape();
    pop();
  }
  
}
