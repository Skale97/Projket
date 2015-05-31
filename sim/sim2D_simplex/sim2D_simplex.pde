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
int dirMem[][] = {
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
int bestx = 0, besty = 0;
int ix = 0;

int freq = 1000000;//Hz -------------------------------------
float maxl = 3;//m ---------------------------------------
float maxt = maxl/340.29;
int ns = int(maxt*freq);
float ls = maxl/ns;

float alpha = 1, beta = 0.5, gama = 2, theta = 0.5;
float xr = 0, yr = 0, xe = 0, ye = 0, xc = 0, yc = 0, cx = 0, cy = 0;

float xest[] = {
  200, 200, 300
};
float yest[] = {
  100, 200, 100
};
PrintWriter output;

void setup() {
  size(800, 600);
  ellipseMode(CENTER);
  frameRate(40);
  output = createWriter("k"+freq/1000+"Hz error.txt"); 
  ix = 0;
  y[3] = 0;
  ns = ns*3;
  sine = new int[3][ns];
  corr1 = new int[ns*2];
  corr2 = new int[ns*2];
  //result = new int[ns*2];
  x[1] = 400;
  x[2] = 200;
  x[0] = 600;
  y[1] = 100;
  y[2] = 500;
  y[0] = 500;/*
  x[0] = 400;
   x[1] = 450;
   x[2] = 350;
   y[0] = 400;
   y[1] = 500;
   y[2] = 500;*/
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

    ellipse(xest[0], yest[0], 10, 10);
    ellipse(xest[1], yest[1], 10, 10);
    ellipse(xest[2], yest[2], 10, 10);
  } else {

    ellipse(xest[0], yest[0], 10, 10);
    ellipse(xest[1], yest[1], 10, 10);
    ellipse(xest[2], yest[2], 10, 10);
  }
}


void keyPressed() { //Resetuje sve
  for (int i = 0; i<40; i++) {
    for (int j = 0; j<40; j++) {
      x[3] = i*10+200;
      y[3] = j*10+200;
      bestx = 0;
      besty = 0;
      start = false;
      mesDist[0] = 0;
      mesDist[1] = dist(x[1], y[1], x[3], y[3])-dist(x[0], y[0], x[3], y[3]);
      mesDist[2] = dist(x[2], y[2], x[3], y[3])-dist(x[0], y[0], x[3], y[3]);
      mesDist = float(distToSine());
      grid();
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
  if (ix == 0 && y[3]!=0) { //resetuje sve, postavlja random tačku i vrši estimaciju
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
    mesDist = float(distToSine());
    grid();
    estimate();
    ellipse(bestx, besty, 5, 5);
    print(sqrt(sq(x[3]-bestx)+sq(y[3]-besty))/2+",");
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


void grid() { //Crta mrežu
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


int[] distToSine() {//pretvara vreme u pomeraj sinusa
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
      sine[0][i] = int(120*sin(ang)*sin(ang1)+random(-5, 5));
    }
  }
  for (int i = 0; i<ns; i++) {
    if (i-sshift1>=0 && i-sshift1<ns)
      sine[1][i-sshift1] = sine[0][i];
    if (i-sshift2>=0 && i-sshift2<ns)
      sine[2][i-sshift2] = sine[0][i];
  }
  /* for (int j = 0; j<2; j++) {
   for (int i = 0; i<ns; i++) {
   print(sine[j][i]+", ");
   }
   println(j+"aAaAaA");
   }/*
   println(dS1+", mat, "+dS2);
   println(crosscorr(sine[0], sine[1])*ls+", cc, "+crosscorr(sine[0], sine[2])*ls);*/
  dist[0] = 0;
  dist[1] = int((crosscorr(sine[0], sine[1]) + 1/3)*ls*200);
  dist[2] = int((crosscorr(sine[0], sine[2]) + 2/3)*ls*200);
  return dist;
}


int crosscorr(int[] signal1, int[] signal2) {
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
      //  result[i] += corr1[j]*corr2[j];
    }
    if (tmax>max) 
    {
      max = tmax;
      pos = ns-i;
    }
  }
  return pos;
}



float funkcija(float x1, float y1) {
  float err = 0;
  for (int i = 0; i<3; i++) {
    est[i] = sq(x[i]-x1)+sq(y[i]-y1);
  }
  est[2] = sqrt(est[2])-sqrt(est[0]);
  est[1] = sqrt(est[1])-sqrt(est[0]);
  est[0] = sqrt(est[0])-sqrt(est[0]);
  err = (sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2]));
  return err;
}


