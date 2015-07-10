//Use mouse for this simulation (check comment associated with mousePressed function

int x[] = { 
  0, 0, 0, 0
};
int y[] = {
  0, 0, 0, 0
};
float mesDist[] = {
  0, 0, 0
};
float est[] = {
  0, 0, 0
};
int dirlen = 8;
int dirMem[][] = { //direction Look up table
  {
    0, -1
  }
  , {
    1, 0
  }
  , {
    0, 1
  }
  , {
    -1, 0
  }
  , {
    1, -1
  }
  , {
    1, 1
  }
  , {
    -1, 1
  }
  , {
    -1, 1
  }
};
int[] corr1;
int[] corr2;
int[] result;
int sine[][];
Boolean start = true;
float best = 0;
int bestx = 0, besty = 0;
int ix = 0;
int estxy[] = {
  0, 0
};
int lastx = 0, lasty = 0;
float min = 0;
float locmin = 0;
int dir = 0;
int once = 0;

int freq = 100000;//Hz ADC freq-------------------------------------
float maxl = 0.5;//m maximal distance---------------------------------------
float maxt = maxl/340.29;
int ns = int(maxt*freq);
float ls = maxl/ns;

PrintWriter output;

void setup() {
  size(800, 600);
  ellipseMode(CENTER);
  frameRate(40);
  //println(maxl+", "+maxt+", "+ns+", "+ls);
  output = createWriter("k"+freq/1000+"Hz error.txt"); 
  estxy[0] = 0;
  estxy[1] = 0;
  lastx = 0;
  lasty = 0;
  min = 0;
  locmin = 0;
  dir = 0;
  once = 0;
  ix = 0;
  y[3] = 0;
  ns = ns*3;
  sine = new int[3][ns];
  corr1 = new int[ns*2];
  corr2 = new int[ns*2];
  //result = new int[ns*2];
  x[0] = 400;
  x[1] = 450;
  x[2] = 350;
  y[0] = 400;
  y[1] = 500;
  y[2] = 500; // initial microphone positions
}


void draw() {
  if (start) {
    background(255);
    grid();
    fill(255, 0, 0);
    ellipse(x[0], y[0], 10, 10);
    fill(0, 255, 0);
    ellipse(x[1], y[1], 10, 10);
    fill(0, 0, 255);
    ellipse(x[2], y[2], 10, 10);
    fill(200, 100, 30);
    ellipse(x[3], y[3], 5, 5);
  }
}


void keyPressed() { //If anz kez is pressed, error for everz spot in 40x40 grid is calculated and exported to .txt file
  for (int i = 0; i<40; i++) {
    for (int j = 0; j<40; j++) {
      x[3] = i*10+200;
      y[3] = j*10+200;
      estxy[0] = int(random(200, 600));
      estxy[1] = int(random(100, 500));
      once = 0;
      lastx = 0;
      lasty = 0;
      min = 0;
      locmin = 0;
      dir = 0;
      once = 0;
      best = 0;
      bestx = 0;
      besty = 0;
      start = false;
      mesDist[0] = 0;
      mesDist[1] = dist(x[1], y[1], x[3], y[3])-dist(x[0], y[0], x[3], y[3]);
      mesDist[2] = dist(x[2], y[2], x[3], y[3])-dist(x[0], y[0], x[3], y[3]);
      mesDist = float(distToSine());
      grid();
      distRandomPoint();
      estimate();
      output.print(dist(x[3], y[3], bestx, besty)/2+",");
      println((i*40+j)/16);
    }
    output.println();
  }
  output.flush();
  output.close();
  exit();
}


void mousePressed() {
  if (ix == 0 && y[3]!=0) { //First 3 clicks positions 3 microphones, 4th click positions sound source and 5th click activates gradient descent
    lastx = 0;
    lasty = 0;
    min = 0;
    locmin = 0;
    dir = 0;
    once = 0;
    best = 0;
    bestx = 0;
    besty = 0;
    start = false;
    background(255);
    line(0, 400, width, 400);
    fill(255, 0, 0);
    ellipse(x[0], y[0], 10, 10);
    fill(0, 255, 0);
    ellipse(x[1], y[1], 10, 10);
    fill(0, 0, 255);
    ellipse(x[2], y[2], 10, 10);
    fill(110);
    ellipse(x[3], y[3], 5, 5);
    estxy[0] = mouseX;
    estxy[1] = mouseY;
    fill(0);
    ellipse(estxy[0], estxy[1], 5, 5);
    mesDist[0] = 0;
    mesDist[1] = dist(x[1], y[1], x[3], y[3])-dist(x[0], y[0], x[3], y[3]);
    mesDist[2] = dist(x[2], y[2], x[3], y[3])-dist(x[0], y[0], x[3], y[3]);
    mesDist = float(distToSine());
    grid();
    distRandomPoint();
    estimate();
    //print(sqrt(sq(x[3]-bestx)+sq(y[3]-besty))/2+",");
  } else {
    //Dodaje 3 mikrofona
    x[ix] = mouseX;
    y[ix] = mouseY;
    ix++;
    if (ix>3) {
      //Dodaje izvor zvuka
      ix = 0;
      mesDist[0] = 0;
      mesDist[1] = sqrt(sq(x[3]-x[1])+sq(y[3]-y[1])) - sqrt(sq(x[3]-x[0])+sq(y[3]-y[0]));
      mesDist[2] = sqrt(sq(x[3]-x[2])+sq(y[3]-y[2])) - sqrt(sq(x[3]-x[0])+sq(y[3]-y[0]));
    }
  }
}

