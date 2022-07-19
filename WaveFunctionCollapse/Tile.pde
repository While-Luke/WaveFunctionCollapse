class Tile implements Comparable<Tile>{
  PImage image;
  int rotation;
  String tile;
  String[] choices;
  boolean filled;
  
  public Tile(String[] c){
    choices = c;
    tile = null;
    filled = false;
    rotation = 0;
  }
  
  void fill(PImage i, String t, int rot){
     image = i;
     tile = t;
     filled = true;
     rotation = rot;
  }
  
  
  int compareTo(Tile other){
    if (this.choices.length < other.choices.length){
      return -1; 
    }
    return 1;
  }
}
