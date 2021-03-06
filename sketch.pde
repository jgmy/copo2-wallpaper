/* 
 * The original processing.js version of 
 * this script was made for
 * #programalaplaza 2015
 * and is available at:
 * http://programalaplaza.medialab-prado.es/#/editor/d315eb0a-4670-44e9-a179-7f497d36fb8b
 */
/* Invasión de copos de nieve */
/* José G. Moya Yangüela - Demasiado tarde para la edición de navidad--- */
/* Pero lo vamos a intentar... */


import android.app.WallpaperManager.*;
// normal mode or menu:
int modo=1;
// user selected fps rate
int fps=10;
// max number of flakes
int coposMax=255;
// position of main menu button
float btnleft,btntop,btnright,btnbottom;
// center of screen
float centerx;
 float centery;
 float angle[];
// Array of snow flakes
Copo copos[];
// Array of (secondary) menu buttons
Boton botones[];
// Stored configuration default
byte configuration[]={byte(coposMax),byte(fps)};
// Configuration loaded from file
byte conf2[];
// Is preview?
// This is needed since the 
// wallpaperPreview function is false
// after first mouse/touch event.
boolean isPre=false;
// Configuration file name
String filename="configuration.dat";


void setup (){
  // Load stored configuration
    if ((conf2=loadBytes(filename))
        ==null){
      /* do nothing */
    } else {
       configuration=conf2;
      coposMax=int(configuration[0]);
      fps=int(configuration[1]);
    }
    // Get preview state and store it.
    isPre=wallpaperPreview();
    // Get center.
    centerx=width/2;
    centery =height/2;
    // Initialize copos with empty
    copos=new Copo[0];
    // HSB so we can change bright without
    // changing color.
    colorMode(HSB);
    // Set framerate to stored fps
    frameRate(fps);
    //Initialize button position
    btnleft=0;
    btntop=0;
    btnright=0;
    btnbottom=0;
 }


 void draw (){
  background(0);
    switch (modo) {
      
      case 2:
        // Menu mode. Draw menu and flakes
        drawmenu();
      case 1:
      default:
        // default mode. Draw flakes.
        drawcopo();
      
    }
 }
 
 // Draw flakes
 void drawcopo(){
   int f;
   // Append a flake if less flakes than
   // coposMax
   if (copos.length<coposMax){
    copos=(Copo[]) append(copos,new Copo(random(width),random(height),random(50)));
   }
   
   for (f=0;f<copos.length;f++){
     /**/ copos[f].moverx(int((copos[f].lenmax/4)*cos(frameCount*PI/90)));
      copos[f].movery(int(abs(
          (copos[f].lenmax/4)
          *sin(frameCount*PI/90)
         )
      ));
     /* */
      copos[f].dibujar();
      copos[f].colorB--;
      if (copos[f].colorB<=0) {
        
       copos[f]=copos[copos.length-1];
       copos[copos.length-1]=new Copo(random(width),random(height),random(50));
      }
   }
   /* DEBUG START */
   /* text (
        str(wallpaperPreview())+" "+ str(isPre),
        width/2,
        height/2
    );
    */
    /* DEBUG END */
    // if is wallpaper preview and menu is
    // not shown, shou menu button.
    if (modo==1 && isPre){
      menu();
    }
 }


// Snow flake class
class Copo{
   int colorH;
   int colorS;
   int colorB;
   float cx;
   float cy;
   float lenmax;
   // lenght of each segment.
   int len[]={4,4,4,4};
   
   // Add distance to x
   void moverx(int dx){
     this.cx+=dx;
   }
   
   //Add distance to y
   void movery(int dy){
     this.cy+=dy;
   }
  
    // Constructor
    Copo(float icx,float icy,float ilenmax){
      this.colorH=int(random(255));
      this.colorS=int(random(255));
      this.colorB=100+int(random(100));
      this.cx=icx;
      this.cy=icy;
      this.lenmax=ilenmax;

    // Accumulated arm lenght
    int lenacum=0;
    lenacum =0;
    int l;
    //Split desired lenght between
    //4 parts
    for (l=0;l <4;l++){
        this.len [l]=int(random(0,this.lenmax-lenacum));
        lenacum+=len [l];
      }
    }
    
