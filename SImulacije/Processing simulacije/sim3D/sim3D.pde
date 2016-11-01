
int dirlen = 18;
int dirMem[][] = {
  {
    1, 0, 0
  }
  , {
    -1, 0, 0
  }
  , {
    0, 1, 0
  }
  , {
    0, -1, 0
  }
  , {
    0, 0, 1
  }
  , {
    0, 0, -1
  }
  , {
    1, 1, 0
  }
  , {
    1, -1, 0
  }
  , {
    -1, 1, 0
  }
  , {
    -1, -1, 0
  }
  , {
    1, 0, 1
  }
  , {
    1, 0, -1
  }
  , {
    -1, 0, 1
  }
  , {
    -1, 0, -1
  }
  , {
    0, 1, 1
  }
  , {
    0, 1, -1
  }
  , {
    0, -1, 1
  }
  , {
    0, -1, -1
  }
};
int x[] = { 
  0, 0, 400, 400, 0
};
int y[] = {
  200, 200, 0, 400, 0
};
int z[] = {
  0, 400, 200, 200, 0
};
float mesDist[] = {
  0, 0, 0, 0
};
float est[] = {
  0, 0, 0, 0
};
int sine[][];
Boolean start = true;
float best = 0;
int bestxyz[] = {
  0, 0, 0
};
int ix = 0;
int estxyz[] = {
  0, 0, 0
};
int lastxyz[] = {
  0, 0, 0
};
float locmin = 0;
int dir = 0;
int once = 0;
int[] corr1;
int[] corr2;
int[] result;

int freq = 50000;//Hz
float maxl = 2.5;
float maxt = maxl/340.29;
int ns = int(maxt*freq);
float ls = maxl/ns;

PrintWriter output;

void setup() {
  size(100, 100);
  ellipseMode(CENTER);
  frameRate(40);
  for (int i = 0; i<3; i++) {
    estxyz[i] = 0;
    lastxyz[i] = 0;
  }
  locmin = 0;
  dir = 0;
  once = 0;
  ix = 0;
  ns = ns*3;
  sine = new int[4][ns];
  corr1 = new int[ns*2];
  corr2 = new int[ns*2];
  result = new int[ns*2];
  output = createWriter("asdf.txt");
}


void draw() {
}


void keyPressed() {
  for (int i = 0; i<25; i++) {
    for (int j = 0; j<25; j++) {
      for (int k = 0; k<25; k++) { 
        for (int l = 0; l<3; l++) {
          bestxyz[l] = 0;
          lastxyz[l] = 0;
          estxyz[l] = int(random(0, 400));
        }
        x[4] = i*4;
        y[4] = j*4;
        z[4] = k*4;
        locmin = 0;
        dir = 0;
        once = 0;
        best = 0;
        mesDist[0] = 0;
        mesDist[1] = dist(x[4], y[4], z[4], x[1], y[1], z[1]) - dist(x[4], y[4], z[4], x[0], y[0], z[0]);
        mesDist[2] = dist(x[4], y[4], z[4], x[2], y[2], z[2]) - dist(x[4], y[4], z[4], x[0], y[0], z[0]);
        mesDist[3] = dist(x[4], y[4], z[4], x[3], y[3], z[3]) - dist(x[4], y[4], z[4], x[0], y[0], z[0]);
        mesDist = float(distToSine());
        distRandomPoint();
        estimate();
        output.print(dist(x[4], y[4], z[4], bestxyz[0], bestxyz[1], bestxyz[2])+" ");
        println(i+" -- " +dist(x[4], y[4], z[4], bestxyz[0], bestxyz[1], bestxyz[2]));
      }
      output.print(",");
    }
    output.println();
  }
  output.flush();
  output.close();
  exit();
}


