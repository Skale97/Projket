int x[] = { 
  500, 0, 1000, 500
};
int y[] = {
  0, 550, 560, 1000
};
int z[] = {
  0, 1000, 1000, 0
};
float mesDist[] = {
  0, 0, 0, 0
};
float est[] = {
  0, 0, 0, 0
};
int bestx = 0, besty = 0, bestz = 0;

float alpha = 1, beta = -0.5, gama = 2, delta = 0.5;
float xr = 0, yr = 0, zr = 0, xe = 0, ye = 0, ze = 0, xc = 0, yc = 0, zc = 0, cx = 0, cy = 0, cz = 0;

float xest[] = {
  250, 250, 750, 750
};
float yest[] = {
  500, 500, 250, 750
};
float zest[] = {
  250, 750, 500, 500
};
PrintWriter output;
BufferedReader reader;
String line;
int c11, c12, c13, c21, c22, c23, c31, c32, c33;
void setup() {
  output = createWriter("NM.txt");
  reader = createReader("E:\\GitHub\\Projket\\Rezultati\\DataToCSV\\CC.txt");
}


void draw() {
  for (int i = 0; i<343; i++) {
    println(i);
    try {
      line = reader.readLine();
    }
    catch(IOException e) {
    }
    xe =  int(split(line, ',')[0]);
    ye =  int(split(line, ',')[1]);
    ze =  int(split(line, ',')[2]);
    c11 = int(split(line, ',')[3]);
    c12 = int(split(line, ',')[4]); 
    c13 = int(split(line, ',')[5]);
    c21 = int(split(line, ',')[6]);
    c22 = int(split(line, ',')[7]);
    c23 = int(split(line, ',')[8]);
    c31 = int(split(line, ',')[9]);
    c32 = int(split(line, ',')[10]);
    c33 = int(split(line, ',')[11]);
    output.print(xe+","+ye+","+ze+",");

    xest[0] = xest[1] = yest[2] = zest[0] = 250;
    xest[2] = xest[3] = yest[3] = zest[1] = 750;
    yest[0] = yest[1] = zest[2] = zest[3] = 500;
    xr = yr = zr = xe = ye = ze = xc = yc = zc = cx = cy = cz = 0;
    bestx = 0;
    besty = 0;
    bestz = 0;
    mesDist[0] = 0;
    mesDist[1] = c11*10;
    mesDist[2] = c12*10;
    mesDist[3] = c13*10;
    estimate();
    output.print(1.0*bestx/10+","+1.0*besty/10+","+1.0*bestz/10+",");

    xest[0] = xest[1] = yest[2] = zest[0] = 250;
    xest[2] = xest[3] = yest[3] = zest[1] = 750;
    yest[0] = yest[1] = zest[2] = zest[3] = 500;
    xr = yr = zr = xe = ye = ze = xc = yc = zc = cx = cy = cz = 0;
    bestx = 0;
    besty = 0;
    bestz = 0;
    mesDist[0] = 0;
    mesDist[1] = c21*10;
    mesDist[2] = c22*10;
    mesDist[3] = c23*10;
    estimate();
    output.print(1.0*bestx/10+","+1.0*besty/10+","+1.0*bestz/10+",");

    xest[0] = xest[1] = yest[2] = zest[0] = 250;
    xest[2] = xest[3] = yest[3] = zest[1] = 750;
    yest[0] = yest[1] = zest[2] = zest[3] = 500;
    xr = yr = zr = xe = ye = ze = xc = yc = zc = cx = cy = cz = 0;
    bestx = 0;
    besty = 0;
    bestz = 0;
    mesDist[0] = 0;
    mesDist[1] = c31*10;
    mesDist[2] = c32*10;
    mesDist[3] = c33*10;
    estimate();
    output.println(1.0*bestx/10+","+1.0*besty/10+","+1.0*bestz/10+",");
  }
  output.flush();
  output.close();
  exit();
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


void refleksija() {
  xr = cx + alpha*(cx - xest[3]);
  yr = cy + alpha*(cy - yest[3]);
  zr = cz + alpha*(cz - zest[3]);

  if ((funkcija(xr, yr, zr)<funkcija(xest[2], yest[2], zest[2])) && (funkcija(xr, yr, zr)>=funkcija(xest[0], yest[0], zest[0]))) {
    //println("-- Refleksija --");
    xest[3] = xr;
    yest[3] = yr;
    zest[3] = zr;
  } else  if (funkcija(xr, yr, zr)<funkcija(xest[0], yest[0], zest[0])) {
    prosirenje();
  } else if (funkcija(xr, yr, zr)>=funkcija(xest[2], yest[2], zest[2])) {
    kontrakcija();
  }
}


void prosirenje() {
  xe = cx + gama*(cx-xest[3]);
  ye = cy + gama*(cy-yest[3]);
  ze = cz + gama*(cz-zest[3]);

  if (funkcija(xe, ye, ze)<funkcija(xr, yr, zr)) {
    xest[3] = xe;
    yest[3] = ye;
    zest[3] = ze;
  } else {
    xest[3] = xr;
    yest[3] = yr;
    zest[3] = zr;
  }
}


void kontrakcija() {
  xc = cx + beta*(cx - xest[3]);
  yc = cy + beta*(cy - yest[3]);
  zc = cz + beta*(cz - zest[3]);

  if (funkcija(xc, yc, zc)<funkcija(xest[3], yest[3], zest[3])) {
    xest[3] = xc;
    yest[3] = yc;
    zest[3] = zc;
  } else
    skupljanje();
}


void skupljanje() {
  for (int i = 1; i<4; i++) {
    //print(i);
    xest[i] = xest[0] + delta*(xest[i] - xest[0]);
    yest[i] = yest[0] + delta*(yest[i] - yest[0]);
    zest[i] = zest[0] + delta*(zest[i] - zest[0]);
  }
}


void estimate() { 
  sorta();
  for (int i = 0; i<100; i++) { 
    sorta();
    if (i==49) {
      bestx = int(xest[0]);
      besty = int(yest[0]);
      bestz = int(zest[0]);
      if (xest[0]%10>=5) bestx++;
      if (yest[0]%10>=5) besty++;
      if (zest[0]%10>=5) bestz++;
    }
    cx = (xest[0]+xest[1]+xest[2])/3;
    cy = (yest[0]+yest[1]+yest[2])/3;
    cz = (zest[0]+zest[1]+zest[2])/3;
    refleksija();
  }
}