int x[] = { 
  0, 0, 400, 400, 0
};
int y[] = {
  0, 400, 200, 200, 0
};
int z[] = {
  200, 200, 0, 400, 0
};
float mesDist[] = {
  0, 0, 0, 0
};
float est[] = {
  0, 0, 0, 0
};
int[] corr1;
int[] corr2;
int[] result;
int sine[][];
Boolean start = true;
int bestx = 0, besty = 0, bestz = 0;
int ix = 0;

int freq = 500000;//Hz -------------------------------------
float maxl = 3;//m ---------------------------------------
float maxt = maxl/340.29;
int ns = int(maxt*freq);
float ls = maxl/ns;

float alpha = 1, beta = 0.5, gama = 2, theta = 0.5;
float xr = 0, yr = 0, zr = 0, xe = 0, ye = 0, ze = 0, xc = 0, yc = 0, zc = 0, cx = 0, cy = 0, cz = 0;

float xest[] = {
  0, 0, 100, 0
};
float yest[] = {
  0, 100, 0, 0
};
float zest[] = {
  0, 0, 0, 100
};
PrintWriter output;

void setup() {
  output = createWriter("freq:"+freq/1000+"kHz - error.txt"); 
  ix = 0;
  ns = ns*3;
  sine = new int[4][ns];
  corr1 = new int[ns*2];
  corr2 = new int[ns*2];
}


void draw() {
}


void keyPressed() {
  for (int i = 0; i<10; i++) {
    for (int j = 0; j<10; j++) {
      for (int k = 0; k<10; k++) {
        x[4] = i*10;
        y[4] = j*10;
        z[4] = k*10;
        bestx = 0;
        besty = 0;
        bestz = 0;
        start = false;
        mesDist[0] = dist(x[0], y[0], z[0], x[4], y[4], z[4]);
        mesDist[1] = dist(x[1], y[1], z[1], x[4], y[4], z[4])-mesDist[0];
        mesDist[2] = dist(x[2], y[2], z[2], x[4], y[4], z[4])-mesDist[0];
        mesDist[3] = dist(x[3], y[3], z[3], x[4], y[4], z[4])-mesDist[0];
        mesDist[0] = 0;
        mesDist = float(distToSine());
        estimate();
        output.print(dist(x[4], y[4], z[4], bestx, besty, bestz)/2+",");
        println(((i*40+j)/16)+":= "+dist(x[4], y[4], z[4], bestx, besty, bestz)/2);
      }
      output.print(" ");
    }
    output.println();
  }
  output.flush();
  output.close();
  exit();
}


void mousePressed() {
  if (ix == 0 && y[3]!=0) {
    bestx = 0;
    besty = 0;
    bestz = 0;
    start = false;
    mesDist = float(distToSine());
    estimate();
    print(dist(x[4], y[4], z[4], bestx, besty, bestz)/2+",");
  } else {
    //Dodaje 3 mikrofona
    x[ix] = mouseX;
    y[ix] = mouseY;
    ix++;
    if (ix>4) {
      //Dodaje izvor zvuka
      ix = 0;
      mesDist[0] = dist(x[0], y[0], z[0], x[4], y[4], z[4]);
      mesDist[1] = dist(x[1], y[1], z[1], x[4], y[4], z[4])-mesDist[0];
      mesDist[2] = dist(x[2], y[2], z[2], x[4], y[4], z[4])-mesDist[0];
      mesDist[3] = dist(x[3], y[3], z[3], x[4], y[4], z[4])-mesDist[0];
      mesDist[0] = 0;
    }
  }
}


int[] distToSine() {//pretvara vreme u pomeraj sinusa
  float dS1 = mesDist[1]/200;
  float dS2 = mesDist[2]/200;
  float dS3 = mesDist[3]/200;
  int sshift1 = int(dS1/ls);
  int sshift2 = int(dS2/ls);
  int sshift3 = int(dS3/ls);
  int[] dist = new int[4];
  for (int i = 0; i<4; i++) {
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
    if (i-sshift3>=0 && i-sshift3<ns)
      sine[3][i-sshift3] = sine[0][i];
  }
  dist[0] = 0;
  dist[1] = int((crosscorr(sine[0], sine[1]) + 1/4)*ls*200);
  dist[2] = int((crosscorr(sine[0], sine[2]) + 2/4)*ls*200);
  dist[3] = int((crosscorr(sine[0], sine[3]) + 3/4)*ls*200);
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
    }
    if (tmax>max) 
    {
      max = tmax;
      pos = ns-i;
    }
  }
  return pos;
}



