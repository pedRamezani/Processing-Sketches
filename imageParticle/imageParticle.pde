private PImage img;
private ArrayList<ImageParticle> particles = new ArrayList<ImageParticle>();
private DrawSettings settings;
private int prevMouseX = 0, prevMouseY = 0; 

class DrawSettings {
 private final int dimension;
 private int strokeWidth;
 
 DrawSettings(int dim, int w) {
   this.dimension = dim;
   this.strokeWidth = w;
 }
 
 void setWidth(int newWidth) {
  this.strokeWidth = newWidth; 
  println("New Width: " + this.strokeWidth);
 }
}

class ImageParticle {
  private final PVector p, v;
  private final DrawSettings settings;
  
  ImageParticle(PVector p, PVector v, DrawSettings settings) {
    this.p = p;
    this.v = v;
    this.settings = settings;
  }
  
  void update() {
    p.add(v);
    p.x = (p.x + width + 3*settings.strokeWidth) % (width + 2*settings.strokeWidth) - settings.strokeWidth;
    p.y = (p.y + height + 3*settings.strokeWidth) % (height + 2*settings.strokeWidth) - settings.strokeWidth;
  }
  
  void draw() {
    final int index = (floor(p.x) + floor(p.y)*img.width);
    final color rgb = (index >= 0)? img.pixels[index % settings.dimension] : 0;
    stroke(rgb);
    strokeWeight(settings.strokeWidth);
    point(p.x, p.y);
    noStroke();
  }
}

void setup() {
  size(500, 500);
  background(255);
  surface.setTitle("Image Particles!");
  //surface.setResizable(true);
  
  final int offset = 100;
  final int maxWindowDimension = min(displayWidth - offset, displayHeight - offset);
  img = loadImage("flamingo.jpg");
  float ratio = float(img.width) / float(img.height);
  surface.setSize(min(maxWindowDimension, floor(maxWindowDimension * ratio)), min(maxWindowDimension, floor(maxWindowDimension / ratio)));
  surface.setLocation((displayWidth - width)/2, offset/8);
  
  img.resize(width, height);
  img.loadPixels();
  settings = new DrawSettings(img.width * img.height, 4);
  
  for (int i = 1; i <= 250; i++) {
    particles.add(new ImageParticle(new PVector(random(0,width), random(0,height)), new PVector(random(-1, 1), random(-1, 1)), settings));
  }
}

void draw() {
  for (ImageParticle p : particles) {
    p.update();
    p.draw();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      settings.setWidth(min(settings.strokeWidth * 2, 512));
    } else if (keyCode == DOWN) {
      settings.setWidth(max(settings.strokeWidth / 2, 1));
    }
  }
}

void mousePressed() {
  prevMouseX = mouseX;
  prevMouseY = mouseY;
}

void mouseDragged() {
  noStroke();
  fill(215, 42, 30);
  rect(min(mouseX, prevMouseX), min(mouseY, prevMouseY), abs(mouseX - prevMouseX), abs(mouseY - prevMouseY));
}

void mouseReleased() {
  noStroke();
  fill(255);
  rect(min(mouseX, prevMouseX), min(mouseY, prevMouseY), abs(mouseX - prevMouseX), abs(mouseY - prevMouseY));
}
