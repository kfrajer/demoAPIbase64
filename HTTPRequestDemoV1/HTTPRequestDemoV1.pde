//REFERENCES: https://forum.processing.org/one/topic/http-post-processing.html
//REFERENCES: https://forum.processing.org/two/discussion/14354/http-post-request-problem
//REFERENCES: https://forum.processing.org/two/discussion/18383/upload-image-to-webserver

//REFERENCES: https://forum.processing.org/two/discussion/22523/pimage-to-base64-for-api-upload
//REFERENCES: 
//REFERENCES: 


//INSTRUCTIONS:
//         *--
//         *--
//         *--
//         *--

//===========================================================================
// IMPORTS:
import http.requests.*;
import org.apache.commons.codec.binary.Base64;
import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

//===========================================================================
// FINAL FIELDS:


//===========================================================================
// GLOBAL VARIABLES:
//final String mainUrl="http://blue-fang.appspot.com/img";
final String mainUrl="http://localhost:8080/img";
final String getReq=mainUrl+"?id=when";
final String postReq=mainUrl;

String dataGet01;
String dataPost01;

String uri = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
PImage im;


//===========================================================================
// PROCESSING DEFAULT FUNCTIONS:

void settings() {
  size(400, 600);
}

void setup() {

  textAlign(CENTER, CENTER);
  rectMode(CENTER);


  fill(255);
  strokeWeight(2);

  GetRequest get1 = new GetRequest(getReq);
  get1.addHeader("Accept", "application/text");   //get.addHeader("Accept", "application/json");
  get1.send();  
  dataGet01=get1.getContent();

  //im = loadImage(uri);

  String encoded = "";
  String fn =dataPath("pic28.png");
  println("Loading", fn);
  File f = new File(fn);

  try {
    encoded = encodeToBase64(fn);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  //  img_data = data.split('data:image/png;base64,')[1]

  PostRequest post = new PostRequest(postReq);
  //post.addData("name", "Rune");
  //post.addFile("picLands", f);
  post.addData("data", "image/png;base64,"+encoded);
  post.send();
  dataPost01=post.getContent();

  noLoop();
}



void draw() {
  background(0);

  if (im!=null) {
    im.resize(50, 50);
    image(im, width/2, height/2);
  } else {
    background(200, 0, 0);
    println("Error loading image");
  }
}

void keyReleased() {
  //PImage img=null;
  try {
    String s = ("data:image/png;base64,");
    int idx = uri.indexOf(s);
    im=DecodePImageFromBase64(uri.substring(idx+s.length()));
    println("Decoded image", im.width, im.height);
  } 
  catch (IOException e) {
    println(e);
  }

  redraw();
}

void mouseReleased() {

  printContent("dataGet01", dataGet01);
  printContent("dataPost01", dataPost01);

  String[] list = {(dataPost01)};  //PApplet.urlDecode
  saveStrings("frompost.txt", list);

  //data=image%2Fpng%3Bbase64%2CiVBORw0KGgoAAAA
  //data=image/png;base64,iVBORw0KGgoAAAA

  redraw();
}



//===========================================================================
// OTHER FUNCTIONS:

void printContent(String label, String rxdata) {
  println("==================\n  RECEIVE begin, Response Content from \"" + label + "\":\n==================");
  println(rxdata);
  println("==================\n  RECEIVE end, size=" + rxdata.length() + "\n==================");
}

private String encodeToBase64(String fileLoc) throws IOException, FileNotFoundException {

  File originalFile = new File(fileLoc);
  String encodedBase64 = null;

  FileInputStream fileInputStreamReader = new FileInputStream(originalFile);
  byte[] bytes = new byte[(int)originalFile.length()];
  fileInputStreamReader.read(bytes);
  encodedBase64 = new String(Base64.encodeBase64(bytes));
  fileInputStreamReader.close();

  return encodedBase64;
}

public PImage DecodePImageFromBase64(String i_Image64) throws IOException
{
  PImage result = null;
  byte[] decodedBytes = Base64.decodeBase64(i_Image64);

  ByteArrayInputStream in = new ByteArrayInputStream(decodedBytes);
  BufferedImage bImageFromConvert = ImageIO.read(in);
  BufferedImage convertedImg = new BufferedImage(bImageFromConvert.getWidth(), bImageFromConvert.getHeight(), BufferedImage.TYPE_INT_ARGB);
  convertedImg.getGraphics().drawImage(bImageFromConvert, 0, 0, null);
  result = new PImage(convertedImg);

  return result;
}