float funkcija(float x1, float y1, float z1) {
  float err = 0;
  for (int i = 0; i<4; i++) {
    est[i] = dist(x[i], y[i], z[i], x1, y1, z1);
  }
  est[3] = est[3]-est[0];
  est[2] = est[2]-est[0];
  est[1] = est[1]-est[0];
  est[0] = 0;
  err = (sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2]) + sq(est[3]-mesDist[3]));
  return err;
}


void menja(int a, int b) {
  float t = xest[a];
  xest[a] = xest[b];
  xest[b] = t;
  t = yest[a];
  yest[a] = yest[b];
  yest[b] = t;
  t = zest[a];
  zest[a] = zest[b];
  zest[b] = t;
}


void sorta() {
  for (int j = 0; j<3; j++) {
    for (int i = 0; i<3; i++) {
      if (funkcija(xest[i], yest[i], zest[i])>funkcija(xest[i+1], yest[i+1], zest[i+1])) {
        menja(i, i+1);
      }
    }
  }
}


void skupljanje() {
  xest[1] = xest[0] + beta*(xest[1]-xest[0]);
  yest[1] = yest[0] + beta*(yest[1]-yest[0]);
  zest[1] = zest[0] + beta*(zest[1]-zest[0]);
  xest[2] = xest[0] + beta*(xest[2]-xest[0]);
  yest[2] = yest[0] + beta*(yest[2]-yest[0]);
  zest[2] = zest[0] + beta*(zest[2]-zest[0]);
}


void prosirenje() {
  xe = cx + gama*(xr-cx);
  ye = cy + gama*(yr-cy);
  ze = cz + gama*(zr-cz);

  if (funkcija(xe, ye, ze)<funkcija(xr, yr, zr)) {
    xest[2] = xe;
    yest[2] = ye;
    zest[2] = ze;
  } else {
    xest[2] = xr;
    yest[2] = yr;
    zest[2] = zr;
  }
}


void kontrakcija() {
  if (funkcija(xest[1], yest[1], zest[1])<=funkcija(xr, yr, zr) && funkcija(xr, yr, zr)<funkcija(xest[2], yest[2], zest[2])) {
    xc = cx + beta*(xr - cx);
    yc = cy + beta*(yr - cy);
    zc = cz + beta*(zr - cz);

    if (funkcija(xc, yc, zc)<=funkcija(xr, yr, zc)) {
      xest[2] = xc;
      yest[2] = yc;
      zest[2] = zc;
    } else
      skupljanje();
  } else if (funkcija(xr, yr, zr)>=funkcija(xest[2], yest[2], zest[2])) {
    xc = cx + beta*(xest[2] - cx);
    yc = cy + beta*(yest[2] - cy);
    zc = cz + beta*(zest[2] - cz);

    if (funkcija(xc, yc, zc)<funkcija(xest[2], yest[2], zest[2])) {
      xest[2] = xc;
      yest[2] = yc;
      zest[2] = zc;
    } else
      skupljanje();
  }
}


void refleksija() {
  xr = cx + alpha*(cx - xest[2]);
  yr = cy + alpha*(cy - yest[2]);
  zr = cz + alpha*(cz - zest[2]);

  if ((funkcija(xr, yr, zr)<funkcija(xest[1], yest[1], zest[1])) && (funkcija(xr, yr, zr)>=funkcija(xest[0], yest[0], zest[0]))) {
    xest[2] = xr;
    yest[2] = yr;
    zest[2] = zr;
    } else  if (funkcija(xr, yr, zr)<funkcija(xest[0], yest[0], zest[0])) {
    prosirenje();
  } else if (funkcija(xr, yr, zr)>=funkcija(xest[1], yest[1], zest[0])) {
    kontrakcija();
  }
}


void estimate() { 
  for (int i = 0; i<100; i++) { 
    print("X - ");
    printArray(xest);
    print("Y - ");
    printArray(yest);
    print("Z - ");
    printArray(zest);
    println("----------");
    sorta();
    cx = (xest[0]+xest[1])/2;
    cy = (yest[0]+yest[1])/2;
    cz = (zest[0]+zest[1])/2;
    refleksija();
    bestx = int((xest[0]+xest[1]+xest[2])/3);
    besty = int((yest[0]+yest[1]+yest[2])/3);
    bestz = int((zest[0]+zest[1]+zest[2])/3);
  }
}