void mousePressed() {
  for (int i = 0; i<3; i++) {
    bestxyz[i] = 0;
    lastxyz[i] = 0;
    estxyz[i] = int(random(0, 400));
  }
  x[4] = 100;
  y[4] = 100;
  z[4] = 100;
  locmin = 0;
  dir = 0;
  once = 0;
  best = 0;
  mesDist[0] = 0;
  mesDist[1] = dist(x[4], y[4], z[4], x[1], y[1], z[1]) - dist(x[4], y[4], z[4], x[0], y[0], z[0]);
  mesDist[2] = dist(x[4], y[4], z[4], x[2], y[2], z[2]) - dist(x[4], y[4], z[4], x[0], y[0], z[0]);
  mesDist[3] = dist(x[4], y[4], z[4], x[3], y[3], z[3]) - dist(x[4], y[4], z[4], x[0], y[0], z[0]);
  mesDist = float(distToSine());
  distRandomPoint();
  estimate();
}


void distRandomPoint() { //Računa rastojanje za random tačku
  for (int i = 0; i<4; i++) {
    est[i] = dist(estxyz[0], estxyz[1], estxyz[2], x[i], y[i], z[i]);
  }
  est[3] -= est[0];
  est[2] -= est[0];
  est[1] -= est[0];
  est[0] -= est[0];
}


int[] distToSine() {//pretvara vreme u pomeraj sinusa
  float dS1 = mesDist[1]/200;
  float dS2 = mesDist[2]/200;
  float dS3 = mesDist[3]/200;
  int sshift1 = int(dS1/ls);
  int sshift2 = int(dS2/ls);
  int sshift3 = int(dS3/ls);
  int[] dist = new int[4];
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
      sine[1][i-sshift1] = int(sine[0][i]+random(-3, 3));
    if (i-sshift2>=0 && i-sshift2<ns)
      sine[2][i-sshift2] = int(sine[0][i]+random(-3, 3));
    if (i-sshift3>=0 && i-sshift3<ns)
      sine[3][i-sshift3] = int(sine[0][i]+random(-3, 3));
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
  dist[1] = int(crosscorr(sine[0], sine[1])*ls*200);
  dist[2] = int(crosscorr(sine[0], sine[2])*ls*200);
  dist[3] = int(crosscorr(sine[0], sine[3])*ls*200);
  return dist;
}


int crosscorr(int[] signal1, int[] signal2) {
  int tmax = 0, pos = 0, max = 0;

  for (int i = 0; i<ns*2; i++) {
    for (int j = 0; j<corr1.length; j++) {
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
    for ( int j = 0; j<corr1.length; j++) {
      tmax += corr1[j]*corr2[j];
      result[i] += corr1[j]*corr2[j];
    }
    if (tmax>max) 
    {
      max = tmax;
      pos = ns-i;
    }
  }
  return pos;
}


void estimate() { //Vrši estimaciju položaja izvora
  best = 0;
  once = 0;
  distRandomPoint();
  best = err();
  for (int j = 0; j<6; j++) {
    for (int i = 0; i<3; i++) {
      lastxyz[i] = -1000;
      estxyz[i] = int(random(0, 400));
    }
    Boolean gotovo = false;
    while (!gotovo) {
      direction();
      if (!(lastxyz[0]==estxyz[0] && lastxyz[1]==estxyz[1] && lastxyz[2]==estxyz[2])) {
        if (once == 1) {
          for (int i = 0; i<3; i++)
            lastxyz[i] = estxyz[i];
        } else if (once == 3) {
          once = 0;
        }
        once++;
        estxyz[0] += dirMem[dir][0];
        estxyz[1] += dirMem[dir][1];
        estxyz[2] += dirMem[dir][2];
      } else {
        gotovo=true;
        distRandomPoint();
        locmin = err();
        if (locmin<best) {
          best = locmin;
          for (int i = 0; i<3; i++)
            bestxyz[i] = estxyz[i];
        }
      }
    }
  }
}

void direction() { //Određuje smer kretanja u smeru smanjenja greke

  distRandomPoint();

  locmin = err();

  for (int i = 0; i<dirlen; i++) {
    estxyz[0] += dirMem[i][0];
    estxyz[1] += dirMem[i][1];
    estxyz[2] += dirMem[i][2];

    distRandomPoint();
    if (err()<locmin) {
      locmin=err();
      dir=i;
    }
    estxyz[0] -= dirMem[i][0];
    estxyz[1] -= dirMem[i][1];
    estxyz[2] -= dirMem[i][2];
  }
}

float err() {
  return sq(est[1]-mesDist[1]) + sq(est[2]-mesDist[2]) + sq(est[3]-mesDist[3]);
}

