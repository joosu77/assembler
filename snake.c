#include <GL/gl.h>
#include <GL/freeglut.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include "deque.h"

#define SKAALA 50	// Määrab ühikruudu laiuse
#define H 11		// Määrab ruudustiku kõrguse
#define W 10		// Määrab ruudustiku laiuse
#define VAHE 200	// Määrab ussi liikumiste vahe millisekundites

char b[W][H];		// Ruudustik mida välja joonistatakse tähendustega:
                        // 'S' - ussi kehaosa
                        // 'B' - mari
                        //  0  - tühi koht 
int skoor = 0;		// Skooriloendur
int suund = 0;		// Näitab, mis suunas uss liigub
                        // 0 on paremal ning edasi läheb päripäeva
int eelSuund = 0; 	// Näitab, mis suunas uss enne nupuvajutust liikus
_Bool pause = 0;	// Näitab, kas mäng on pausile pandud
struct Deque* x_coords;	// Ussi kehaosade x koordinaadid
struct Deque* y_coords;	// Ussi kehaosade y koordinaadid
clock_t eelmine = 0;	// Näitab eelmise ussi liikumise ajahetke
 
 
/**
 * Kutsutakse välja iga kord kui klaviatuuri nuppe vajutatakse
 * * kui nupp on w, a, s, d, siis kontrollitakse, et ussi eelnev
 *   liikumissuund ei oleks vastupidine (muidu liiguks uss enda sisse)
 *   ning muudetakse liikumissuund ära
 * * kui nupp on c, lõpetatakse programm
 * * kui nupp on p, pannakse mäng pausile või võetakse pausilt ära
 */
void kbhandler(unsigned char nupp, int x, int y){
    switch (nupp){
        case 'd': if(eelSuund!=2)suund=0;break;
        case 'w': if(eelSuund!=1)suund=3;break;
        case 'a': if(eelSuund!=0)suund=2;break;
        case 's': if(eelSuund!=3)suund=1;break;
        case 'c': exit(0);
        case 'p': pause=!pause;
    };
}

/**
 * Joonistab marja ehk ringi antud koordinaatidele ruudustikus.
 * Ringi joonistamiseks võetakse umbes 60 punkti vahemikus [0,2pi)
 * ning pannakse need trigonomeetrilise manipulatsiooniga ringjoonele
 * ümber ruudu keskkoha.
 */
void marjaJoonistaja(float x,float y){
    for (float i = 0; i < 2*3.15; i += 0.1){
        glVertex2i(x + SKAALA * cos(i)/3 - SKAALA/2, y + SKAALA * sin(i)/3 - SKAALA/2);
    }
}

/**
 * Joonistab ühe ussi lüli antud koordinaatidele ruudustikus.
 * Ussi lüli on lihtsalt ruut seega võetakse kogum punkte ning
 * paigutatakse need 4 sirge peale, mis on kõik ruudu keskkohast
 * SKAALA/6 piksli kaugusel.
 */
void ussiJoonistaja(float x,float y){
    x -= SKAALA/2;
    y -= SKAALA/2;
    for (float i = 0; i < SKAALA/6; i += 0.1){
        glVertex2i(x+i, y+SKAALA/6);
        glVertex2i(x-i, y+SKAALA/6);
        glVertex2i(x+SKAALA/6, y-i);
        glVertex2i(x+SKAALA/6, y+i);
        glVertex2i(x+i, y-SKAALA/6);
        glVertex2i(x-i, y-SKAALA/6);
        glVertex2i(x-SKAALA/6, y-i);
        glVertex2i(x-SKAALA/6, y+i);
    }
}

/**
 * Funktsioon, mis joonistab pildi ekraanile
 */
void display() {
    glClear(GL_COLOR_BUFFER_BIT);		// Tühjendab ekraani

    // Liigutan rasteri alla serva ning kirjutan sinna skoori
    glRasterPos2f(-SKAALA/2, -SKAALA/2);
    glutBitmapString(GLUT_BITMAP_HELVETICA_18, "Skoor: ");
    char skoorStr[20];
    sprintf(skoorStr, "%d", skoor);
    glutBitmapString(GLUT_BITMAP_HELVETICA_18, skoorStr);
    glRasterPos2f(-SKAALA/2, SKAALA*(H+1));
    glutBitmapString(GLUT_BITMAP_HELVETICA_18, "Liikumine: w/a/s/d    Paus: p    Lahku m4ngust: c");
    

    glBegin(GL_POINTS);				// Alustab punktide joonistamisrežiimi
    // Joonistab ruudustiku ekraanile:
    for (float i = W; i <= W*SKAALA; i += 0.1){
        for (float j = 0; j <= H; j++){
            glVertex2i(i, H+j*SKAALA);
        }
    }
    for (float i = H; i <= H*SKAALA; i += 0.1){
        for (float j = 0; j <= W; j++){
            glVertex2i(W+j*SKAALA, i);
        }
    }
    // Joonistab ussi lülid ja marja ekraanile:
    for (int i = 1; i <= W; i++){
        for (int j = 1; j <= H; j++){
            switch (b[i-1][j-1]){
                case 'B': marjaJoonistaja(W + i*SKAALA, H + j*SKAALA);break;
                case 'S': ussiJoonistaja(W + i*SKAALA, H + j*SKAALA);break;
            };
        }
    }
    glEnd();
    glFlush();
}