void grid() { //Draws grid
  for (int i = 0; i<8; i++) {
    for ( int j = 0; j<6; j++) {
      noFill();
      stroke(0);
      rect(i*100, j*100, 100, 100);
    }
  }
  strokeWeight(5);
  rect(200, 100, 400, 400);
  strokeWeight(1);
}


void distRandomPoint() { //Calculates difference in distance for each microphone, for random point
  for (int i = 0; i<3; i++) {
    est[i] = sq(estxy[0]-x[i])+sq(estxy[1]-y[i]);
  }
  min = sqrt(est[0]);
  est[2] = sqrt(est[2])-sqrt(est[0]);
  est[1] = sqrt(est[1])-sqrt(est[0]);
  est[0] = sqrt(est[0])-sqrt(est[0]);
}


int[] distToSine() {//Conerts distance difference into sine shift
  float dS1 = mesDist[1]/200;
  float dS2 = mesDist[2]/200;
  int sshift1 = int(dS1/ls);
  int sshift2 = int(dS2/ls);
  int[] dist = new int[3];
  for (int i = 0; i<3; i++) {
    for (int j = 0; j<ns; j++) {
      sine[i][j] = 0;
    }
  }
  for (int i = 0; i<ns; i++) {
    if (i>(ns/2-ns*0.1) && i<(ns/2+ns*0.1)) {
      float ang = (i-(ns/2-ns*0.1))*PI/(ns*0.2);
      float ang1 = (i-(ns/2-ns*0.1))*PI*20/(ns*0.2);
      sine[0][i] = int(120*sin(ang)*sin(ang1));
    }
  }
  for (int i = 0; i<ns; i++) {
    if (i-sshift1>=0 && i-sshift1<ns)
      sine[1][i-sshift1] = int(sine[0][i]+random(-5,5));
    if (i-sshift2>=0 && i-sshift2<ns)
      sine[2][i-sshift2] = int(sine[0][i]+random(-5,5));
    sine[0][i] += int(random(-5,5));
  }
  dist[0] = 0;
  dist[1] = int((crosscorr(sine[0], sine[1]) + 1/3)*ls*200);
  /*for (int j = 0; j<3; j++) { //used for ploting
    if(j==2){
      for (int i = 0; i<result.length; i++)
      print(result[i]+", ");
    }
    else
    for (int i = 0; i<ns; i++) {
      print(sine[j][i]+", ");
    }
    println(j+"aAaAaA");
  }*/
  dist[2] = int((crosscorr(sine[0], sine[2]) + 2/3)*ls*200);
  return dist;
}


int crosscorr(int[] signal1, int[] signal2) { //Does cross correlation of two input signals
  int tmax = 0, pos = 0, max = 0;

  for (int i = 0; i<ns*2; i++) {
    for (int j = 0; j<ns*2; j++) {
      corr1[j] = 0;
      corr2[j] = 0;
    }
    for (int j= 0; j<ns; j++) {
      if (i<ns) {
        corr1[i+j] = signal1[j];
        corr2[ns+j] = signal2[j];
      } else {
        corr1[ns+j] = signal1[j];
        corr2[ns*2-i+j] = signal2[j];
      }
    }
    tmax = 0;
    for ( int j = 0; j<ns*2; j++) {
      tmax += corr1[j]*corr2[j];
      //result[i] += corr1[j]*corr2[j];
    }
    if (tmax>max) 
    {
      max = tmax;
      pos = ns-i;
    }
  }
  return pos;
}


void estimate() { //Estimates sound source location with gradient descent
  noStroke();
  best = 0;
  lastx = 0;
  lasty = 0;
  once = 0;
  estxy[0] = 0;
  estxy[1] = 0;
  distRandomPoint();
  best = sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2]);
  for (int j = 0; j<4; j++) {
    Boolean gotovo = false;
    while (!gotovo) {
      direction();
      if (lastx!=estxy[0] || lasty!=estxy[1]) {
        if (once == 1) {
          lastx = estxy[0];
          lasty = estxy[1];
        } else if (once == 3) {
          once = 0;
        }
        once++;
        for (int i = 0; i<dirlen; i++) {
          if (dir == i) {
            estxy[0] += dirMem[i][0];
            estxy[1] += dirMem[i][1];
          }
        }
      } else {
        gotovo=true;
        distRandomPoint();
        locmin = sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2]);
        if (locmin<best) {
          best = locmin;
          bestx = estxy[0];
          besty = estxy[1];
        }
        //println("GOTOJO: "+estxy[0]+"+"+estxy[1]+'+'+locmin+'+');
        estxy[0] = int(random(200, 600));
        estxy[1] = int(random(100, 500));
      }
      fill(50);
      ellipse(estxy[0], estxy[1], 2, 2);
    }
  }
  fill(255, 0, 0); 
  ellipse(bestx, besty, 7, 7);
}

void direction() { //Finds direction in which error is smallest

  distRandomPoint();
  locmin = sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2]);

  for (int i = 0; i<dirlen; i++) {
    estxy[0] += dirMem[i][0];
    estxy[1] += dirMem[i][1];
    distRandomPoint();
    if (sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2])<locmin) {
      locmin=sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2]);
      dir=i;
    }
    estxy[0] -= dirMem[i][0];
    estxy[1] -= dirMem[i][1];
  }
}

