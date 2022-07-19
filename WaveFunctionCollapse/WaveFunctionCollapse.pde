import java.util.Arrays; //<>// //<>//
import java.util.PriorityQueue;
import java.util.*;

final int WINDOW_WIDTH = 800;
final int WINDOW_HEIGHT = 800;

final int GRID_WIDTH = 40;
final int GRID_HEIGHT = 40;

String folder = "maze";
boolean instant = false;
boolean step = true;

int tileW = WINDOW_WIDTH / GRID_WIDTH;
int tileH = WINDOW_HEIGHT / GRID_HEIGHT;

Tile[][] grid;
ArrayList<Rule> rules;

PriorityQueue<Tile> pq;

String[] tiles;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  noSmooth();
}

void setup() {
  frameRate(60);
  imageMode(CENTER);

  rules = new ArrayList();
  loadRules(folder);

  grid = new Tile[GRID_WIDTH][GRID_HEIGHT];
  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      grid[i][j] = new Tile(tiles);
    }
  }

  WFC();
}

void draw() {
  background(100);

  if(step) step();

  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      if (grid[i][j].image != null) {
        pushMatrix();
        translate(i * tileW + tileW/2, j * tileH + tileH/2);
        rotate(grid[i][j].rotation * PI/2);
        image(grid[i][j].image, 0, 0, tileW, tileH);
        popMatrix();
      }
    }
  }
}

void mouseReleased() {
  step();
}

void loadRules(String foldername) {
  BufferedReader reader = createReader(foldername + "/rules.txt");
  try {
    tiles = split(reader.readLine(), ",");
    String line = reader.readLine();
    String[] l;
    while (line != null) {
      l = line.split(",");
      if (l[0].equals("rule")) {
        rules.add(new Rule(l[1], loadImage(foldername + "/" + l[2]), l[3], l[4], l[5], l[6]));
      } else if (l[0].equals("rotation")) {
        rules.add(rot(rules.get(int(l[1])), l[2], int(l[3])));
      }
      line = reader.readLine();
    }
  } 
  catch(IOException e) {
    println("You smell");
  }
}

void WFC() {
  pq = new PriorityQueue();
  for (int i = 0; i < GRID_WIDTH; i++) {
    for (int j = 0; j < GRID_HEIGHT; j++) {
      pq.add(grid[i][j]);
    }
  }

  if (instant) {
    Tile t;
    String chosen;
    while (!pq.isEmpty()) {
      t = pq.poll();
      chosen = t.choices[int(random(t.choices.length))];
      t.fill(getRule(chosen).image, chosen, getRule(chosen).rotation);
      pq.clear();
      for (int i = 0; i < GRID_WIDTH; i++) {
        for (int j = 0; j < GRID_HEIGHT; j++) {
          if (!grid[i][j].filled) {
            calcChoices(i, j);
            pq.add(grid[i][j]);
          }
        }
      }
    }
  }
}

void calcChoices(int x, int y) {
  ArrayList<String> choices = new ArrayList(Arrays.asList(tiles));
  String c;
  if (y > 0 && grid[x][y-1].filled) {//up
    Iterator<String> it = choices.iterator();
    while (it.hasNext()) {
      c = it.next();
      if (!getRule(c).up.equals(getRule(grid[x][y-1].tile).down)) {
        it.remove();
      }
    }
  }
  if (y < GRID_HEIGHT-1 && grid[x][y+1].filled) {//down
    Iterator<String> it = choices.iterator();
    while (it.hasNext()) {
      c = it.next();
      if (!getRule(c).down.equals(getRule(grid[x][y+1].tile).up)) {
        it.remove();
      }
    }
  }
  if (x > 0 && grid[x-1][y].filled) {//left
    Iterator<String> it = choices.iterator();
    while (it.hasNext()) {
      c = it.next();
      if (!getRule(c).left.equals(getRule(grid[x-1][y].tile).right)) {
        it.remove();
      }
    }
  }
  if (x < GRID_WIDTH-1 && grid[x+1][y].filled) {//right
    Iterator<String> it = choices.iterator();
    while (it.hasNext()) {
      c = it.next();
      if (!getRule(c).right.equals(getRule(grid[x+1][y].tile).left)) {
        it.remove();
      }
    }
  }
  String[] cho = new String[choices.size()];
  for (int i = 0; i < choices.size(); i++) {
    cho[i] = choices.get(i);
  }
  grid[x][y].choices = cho;
}

Rule getRule(String t) {
  for (Rule r : rules) {
    if (r.tile.equals(t)) return r;
  }
  return null;
}

void step() {
  if (!pq.isEmpty()) {
    Tile t;
    String chosen;
    t = pq.poll();
    chosen = t.choices[int(random(t.choices.length))];
    t.fill(getRule(chosen).image, chosen, getRule(chosen).rotation);
    pq.clear();
    for (int i = 0; i < GRID_WIDTH; i++) {
      for (int j = 0; j < GRID_HEIGHT; j++) {
        if (!grid[i][j].filled) {
          calcChoices(i, j);
          pq.add(grid[i][j]);
        }
      }
    }
  }
}