    // draw flake
    void dibujar(){
      
      stroke(color(this.colorH,this.colorS,this.colorB));
      float angle;
      for(angle=0;angle<2*PI;angle+=PI/3){
        
        
      line (this.cx,this.cy,this.cx+this.lenmax*cos (angle),this.cy+this.lenmax*sin (angle));
      this.brazo (this.cx,this.cy,angle,1);
    
    }
  }
  void brazo (float bx,float by,float angle,int nivel){
    line (bx, by, bx+len[nivel]*cos(angle-PI/6), by+len[nivel]*sin(angle-PI/6));
       if (nivel <3){
    this.brazo(bx+len[nivel]*cos(angle-PI/6), by+len[nivel]*sin(angle-PI/6), (angle-PI/6),nivel+1 );
    }
    line (bx, by, bx+len[nivel]*cos(angle+PI/6), by+len [nivel]*sin(angle+PI/6));
    if (nivel <3){
       this.brazo(bx + len[nivel]*cos(angle+PI/6), by+len[nivel]*sin(angle+PI/6), (angle+PI/6), nivel+1 );
    }
  }
   
 }
 
// Class to draw button and check its
// position.
class Boton {
  public float cx;
  public float cy; 
  public float radius;
  public String texto;
  public int code;
  
  // Constructor
  // There is no draw method, since the object
  // is re-constructed each frame, according
  // to current screen size/orientation.
  Boton(String btext, float bx, float by, float bradius, int bcode){
    pushStyle();
    noFill();
    stroke(255);
    this.cx=bx;
    this.cy=by;
    this.radius=bradius;
    this.texto=btext;
    this.code=bcode;
    // Draw it
    ellipseMode(RADIUS);
    ellipse(this.cx, this.cy, this.radius, this.radius);
    fill(255);
    textAlign(CENTER, CENTER);
    text(this.texto,cx,cy);
    popStyle();
  }
  
  // Check if xt and yt are inside button.
  public boolean check( float xt,float yt){
    if ( dist(xt, yt, this.cx, this.cy)< this.radius){
      return true;
    }
    return false;
  }
}

// Draw button to access menu.
void menu(){
  fill(255);
  textAlign(RIGHT);
  textSize(24*displayDensity);
  text("Administrar",width,height-150);
  btnleft=width-textWidth("Administrar");
  btntop=height-(textAscent()+150);
  btnright=width;
  btnbottom=height+textDescent()-150;
  rectMode(CORNERS);
  noFill(); stroke(255);
  rect(btnleft, btntop,btnright,btnbottom);
};

// Draw configuration menu
void drawmenu(){
  pushStyle();
  
  // Exit button
  fill(255);
  textAlign(RIGHT);
  textSize(24*displayDensity);
  text("Volver",width,height-150);
  btnleft=width-textWidth("Volver");
  btntop=height-(textAscent()+150);
  btnright=width;
  btnbottom=height+textDescent()-150;
  rectMode(CORNERS);
  noFill(); stroke(255);
  rect(btnleft, btntop,btnright,btnbottom);
  
  // Menu buttons and options
  textAlign(CENTER,CENTER);
  text("Max FPS: ", width/2, height/4);
  text(str(fps), width/2, height/4+2*textAscent());
  text("Real FPS: "+str(round(frameRate*10)/10), width/2, height/4+4*textAscent());
  text("Copos (Flakes): ", width/2, height/2);
  text(str(coposMax), width/2, height/2+2*textAscent());
  
  noFill();
  botones=new Boton[] {
    new Boton("-",width/2-(textWidth("00")+2*textAscent()), 
              height/4+2*textAscent(),
              textAscent(), 1),
    new Boton("+",width/2+textWidth("00")+2*textAscent(), 
              height/4+2*textAscent(),
              textAscent(), 2),
    new Boton("-",width/2-(textWidth("00")+2*textAscent()), 
              height/2+2*textAscent(),
              textAscent(), 3),
    new Boton("+",width/2+textWidth("00")+2*textAscent(), 
              height/2+2*textAscent(),
              textAscent(), 4)
  };
  
  popStyle();
}
void mousePressed(){
  
  if (isPre==false) return;
  if (modo==2) {
    // config menu.
    // check whether button is clicked
    // or not
    int code=-1;
    for (int f=0; f<botones.length; f++){
      if (botones[f].check(mouseX,mouseY)){
        code=botones[f].code;
        break;
      }
    }
    if (code>=0){
      switch(code){
        case 1:
           fps=max(5, fps-5);
           frameRate(fps);
           break;
        case 2:
           fps=min(30,fps+5);
           frameRate(fps);
           break;
        case 3:
           coposMax=max(15,coposMax-16);
           copos=(Copo[]) subset(copos,0,min(copos.length,coposMax));
           break;
        case 4:
           coposMax=min(255,coposMax+16);
           break;
      }
      configuration[0]=byte (coposMax);
      configuration[1]=byte (fps);
      saveBytes(filename,configuration);
    }
  }
  // All modes.
  // Check if button to enter/exit menu
  // Has been checked.
  if (mouseX>=btnleft && mouseX <= (btnright)){
    if (mouseY>= btntop && mouseY<= (btnbottom)) {
      modo=(modo==2) ? 1 :2;
    }
   }
}
 
 