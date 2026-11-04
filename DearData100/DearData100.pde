// Dear Data 100 - Football Passes 
// Each arrow is only one pass.
//   The small dot at the start of the arrow is where the pass starts
//   The top triangle of the arrow points to where the pass ENDED (End X, End Y).
// X and Y both go from 0 to 100.
// Green arrow = successful pass, red arrow = unsuccessful pass.

Pass[] passes = new Pass[100];

int successfulCount = 0;
int unsuccessfulCount = 0;

// Where the graph is on the screen 
float graphX = 80;
float graphY = 110;
float graphW = 480;
float graphH = 480;


void setup() {
  size(1100, 660);
  makePasses();
}


void draw() {
  background(255);

  drawTitle();
  drawGraph();

  // Draw the green arrows first and then the red ones on top so they are easy to see
  for (int i = 0; i < passes.length; i++) {
    if (passes[i].successful) {
      passes[i].display();
    }
  }
  for (int i = 0; i < passes.length; i++) {
    if (!passes[i].successful) {
      passes[i].display();
    }
  }

  drawExplanation();
}


// Use the data lists at the bottom of the file to make one Pass object for each pass
void makePasses() {
  for (int i = 0; i < 100; i++) {
    passes[i] = new Pass(i + 1, startXs[i], startYs[i], endXs[i], endYs[i], wasSuccessful[i]);

    if (wasSuccessful[i]) {
      successfulCount++;
    } else {
      unsuccessfulCount++;
    }
  }
}


// Turn a 0-100 X value into a pixel position
float toScreenX(float x) {
  return graphX + x / 100.0 * graphW;
}

// Turn a 0-100 Y value into a pixel position.
// On a graph, Y = 0 is at the BOTTOM, so this one counts upwards.
float toScreenY(float y) {
  return graphY + graphH - y / 100.0 * graphH;
}


// Draw only one arrow from (x1, y1) to (x2, y2).
// Green if the pass was successful, red if not.
void drawArrow(float x1, float y1, float x2, float y2, boolean successful) {
  if (successful) {
    stroke(40, 160, 60);
    fill(40, 160, 60);
  } else {
    stroke(220, 50, 50);
    fill(220, 50, 50);
  }

  // How long the arrow is
  float length = dist(x1, y1, x2, y2);

  if (length < 3) {
    // A pass that ended exactly where it started has no direction
    // so draw a small circle instead of drawing an arrow
    noFill();
    strokeWeight(2);
    ellipse(x1, y1, 12, 12);
  } else {
    // The line
    strokeWeight(1.5);
    line(x1, y1, x2, y2);

    // The dot at the start
    noStroke();
    ellipse(x1, y1, 5, 5);

    // The top of the arrow is a small triangle at the end of the line.
    // The triangle at the top is 10 pixels long or shorter if the arrow is very short.
    float head = 10;
    if (length < 10) {
      head = length;
    }

    float dx = (x2 - x1) / length;
    float dy = (y2 - y1) / length;

    // The back of the arrow head they go backwards from the top of the arrow
    float backX = x2 - dx * head;
    float backY = y2 - dy * head;

    // The two sides of the top they go sideways from the back left and right
    float sideX = -dy * head * 0.45;
    float sideY = dx * head * 0.45;

    triangle(x2, y2, backX + sideX, backY + sideY, backX - sideX, backY - sideY);
  }
}


void drawTitle() {
  fill(0);
  noStroke();
  textAlign(LEFT, TOP);
  textSize(28);
  text("Direction of my 100 football passes", 80, 20);
  textSize(15);
  text("Each arrow starts where a pass started and points to where it ended.", 80, 62);
}


// The grid and the axis numbers and the axis names
void drawGraph() {
  // Light grid lines and numbers at 0, 25, 50, 75, 100
  for (int v = 0; v <= 100; v += 25) {
    stroke(220);
    strokeWeight(1);
    line(toScreenX(v), graphY, toScreenX(v), graphY + graphH);   // up-and-down line
    line(graphX, toScreenY(v), graphX + graphW, toScreenY(v));   // across line

    fill(0);
    noStroke();
    textSize(13);
    textAlign(CENTER, TOP);
    text(v, toScreenX(v), graphY + graphH + 8);
    textAlign(RIGHT, CENTER);
    text(v, graphX - 10, toScreenY(v));
  }

  noFill();
  stroke(0);
  strokeWeight(2);
  rect(graphX, graphY, graphW, graphH);

  // Axis names
  fill(0);
  noStroke();
  textSize(15);
  textAlign(CENTER, TOP);
  text("X (0 - 100): along the length of the pitch", graphX + graphW / 2, graphY + graphH + 30);
  textAlign(LEFT, BOTTOM);
  text("Y (0 - 100): across the width of the pitch", graphX - 40, graphY - 12);
}


