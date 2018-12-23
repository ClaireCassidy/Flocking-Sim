int screenWidth = 1280;
int screenHeight = 720;

PImage boidSprite;

Boid[] boids;

void setup() {
    size(1280, 720);
    
    //frameRate(10);
    
    boids = new Boid[100];
    
    for (int i=0; i<boids.length; i++) {
       boids[i] = new Boid(i); 
    }
    
    boidSprite = loadImage("boid.png");
}

void draw() {
  background(0);
  
  for (Boid boid: boids) {
    boid.flock(boids);
    boid.update();
    boid.render();
  }
}

void keyPressed() {
  if (key == 'q') {
     exit(); 
  }
}
