BufferedReader reader;
PrintWriter outputcc;
PrintWriter outputgd;
String line;

void setup() {
  reader = createReader("E:\\GitHub\\Projket\\Rezultati\\M-x20y20z20data.txt");
  outputcc = createWriter("checkcc.txt"); 
  outputgd = createWriter("checkgd.txt");
}

void draw() {
  for (int x = 20; x<=80; x+=10) {
    for (int y = 20; y<=80; y+=10) {
      for (int z = 20; z<=80; z+=10) {
        reader = createReader("E:\\GitHub\\Projket\\Rezultati\\data\\x"+x+"\\M-x"+x+"y"+y+"z"+z+"data.txt");
        outputcc.print(x+","+y+","+z+",");
        outputgd.print(x+","+y+","+z+",");
        for (int n = 0; n<=52; n++) {
          try {
            line = reader.readLine();
            if (n==5 || n==8 || n==11 || n==22 || n==25 || n==28 || n==39 || n==42 || n==45) {
              println(x+", "+y+", "+z);
              outputcc.print(split(line, ' ')[2]+",");
            } else if (n==14 || n==31 || n==48) {
              outputgd.print(split(split(line, ' ')[1], 'c')[0]+",");
              outputgd.print(split(split(line, ' ')[3], 'c')[0]+",");
              outputgd.print(split(split(line, ' ')[5], 'c')[0]+",");
            }
          }
          catch(IOException e) {
          }
        }
        outputcc.println();
        outputgd.println();
      }
    }
  }
  outputcc.flush();
  outputcc.close();
  outputgd.flush();
  outputgd.close();
  exit();
} 