/**
 * Funktsioon, mida kutsutakse pidevalt välja lõputus tsüklis
 * ning mis sisaldab mängu loogikat
 */
void idle(void){
    // Ootab, et eelmisest liikumisest saaks piisavalt aega mööda
    // ja et mäng ei oleks pausil:
    if ((clock() - eelmine)*1000/CLOCKS_PER_SEC > VAHE && !pause){
        // Võtan ussi pea koordinaadid ning initsialiseerin pea
        // uue asukoha koordinaadid:
        int peaX = piilu_pead(x_coords);
        int peaY = piilu_pead(y_coords);
        int uusX = peaX;
        int uusY = peaY;
        // Olenevalt suunast liigutan pea uut asukohta vastavasse suunda:
        switch (suund){
            case 0: uusX++;break;
            case 1: uusY--;break;
            case 2: uusX--;break;
            case 3: uusY++;break;
        }
        // Kontrollin et uss ei sõitnud vastu pead ega söönud oma saba ära:
        if (uusX<0 || uusX >= W || uusY<0 || uusY>= H || b[uusX][uusY]=='S'){
            // Uss sai surma, mäng ootab 2 sekundit et oleks aega skoori
            // vaadata ning seejärel sulgub
            while((clock() - eelmine)/CLOCKS_PER_SEC < 2);
            exit(0);
        } else if (b[uusX][uusY]=='B') {
            // Uss sõi marja ära ehk skoori tõstetakse ning
            // marjale genereeritakse uus asukoht
            skoor++;
            int bx = rand()%W;
            int by = rand()%H;
            // Asukohta genereeritakse niikaua uuesti kuni leitakse tühi ruut
            // Kui tühjad ruudud otsa saavad ehk mäng on võidetud, jääb see lõputusse tsüklisse
            while (b[bx][by]!=0){
                bx = rand()%W;
                by = rand()%H;
            }
            b[bx][by]='B';
        } else {
            // Kui marja ei söödud, jääb uss lühemaks ehk
            // ussi kerest viimane lüli kustutatakse ära
            b[vota_saba(x_coords)][vota_saba(y_coords)]=0;
        }
        // Uus pea pannakse ussi külge
        lykka_pahe(x_coords, uusX);
        lykka_pahe(y_coords, uusY);
        b[uusX][uusY] = 'S';
        
        eelmine = clock();
        
        // Uuendatakse pilti
        glutPostRedisplay();
        eelSuund = suund;
    }
    
}


int main( int argc, char** argv ) {

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE);    	// Initsialiseerin ühevärvilise režiimi
    glutInitWindowSize(W*SKAALA,H*SKAALA);      // Määran akna suuruse
    glutInitWindowPosition(100,100);     	// Paigutan akna kuskile
    glutCreateWindow("Ussimang");
    
    glClearColor(0,0,0,1);			// Määran tausta mustaks
    glColor3f(0,1,0);				// Määran joonistamise värvi roheliseks
    glPointSize(1);				// Määran joonistustiheduse üheks
    // Initsialiseerib 2D pinna:
    gluOrtho2D(-SKAALA,(W+1)*SKAALA,-SKAALA,(H+2)*SKAALA);
    srand(time(NULL));				// Initsialiseerin rng seemne

    glutKeyboardFunc(kbhandler);		// Määran klaviatuuri käitleja funktisooni
    glutDisplayFunc(display);            	// Määran pildi joonistamisfunktsiooni
    glutIdleFunc(idle);				// Määran taustafunktsiooni
    
    // Algatan ussikeha:
    x_coords = loo_deque();
    lykka_pahe(x_coords, 1);
    y_coords = loo_deque();
    lykka_pahe(y_coords, 1);

    // Initsialiseerin ruudustiku nullideks:
    for (int i=0;i<W;i++){
        for (int j=0;j<H;j++){
            b[j][i]=0;
        }
    }
    
    // Panen ussi ja marja ruudustikku:
    b[1][1]='S';
    b[5][5]='B';

    // Algatan programmi:
    glutMainLoop();
    return 0;

}
