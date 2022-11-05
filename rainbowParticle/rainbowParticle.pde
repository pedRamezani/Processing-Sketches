private static final ParticleMode mode = ParticleMode.Normal;
private static final float distance = 360;
enum ParticleMode {Normal, Circle, Square};

class Particle {
  private final PVector p, v, c;
  private final int w = 16;
  
  Particle(PVector p, PVector v, PVector c) {
    this.p = p;
    this.v = v;
    this.c = c;
  }
  
  void update() {
    p.add(v);
    p.x = (p.x + width + 3*w) % (width + 2*w) - w;
    p.y = (p.y + height + 3*w) % (height + 2*w) - w;
  }
  
  void draw() {
    final boolean shouldDraw;
    switch (mode) {
      case Normal:
        shouldDraw = true;
        break;
      case Circle:
        shouldDraw = p.copy().sub(c).mag() <= distance;
        break;
      case Square:
        PVector subV = p.copy().sub(c);
        shouldDraw = constrain(subV.x, -distance, distance) == subV.x && constrain(subV.y, -distance, distance) == subV.y;
        break;      
      default:
        shouldDraw = true;
        break;
    }
    if (shouldDraw) {
      final color hsl = floor(p.copy().sub(c).mag()) % 360;
      stroke(hsl,100,100);
      strokeWeight(w);
      point(p.x, p.y);
      noStroke();
    }
  }
}

private final ArrayList<Particle> particles = new ArrayList<Particle>();
private final PVector center = new PVector();
private boolean follow = false;


void setup() {
  fullScreen();
  //size(1080,1080);
  background(255);
  colorMode(HSB, 360, 100, 100);
  
  center.set(width/2,height/2);
  for (int i = 1; i <= 250; i++) {
    particles.add(new Particle(new PVector(random(0,width), random(0,height)), new PVector(random(-1, 1), random(-1, 1)), center));
  }
}

void draw() {
  for (Particle p : particles) {
    p.update();
    p.draw();
  }
}

void mouseClicked() {
  if (mode == ParticleMode.Normal) follow = !follow;
}

void mouseMoved() {
  if (follow) center.set(mouseX, mouseY);
}