void menja(int a, int b) {
  float t = xest[a];
  xest[a] = xest[b];
  xest[b] = t;
  t = yest[a];
  yest[a] = yest[b];
  yest[b] = t;
}


void sorta() {
  if (funkcija(xest[2], yest[2])<funkcija(xest[0], yest[0]))
    menja(2, 0);
  if (funkcija(xest[1], yest[1])<funkcija(xest[0], yest[0]))
    menja(1, 0);
  if (funkcija(xest[2], yest[2])<funkcija(xest[1], yest[1]))
    menja(2, 1);
}


void skupljanje() {
  xest[1] = xest[0] + beta*(xest[1]-xest[0]);
  yest[1] = yest[0] + beta*(yest[1]-yest[0]);
  xest[2] = xest[0] + beta*(xest[2]-xest[0]);
  yest[2] = yest[0] + beta*(yest[2]-yest[0]);
}


void prosirenje() {
  xe = cx + gama*(xr-cx);
  ye = cy + gama*(yr-cy);

  if (funkcija(xe, ye)<funkcija(xr, yr)) {
    xest[2] = xe;
    yest[2] = ye;
  } else {
    xest[2] = xr;
    yest[2] = yr;
  }
}


void kontrakcija() {
  if (funkcija(xest[1], yest[1])<=funkcija(xr, yr) && funkcija(xr, yr)<funkcija(xest[2], yest[2])) {
    xc = cx + beta*(xr - cx);
    yc = cy + beta*(yr - cy);
    if (funkcija(xc, yc)<=funkcija(xr, yr)) {
      xest[2] = xc;
      yest[2] = yc;
    } else
      skupljanje();
  } else if (funkcija(xr, yr)>=funkcija(xest[2], yest[2])) {
    xc = cx + beta*(xest[2] - cx);
    yc = cy + beta*(yest[2] - cy);
    if (funkcija(xc, yc)<funkcija(xest[2], yest[2])) {
      xest[2] = xc;
      yest[2] = yc;
    } else
      skupljanje();
  }
}


void refleksija() {
  xr = cx + alpha*(cx - xest[2]);
  yr = cy + alpha*(cy - yest[2]);

  if ((funkcija(xr, yr)<funkcija(xest[1], yest[1])) && (funkcija(xr, yr)>=funkcija(xest[0], yest[0]))) {
    xest[2] = xr;
    yest[2] = yr;
  } else  if (funkcija(xr, yr)<funkcija(xest[0], yest[0])) {
    prosirenje();
  } else if (funkcija(xr, yr)>=funkcija(xest[1], yest[1])) {
    kontrakcija();
  }
}


void estimate() { 
  for (int i = 0; i<50; i++) { 
    sorta();
    cx = (xest[0]+xest[1])/2;
    cy = (yest[0]+yest[1])/2;
    refleksija();
    bestx = int((xest[0]+xest[1]+xest[2])/3);
    besty = int((yest[0]+yest[1]+yest[2])/3);
    fill(30*i);
    ellipse(xest[0], yest[0], 5, 5);
    ellipse(xest[1], yest[1], 5, 5);
    ellipse(xest[2], yest[2], 5, 5);
    println(bestx+", "+besty);
  }
}

