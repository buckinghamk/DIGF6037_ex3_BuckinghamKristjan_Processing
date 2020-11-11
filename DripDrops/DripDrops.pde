
/*
Based on DIGF 6037 Creation & Computation
   Kate Hartman & Nick Puckett

   Arduino to Processing - sending 12 capacitive pin values. 
   values are saved into an array
   simulated version of "onPress" and "onRelease"

 Based on this Lab on the ITP Physical Computing site: 
 https://itp.nyu.edu/physcomp/labs/labs-serial-communication/two-way-duplex-serial-communication-using-an-arduino/
 
 Based on Scale by Denis Grutze:
 https://processing.org/examples/scale.html
 
 Based on Processing Map Example:
 https://processing.org/examples/map.html
 
 Based on Processing SoundFile Example:
 https://processing.org/reference/libraries/sound/SoundFile.html
 Sound effects sourced from Sound Bible:
 http://soundbible.com/
 */
import processing.sound.*;  // import the Processing sound library
import processing.serial.*; // import the Processing serial library
Serial myPort;              // The serial port

int totalPins = 10;
int pinValues[] = new int[totalPins];
int pinValuesPrev[] = new int[totalPins];
int pinsPressed = 0;
int margin = 100;

float ellipseSize[] = new float[totalPins];
float backgroundShade = 255;

SoundFile drip[] = new SoundFile[totalPins];

void setup() {
  size(800,400);
  frameRate(30);
  
  // List all the available serial ports in the console
  printArray(Serial.list());
  for(int i = 0;i<pinValues.length;i++)
    {
        ellipseSize[i] = 0;
        drip[i] = new SoundFile(this, "drip" + (i + 1) + ".mp3"); //call sound files
    }
  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  // read incoming bytes to a buffer
  // until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}

void draw() 
{
  pinsPressed = 0;
  
  for(int i = 0;i<pinValues.length;i++)
  {
     if(pinValues[i]==1)
     {
       pinsPressed++;
     }
  }
  //map background shade to number of pins pressed
  backgroundShade = map(pinsPressed, 0, 10, 255, 0);
  background(backgroundShade);
    
  for(int i = 0;i<pinValues.length;i++)
  {
      if(pinValues[i]==1)
     {
      fill(0,0,200);  
      ellipseSize[i] = ellipseSize[i] + 0.5;
      ellipse(margin+(i*(width-(margin*2))/pinValues.length),height/2,ellipseSize[i],ellipseSize[i]);
     } 
   
   ///this triggers only once at the first frame of the touch
   //similar to onMousePress
   if((pinValues[i]==1)&&(pinValuesPrev[i]==0))
   {
     fill(0,0,150);
     ellipse(margin+(i*(width-(margin*2))/pinValues.length),height/2,30,30);
     drip[i].play();
   }
   
   //this triggers once onlyat that first frame of release
   //similar to onMouseRelease
   if((pinValues[i]==0)&&(pinValuesPrev[i]==1))
   {
      ellipseSize[i] = 0;
   }
      
  //save the previous value   
  pinValuesPrev[i] = pinValues[i];   
  }
 
}

void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    // println(myString);
    myString = trim(myString);
    pinValues = int(split(myString,','));

  }
  //printArray(pinValues);
}
