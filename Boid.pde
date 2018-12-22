class Boid {
  PVector pos;
  PVector vel;
  PVector acc;
  int number;
  float maxForce;
  float maxSpeed = 5;
  float minSpeed = 0.5;

  int viewRadius = 80;

  Boid(int n) {
    int x = (int)random(0, screenWidth);
    int y = (int)random(0, screenHeight);

    number = n;

    pos = new PVector(x, y);
    //pos.setMag(0);

    int[] possibilities = {-2, -1, 1, 2};
    vel = PVector.random2D();
    //vel.setMag(random(0.001));


    acc = PVector.random2D();
    acc.setMag(0.01);

    maxForce = 0.02;
  }

  Boid(int n, int x, int y) {

    number = n;

    pos = new PVector(x, y);
    //pos.setMag(0);
    int[] possibilities = {-2, -1, 1, 2};
    vel = PVector.random2D();
    vel.setMag(random(1, 3));
    vel.setMag(random(0.001));


    acc = PVector.random2D();
    acc.setMag(0.01);
  }

  PVector align(Boid[] neighbours) {
    PVector avgVel = new PVector();
    int nearbyNeighbours = 0;

    for (Boid neighbour : neighbours) {
      if (neighbour != this && this.pos.dist(neighbour.pos)<viewRadius) {
        avgVel.add(neighbour.vel);
        nearbyNeighbours++;
      }
    }

    if (nearbyNeighbours > 0) {
      avgVel = avgVel.div(nearbyNeighbours);
      //this.vel = avgVel;
      return steer(avgVel);
    }

    return vel;
  }

  void flock (Boid[] boids) {
    PVector alignment = this.align(boids);
    PVector cohesion = this.cohere(boids);
    PVector separation = this.separate(boids);
    acc.add(alignment);
    acc.add(cohesion);
    //acc.add(separation);
  }

  PVector steer(PVector desiredVelocity) {
    desiredVelocity.setMag(maxSpeed);
    PVector steeringForce = desiredVelocity.sub(vel);

    steeringForce.limit(this.maxForce);
    return steeringForce;
  }

  PVector cohere(Boid[] boids) {
    PVector avgPos = new PVector();
    int nearbyNeighbours = 0;

    for (Boid boid : boids) {
      if (boid != this && this.pos.dist(boid.pos)<viewRadius) {
        avgPos.add(boid.pos);
        nearbyNeighbours++;
      }
    }

    if (nearbyNeighbours>0) {
      avgPos.div(nearbyNeighbours);
      //get vector in direction of avg pos
      avgPos.sub(pos);
      avgPos.setMag(maxSpeed);
      avgPos.sub(vel);
      avgPos.limit(maxForce);
      
      return avgPos;
    }
    
    return pos;
  }
  
  PVector separate(Boid[] boids) {
    PVector avgVel = new PVector();
    int nearbyNeighbours = 0;
    
    for (Boid boid : boids) {
      if (boid != this && pos.dist(boid.pos) < viewRadius) {
        PVector displacementBetweenBoids = PVector.sub(pos, boid.pos);
        displacementBetweenBoids.mult(1/pos.dist(boid.pos));
        avgVel.add(displacementBetweenBoids);
        nearbyNeighbours++;
      }
    }
    
    if (nearbyNeighbours > 0) {
      avgVel.div(nearbyNeighbours);
      avgVel.setMag(maxSpeed);
      avgVel.sub(vel);
      avgVel.limit(maxForce);
      return avgVel;
    }
    
    return vel;
  }

  void update() {
    //constrain(vel.x, 0, 0.01);
    //constrain(vel.y, 0, 0.01);
    vel.limit(3);
    pos.add(vel);
    vel.add(acc);
    acc.set(0,0);


    if (pos.x > screenWidth) {
      pos.x = 0;
    }
    if (pos.x < 0) {
      pos.x = screenWidth;
    }
    if (pos.y < 0) {
      pos.y = screenHeight;
    }
    if (pos.y > screenHeight) {
      pos.y = 0;
    }
  }

  void render() {
    stroke(255);
    fill(255);
    //text(""+number, pos.x, pos.y);
    ellipse(pos.x, pos.y, 2,2);
  }
}
