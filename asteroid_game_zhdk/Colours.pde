enum Colours 
{ 
    // This will call enum constructor with one 
    // String argument 
    DARK_PURPLE(-12112756), YELLOW(-5935616), ORANGE(230); 
  
    // declaring private variable for getting values 
    private int colour; 
  
    // getter method 
    public int getColour() 
    { 
        return this.colour; 
    } 
  
    // enum constructor - cannot be public or protected 
    private Colours(int colour) 
    { 
        this.colour = colour; 
    } 
}
