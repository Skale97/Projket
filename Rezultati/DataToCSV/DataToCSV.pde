BufferedReader reader;
PrintWriter output;
String line;
int n = 0;

void setup() {
  reader = createReader("E:\\GitHub\\Projket\\Rezultati\\M-x20y20z20data.txt");
  output = createWriter("check.txt"); 
  output.print("20,20,20");
}

void draw() {
  if (n<=52) {
    try {
      line = reader.readLine();
    }
    catch(IOException e) {
    }
    if (n==5 || n==8 || n==11 || n==22 || n==25 || n==28 || n==39 || n==42 || n==45) {
      println(split(line, ' ')[2]+"CC");
      output.print(split(line, ' ')[2]);
    } else if (n==14 || n==31 || n==48) {
      println("0: "+split(split(line, ' ')[1], 'c')[0]);
      println("1: "+split(split(line, ' ')[3], 'c')[0]);
      println("2: "+split(split(line, ' ')[5], 'c')[0]);

      output.print(split(split(line, ' ')[1], 'c')[0]);
      output.print(split(split(line, ' ')[3], 'c')[0]);
      output.print(split(split(line, ' ')[5], 'c')[0]);
    }
    n++;
  } else 
  {
    output.flush();
    output.close();
  }
} 