// The text on the right that explains everything about the data
void drawExplanation() {
  float x = 620;
  float y = 110;

  fill(0);
  noStroke();
  textAlign(LEFT, CENTER);

  textSize(20);
  text("About this data", x, y);
  y += 32;

  textSize(15);
  text("The data has 100 football passes.", x, y);
  y += 22;
  text("For each pass I have its start and end position on", x, y);
  y += 22;
  text("a 0 - 100 grid of the pitch, and whether it worked.", x, y);
  y += 34;

  textSize(20);
  text("How to read the graph", x, y);
  y += 32;

  textSize(15);
  text("One arrow = one pass.", x, y);
  y += 22;
  text("The dot at the back of the arrow is where the pass started.", x, y);
  y += 22;
  text("The triangle at the top of the arrow points to where the pass ended.", x, y);
  y += 22;
  text("A longer arrow = a longer pass.", x, y);
  y += 34;

  textSize(20);
  text("Key", x, y);
  y += 34;

  textSize(15);
  drawArrow(x, y, x + 60, y, true);
  fill(0);
  text("Green arrow = successful pass", x + 80, y);
  y += 32;

  drawArrow(x, y, x + 60, y, false);
  fill(0);
  text("Red arrow = unsuccessful pass", x + 80, y);
  y += 32;

  drawArrow(x + 30, y, x + 30, y, true);
  fill(0);
  text("Small ring = pass that ended where it started", x + 80, y);
  y += 44;

  // The success rate as a percentage 
  float rate = 100.0 * successfulCount / passes.length;

  textSize(20);
  text("Totals", x, y);
  y += 32;

  textSize(15);
  text("Total passes: " + passes.length, x, y);
  y += 22;
  text("Successful: " + successfulCount, x, y);
  y += 22;
  text("Unsuccessful: " + unsuccessfulCount, x, y);
  y += 22;
  text("Success rate: " + rate + "%", x, y);
}


// One Pass object = one pass from the spreadsheet
class Pass {
  int number;
  float startX, startY;
  float endX, endY;
  boolean successful;

  Pass(int number, float startX, float startY, float endX, float endY, boolean successful) {
    this.number = number;
    this.startX = startX;
    this.startY = startY;
    this.endX = endX;
    this.endY = endY;
    this.successful = successful;
  }

  // Draw this pass as an arrow from its start to its end
  void display() {
    drawArrow(toScreenX(startX), toScreenY(startY), toScreenX(endX), toScreenY(endY), successful);
  }
}



int[] startXs = {
  86, 18, 9, 76, 62, 25, 48, 82, 53, 51,
  42, 86, 94, 36, 33, 9, 77, 87, 73, 33,
  19, 13, 75, 39, 5, 18, 24, 5, 44, 15,
  21, 82, 56, 36, 80, 13, 90, 78, 29, 64,
  48, 59, 75, 35, 12, 63, 76, 12, 11, 70,
  35, 81, 71, 55, 14, 32, 36, 83, 89, 18,
  48, 37, 47, 75, 93, 23, 10, 76, 35, 47,
  39, 65, 34, 13, 73, 38, 45, 78, 73, 51,
  89, 57, 58, 43, 60, 91, 89, 16, 10, 85,
  36, 18, 11, 64, 61, 75, 36, 35, 47, 54
};

int[] startYs = {
  19, 91, 8, 30, 80, 94, 18, 38, 15, 78,
  15, 51, 92, 25, 92, 45, 45, 63, 38, 22,
  24, 54, 6, 87, 38, 85, 52, 81, 35, 67,
  89, 59, 90, 33, 33, 9, 67, 78, 17, 11,
  18, 28, 17, 26, 26, 41, 89, 79, 79, 15,
  56, 10, 45, 21, 6, 69, 52, 88, 18, 75,
  31, 11, 21, 95, 24, 60, 50, 57, 25, 57,
  25, 33, 33, 40, 47, 9, 60, 29, 92, 60,
  20, 46, 90, 56, 79, 32, 15, 35, 36, 78,
  23, 59, 76, 90, 83, 62, 86, 40, 45, 93
};

int[] endXs = {
  79, 22, 2, 90, 74, 18, 36, 98, 76, 38,
  4, 82, 98, 29, 42, 2, 77, 76, 70, 8,
  39, 12, 52, 33, 52, 23, 28, 2, 57, 33,
  23, 98, 54, 21, 87, 2, 79, 88, 27, 75,
  39, 51, 77, 35, 9, 78, 55, 2, 25, 28,
  48, 77, 47, 44, 17, 46, 35, 95, 56, 12,
  72, 35, 33, 60, 98, 17, 2, 98, 7, 72,
  15, 79, 25, 14, 37, 36, 47, 85, 90, 57,
  78, 51, 94, 13, 50, 98, 95, 2, 38, 92,
  6, 28, 23, 69, 88, 98, 45, 42, 7, 45
};

int[] endYs = {
  14, 71, 12, 39, 68, 86, 17, 42, 30, 67,
  23, 45, 98, 33, 98, 39, 45, 58, 50, 45,
  42, 58, 24, 88, 20, 89, 76, 72, 41, 76,
  82, 44, 98, 39, 41, 34, 78, 81, 16, 2,
  23, 18, 5, 20, 22, 52, 76, 98, 83, 51,
  62, 27, 45, 25, 2, 68, 57, 98, 11, 82,
  22, 7, 6, 86, 22, 59, 59, 36, 37, 79,
  24, 35, 33, 40, 40, 8, 42, 30, 98, 58,
  27, 51, 72, 50, 83, 57, 23, 22, 5, 78,
  46, 69, 67, 98, 90, 82, 90, 37, 22, 83
};

boolean[] wasSuccessful = {
  true, true, true, true, true, true, false, true, true, true,
  true, true, true, true, true, false, false, true, true, true,
  true, true, false, true, true, true, false, false, false, true,
  true, true, true, true, true, true, false, false, true, true,
  true, true, false, false, false, false, true, true, true, true,
  true, true, true, true, true, false, true, true, true, true,
  true, true, true, true, true, false, true, false, true, false,
  false, true, true, true, true, true, true, true, true, true,
  true, true, true, true, true, true, true, true, true, true,
  false, true, true, true, true, true, true, true, true, true
};
