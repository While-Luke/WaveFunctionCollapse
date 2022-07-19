class Rule {
  PImage image;
  int rotation;
  String tile;
  String up, right, down, left;

  public Rule(String t, PImage i, String u, String r, String d, String l) {
    image = i;
    rotation = 0;
    tile = t;
    up = u;
    right = r;
    down = d;
    left =l;
  }
  public Rule(String t, PImage i, int rot, String u, String r, String d, String l) {
    image = i;
    rotation = rot;
    tile = t;
    up = u;
    right = r;
    down = d;
    left =l;
  }
}

Rule rot(Rule r, String t, int rotation) {
  float count = rotation;
  Rule rule = new Rule(t, r.image, r.up, r.right, r.down, r.left);
  while (count > 0) {
    rule = new Rule(rule.tile, rule.image, rotation, rule.left, rule.up, rule.right, rule.down);
    count--;
  }
  return rule;
}
