
/* Invasión de copos de nieve */
/* José G. Moya Yangüela - Demasiado tarde para la edición de navidad--- */
/* Pero lo vamos a intentar... */


import android.app.WallpaperManager.*;
int modo=1;
int fps=10;
int coposMax=255;
float btnleft,btntop,btnright,btnbottom;
float centerx;
 float centery;
 float angle[];
Copo copos[];
Boton botones[];
byte configuration[]={byte(coposMax),byte(fps)};
byte conf2[];
boolean isPre=false;
String filename="configuration.dat";


void setup (){
    if ((conf2=loadBytes(filename))
        ==null){
      /* do nothing */
    } else {
       configuration=conf2;
      coposMax=int(configuration[0]);
      fps=int(configuration[1]);
    }
    isPre=wallpaperPreview();
    centerx=width/2;
    centery =height/2;
    copos=new Copo[0];
    colorMode(HSB);
    frameRate(fps);
    btnleft=0;
    btntop=0;
    btnright=0;
    btnbottom=0;
 }

 void draw (){
  background(0);
    switch (modo) {
      case 2: drawmenu();
      case 1:
      default: drawcopo();
      
    }
 }
 
 void drawcopo(){
   int f;
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
  
    if (modo==1 && isPre){
      menu();
    }
 }



class Copo{
   int colorH;
   int colorS;
   int colorB;
   float cx;
   float cy;
   float lenmax;
   void moverx(int dx){
     this.cx+=dx;
   }
   void movery(int dy){
     this.cy+=dy;
   }
  int len[]={4,4,4,4};

    Copo(float icx,float icy,float ilenmax){
      this.colorH=int(random(255));
      this.colorS=int(random(255));
      this.colorB=100+int(random(100));
     this.cx=icx;
     this.cy=icy;
     this.lenmax=ilenmax;


    int lenacum=0;
    lenacum =0;
    int l;
    for (l=0;l <4;l++){
        this.len [l]=int(random(0,this.lenmax-lenacum));
        lenacum+=len [l];
      }
    }
   
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
class Boton {
  public float cx;
  public float cy; 
  public float radius;
  public String texto;
  public int code;
  Boton(String btext, float bx, float by, float bradius, int bcode){
    pushStyle();
    noFill();
    stroke(255);
    this.cx=bx;
    this.cy=by;
    this.radius=bradius;
    this.texto=btext;
    this.code=bcode;
    ellipseMode(RADIUS);
    ellipse(this.cx, this.cy, this.radius, this.radius);
    fill(255);
    textAlign(CENTER, CENTER);
    text(this.texto,cx,cy);
    popStyle();
  }
  public boolean check( float xt,float yt){
    if ( dist(xt, yt, this.cx, this.cy)< this.radius){
      return true;
    }
    return false;
  }
}

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
void drawmenu(){
  pushStyle();
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
  
  if (mouseX>=btnleft && mouseX <= (btnright)){
    if (mouseY>= btntop && mouseY<= (btnbottom)) {
      modo=(modo==2) ? 1 :2;
    }
   }
}
 
 