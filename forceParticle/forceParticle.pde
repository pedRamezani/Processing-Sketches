class Particle {
  private final PVector p, v;
  static private final int w = 16;
  static private final float lerp = 0.1;
  private final float speed;
  private final float angle;
  
  static private final int minB = 180;
  private final PVector rgb = new PVector(0.42, 1.0, 0.34);
  
  Particle(PVector p, float angle, float speed) {
    this.p = p;
    this.v = PVector.fromAngle(angle).setMag(speed);
    this.speed = speed;
    this.angle = angle;
  }
  
  void update() {
    p.add(v);
    p.x = (p.x + width + 3*w) % (width + 2*w) - w;
    p.y = (p.y + height + 3*w) % (height + 2*w) - w;
  }
  
  void draw() {
    float strokeVal = minB + speed % (255 - minB);
    stroke(strokeVal * rgb.x, strokeVal * rgb.y, strokeVal * rgb.z, 220);
    strokeWeight(w);
    point(p.x, p.y);
    noStroke();
  }
  
  void chase(PVector pos) {
    v.lerp(p.copy().sub(pos).setMag(-speed), lerp);
  }
  
  void reset(PVector pos) {
    p.set(pos);
    v.set(PVector.fromAngle(angle).setMag(speed));
  }
}

class DistanceParticle extends Particle {
  
  private final float distance;
  
  DistanceParticle(PVector p, float angle, float speed, float distance) {
    super(p, angle, speed);
    
    this.distance = distance;
    super.rgb.set(1.0, 0.42, 0.35);
  }
  
  void chase(PVector pos) {
    int modify = (super.p.copy().sub(pos).mag() <= distance) ? -1 : 1;
    super.v.lerp(super.p.copy().sub(pos).normalize().mult(-super.speed * modify), Particle.lerp);
  }
  
}

class TeleportParticle extends Particle {
  
  private final float distance;
  
  TeleportParticle(PVector p, float angle, float speed, float distance) {
    super(p, angle, speed);
    
    this.distance = distance;
    super.rgb.set(0.35, 0.42, 1.0);
  }
  
  void chase(PVector pos) {
    if (super.p.copy().sub(pos).mag() <= distance) super.p.set(random(0,width), random(0, height));
    //if (super.p.copy().sub(pos).mag() <= distance) super.p.add(super.v.copy().mult(10));
    super.chase(pos);
  }
  
}

class SquareParticle extends Particle {
  
  private final float distance;
  
  SquareParticle(PVector p, float angle, float speed, float distance) {
    super(p, angle, speed);
    
    this.distance = distance;
    super.rgb.set(0.88, 0.2, 0.88);
  }
  
  void chase(PVector pos) {
    int minD = min(width, height);
    float m = min(max((minD - super.p.x) / super.v.x, (- super.p.x + 1) / super.v.x), max((minD - super.p.y) / super.v.y, (- super.p.y + 1) / super.v.y));
    if (super.p.copy().sub(pos).mag() <= distance) super.p.add(super.v.copy().mult(m * 0.6));
    super.chase(pos);
  }
}

private ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(720,720);
  surface.setTitle("Particles!");
  //surface.setResizable(true);
  
  background(255);
 
  for (int i = 1; i <= 500; i++) {
    particles.add(new Particle(new PVector(random(0,width), random(0,height)), random(0, 2*PI), (i % 50) + 8));
    particles.add(new DistanceParticle(new PVector(random(0,width), random(0,height)), random(0, 2*PI), (i % 50) + 8, min(width, height)/4));
    //particles.add(new TeleportParticle(new PVector(random(0,width), random(0,height)), random(0, 2*PI), (i % 50) + 8, min(width, height)/8));
    //particles.add(new SquareParticle(new PVector(random(0,width), random(0,height)), random(0, 2*PI), (i % 50) + 8, min(width, height)/16));
  }
}

private final PVector mouseVector = new PVector();
private boolean follow = true;
void draw() {
  background(0);
  mouseVector.set((mouseX == 0) ? width/2 : mouseX , (mouseY == 0) ? height/2 : mouseY);
  for (Particle p : particles) {
    if (follow) p.chase(mouseVector);
    p.update();
    p.draw();
  }
}

void mouseClicked() {
  follow = !follow;
}

/*void mouseExited() {
  if (follow) {
    follow = false;
    for (Particle p : particles) {
      p.reset(new PVector(random(0,width), random(0,height)));
    }
  }
}*/
