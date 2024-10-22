%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>
#include <string.h>

#define CAMPO 20

extern FILE* yyin; 

typedef struct {
    char* nombre;
    int vida;
    int posicionX;
    int posicionY;
    int contadorY;
    int furia;
} Jugador;



int turno = 1;
int movimientos = 0;

Jugador jugador1, jugador2;

Jugador* atacante = &jugador1;
Jugador* defensor = &jugador2;


void EvaluarVictoria();
void IncrementarMov();
bool AtaqueExitoso();
void validarBordes();
void ComprobarPosY();

void ImprimirEstado();
void imprimirUbicacionJugadores();
void limpiarConsola();

void ataqueEspecial();
void C_DEBIL();
void C_MEDIO();
void C_FUERTE();
void P_DEBIL();
void P_MEDIA();
void P_FUERTE();

void IZQ();
void DER();
void CORRER();
void RETIRARSE_Y_CORRER();
void RETIRARSE();

void AGACHARSE();
void SALTAR();
void ESQUIVAR();

void RODAR_IZQUIERDA();
void RODAR_DERECHA();
void CORRER_Y_RODAR();

void BURLA();
void CANCELAR_BURLA();

bool comparaStr();
void yyerror(const char *s);
int yylex();
%}

%token CORTE_DEBIL PATADA_MEDIA ARRIBA IZQUIERDA CORTE_MEDIO PATADA_DEBIL DERECHA ABAJO

%%
movimientos: 
  | movimientos movimiento ' '
  | movimientos movimiento '\n'
  | movimientos error
  ;

movimiento:
    //ATAQUES BASICOS
    CORTE_DEBIL { C_DEBIL(atacante,defensor); }
    | CORTE_MEDIO { C_MEDIO(atacante); }
    | CORTE_DEBIL CORTE_MEDIO { C_FUERTE(atacante); }
    | PATADA_DEBIL { P_DEBIL(atacante); }
    | PATADA_MEDIA { P_MEDIA(atacante); }
    | PATADA_DEBIL PATADA_MEDIA { P_FUERTE(atacante); }
    
    //MOVIMIENTOS X
    | IZQUIERDA IZQUIERDA { RETIRARSE(atacante); }
    | IZQUIERDA { IZQ(atacante); }
    | DERECHA { DER(atacante); }
    | IZQUIERDA IZQUIERDA DERECHA { RETIRARSE_Y_CORRER(atacante); }
    | DERECHA DERECHA { CORRER(atacante); }
    
    //MOVIMIENTOS Y
    | ARRIBA { SALTAR(atacante); }
    | ABAJO ABAJO { ESQUIVAR(atacante); }
    | ABAJO { AGACHARSE(atacante); }

    //MOVIMIENTOS X Y
    | ABAJO IZQUIERDA ABAJO IZQUIERDA { RODAR_IZQUIERDA(atacante); }
    | ABAJO DERECHA ABAJO DERECHA { RODAR_DERECHA(atacante); }
    | DERECHA DERECHA ABAJO DERECHA { CORRER_Y_RODAR(atacante);}

    //OTROS MOVIMIENTOS
    | CORTE_DEBIL PATADA_DEBIL { BURLA(atacante); }
    | CORTE_MEDIO PATADA_DEBIL { CANCELAR_BURLA(atacante); }
    
    //ATAQUES ESPECIALES
    | DERECHA DERECHA PATADA_MEDIA {ataqueEspecial(atacante,"Haohmaru");}
    | IZQUIERDA DERECHA PATADA_MEDIA {ataqueEspecial(atacante,"Nakoruru");}
    | ARRIBA IZQUIERDA CORTE_MEDIO {ataqueEspecial(atacante,"Ukyo");}
    | DERECHA ABAJO CORTE_MEDIO {ataqueEspecial(atacante,"Charlotte");}
    | ABAJO IZQUIERDA CORTE_MEDIO {ataqueEspecial(atacante,"Galford");}
    | IZQUIERDA DERECHA CORTE_MEDIO {ataqueEspecial(atacante,"Jubei");}
    | ARRIBA ABAJO PATADA_MEDIA {ataqueEspecial(atacante,"Terremoto");}
    | DERECHA IZQUIERDA CORTE_DEBIL {ataqueEspecial(atacante,"Hanzo");}
    | ARRIBA ABAJO CORTE_MEDIO {ataqueEspecial(atacante,"Kyoshiro");}
    | IZQUIERDA PATADA_DEBIL PATADA_DEBIL {ataqueEspecial(atacante,"Wan-fu");}
    | ABAJO IZQUIERDA CORTE_DEBIL {ataqueEspecial(atacante,"Genjuro");}
    | ABAJO ARRIBA PATADA_MEDIA {ataqueEspecial(atacante,"Cham Cham");}
    | ABAJO ARRIBA CORTE_DEBIL {ataqueEspecial(atacante,"Neinhalt");}
    | ABAJO ARRIBA CORTE_MEDIO {ataqueEspecial(atacante,"Nicotine");}
    | ABAJO DERECHA CORTE_MEDIO {ataqueEspecial(atacante,"Kuroko");}
  ;
%%
//FUNCIONES PARA LOGICA DEL JUEGO
void EvaluarVictoria(){
    if(jugador1.vida<=0){
        printf("\n%s Gana!\n",jugador2.nombre);
        ImprimirEstado("",NULL);
        exit(0);
    }else if(jugador2.vida<=0){
        printf("\n%s Gana!\n",jugador1.nombre);
        ImprimirEstado("",NULL);
        exit(0);
    }
}
bool AtaqueExitoso(){
    int distancia = sqrt(pow(jugador2.posicionX-jugador1.posicionX,2)+pow(jugador2.posicionY-jugador1.posicionY,2));
    if(distancia <= 2){
        return true;
    }else if (distancia >2 && distancia <=4){
        return rand()%2==0;
    }else{
        return false;
    }

}
void ComprobarPosY(Jugador *jugador){
    if(jugador->posicionY!=2){
        if(jugador->contadorY==2){
            jugador->posicionY=2;
            jugador->contadorY=0;
        }else{
            jugador->contadorY++;
        }
    }
}
void IncrementarMov(){

    movimientos++;
    if(movimientos==2){
        if(atacante == &jugador1){
            atacante = &jugador2;
            defensor = &jugador1;
        }else{
            atacante = &jugador1;
            defensor = &jugador2;
        }
        movimientos = 0;
    }
    turno++;
    ComprobarPosY(&jugador1);
    ComprobarPosY(&jugador2);
    EvaluarVictoria();
}
void validarBordes(Jugador* jugador){
    if(jugador->posicionX<0){
        jugador->posicionX=0;
    }else if(jugador->posicionX>19){
        jugador->posicionX=19;
    }
}
void validarFuria(){
    if (jugador1.furia>100){
        jugador1.furia=100;
    }
    if(jugador2.furia>100){
        jugador2.furia=100;
    }
}

//ATAQUES ESPECIALES
void ataqueEspecial(Jugador *jugador,char *nombre){
    limpiarConsola();
    if(movimientos==0){
        if(comparaStr(jugador->nombre,nombre)){
            if(atacante->furia==100){
                if(AtaqueExitoso()){
                    printf("\nIMPACTA!\n\n");
                    defensor->vida-=60;
                    defensor->furia+=40;
                }else{
                    printf("\nFALLA!\n\n");
                }
            }else{
                printf("\nNO TIENE SUFICIENTE FURIA!\n\n");
            }
        }else{
            printf("\nESE MOVIMIENTO NO ES TUYO!\n\n");
        }
        movimientos++;
        IncrementarMov();
        validarFuria();
    }else{
        printf("\nNecesitas dos movimientos para realizar esto.\n");
    }
    ImprimirEstado("intenta ATAQUE ESPECIAL!!!",jugador);
}

//ATAQUES BASICOS
void C_DEBIL(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=10;
        defensor->furia+=5;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    validarFuria();
    ImprimirEstado("intenta CORTE DEBIL",jugador);
}
void C_MEDIO(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=20;
        defensor->furia+=15;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    validarFuria();
    ImprimirEstado("intenta CORTE MEDIO",jugador);
}
void C_FUERTE(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=30;
        defensor->furia+=25;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    validarFuria();
    ImprimirEstado("intenta CORTE FUERTE",jugador);
}
void P_DEBIL(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=20;
        defensor->furia+=15;

    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    validarFuria();
    ImprimirEstado("intenta PATADA DEBIL",jugador);
}
void P_MEDIA(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=30;
        defensor->furia+=25;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    validarFuria();
    ImprimirEstado("intenta PATADA MEDIA",jugador);

}
void P_FUERTE(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=40;
        defensor->furia+=35;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    validarFuria();
    ImprimirEstado("intenta PATADA FUERTE",jugador);

}

//MOVIMIENTOS EN X
void IZQ(Jugador* jugador) {
    limpiarConsola();
    jugador->posicionX-=1;
    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("se mueve IZQUIERDA",jugador);
}
void DER(Jugador* jugador) {
    limpiarConsola();
    jugador->posicionX+=1;
    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("se mueve DERECHA",jugador);
}
void RETIRARSE_Y_CORRER(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX+=2;

    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("se RETIRA Y CORRE",jugador);
}
void CORRER(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX+=3;

    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("CORRE",jugador);
}
void RETIRARSE(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX-=3;

    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("se RETIRA",jugador);
}

//MOVIMIENTOS EN Y
void ESQUIVAR(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionY=0;
    jugador->contadorY=0;

    IncrementarMov();
    ImprimirEstado("ESQUIVA",jugador);
}
void AGACHARSE(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionY=1;
    jugador->contadorY=0;

    IncrementarMov();
    ImprimirEstado("se AGACHA",jugador);
}
void SALTAR(Jugador* jugador) {
    limpiarConsola();
    if(jugador->posicionY!=3){
        jugador->posicionY=3;
        jugador->contadorY=0;
    }
    IncrementarMov();
    ImprimirEstado("SALTA",jugador);
}

//MOVIMIENTOS EN X Y
void RODAR_IZQUIERDA(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX-=2;
    jugador->posicionY=1;
    jugador->contadorY=0;


    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("RUEDA IZQUIERDA",jugador);
}
void RODAR_DERECHA(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX+=2;
    jugador->posicionY=1;
    jugador->contadorY=0;


    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("RUEDA DERECHA",jugador);

}
void CORRER_Y_RODAR(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX+=4;
    jugador->posicionY=1;
    jugador->contadorY=0;

    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("CORRE Y RUEDA",jugador);
}

//OTROS MOVIMIENTOS
void BURLA(Jugador* jugador) {
    limpiarConsola();

    IncrementarMov();
    ImprimirEstado("se BURLA",jugador);
}
void CANCELAR_BURLA(Jugador* jugador) {
    limpiarConsola();

    IncrementarMov();
    ImprimirEstado("CANCELAR BURLA",jugador);
}

//FUNCIONES PARA IMPRESION EN CONSOLA
void ImprimirEstado(char *mov,Jugador *jugador){
    printf("\nTurno %d - %s\n\n",turno,atacante->nombre);
    printf("%s - O\t\t",jugador1.nombre);
    printf("%s - X\n",jugador2.nombre); 
    printf("VIDA: %i\t\t",jugador1.vida);
    printf("VIDA: %i\n",jugador2.vida);
    printf("FURIA: %i\t\t",jugador1.furia);
    printf("FURIA: %i\n",jugador2.furia);
    printf("POS X: %d Y:%d \t\t",jugador1.posicionX,jugador1.posicionY);
    printf("POS X: %d Y:%d \n",jugador2.posicionX,jugador2.posicionY);
    printf("\n%s %s!\n",jugador->nombre, mov);

    imprimirUbicacionJugadores();
}
void imprimirUbicacionJugadores(){
    char campo[CAMPO + 1];  // +1 para el carácter nulo al final
    char aire[CAMPO + 1];  // +1 para el carácter nulo al final

    for (int i = 0; i < CAMPO; i++) {
        aire[i] = ' ';
    }    
    // Inicializar el campo con guiones bajos ('_')

    for (int i = 0; i < CAMPO; i++) {
        campo[i] = '_';
    }
    campo[CAMPO] = '\0';  // Termina la cadena
    aire[CAMPO] = '\0';  // Termina la cadena


    // Verificar que las posiciones de los jugadores estén dentro del campo
        int pos1x = jugador1.posicionX;
        int pos1y = jugador1.posicionY;
    
        int pos2x = jugador2.posicionX;
        int pos2y = jugador2.posicionY;
    
    if(pos1x>=0){
        if(pos1y==3){aire[pos1x]='O';}
        if(pos1y==2){campo[pos1x] = 'O';}  // 'X' representa al jugador 2
        if(pos1y==1){campo[pos1x] = 'o';}
    }if(pos2x>=0){
        if(pos2y==3){aire[pos2x]='X';}
        if(pos2y==2){campo[pos2x] = 'X';}  // 'X' representa al jugador 2
        if(pos2y==1){campo[pos2x] = 'x';}
    }
    // Imprimir el campo con las posiciones de los jugadores
    printf("%s\n", aire);
    printf("%s\n", campo);
}
void limpiarConsola(){
    system("clear");
}
bool comparaStr (char entrada[],char modelo[]){
    int ind = 0;
    while (entrada[ind]!='\0' && modelo[ind]!='\0' && entrada[ind] == modelo[ind]) ind++;
    if (entrada[ind]!='\0' || modelo[ind]!='\0')
        return false;
    return true;
}
void yyerror(const char *s) {
    fprintf(stderr,"Movimiento no reconocido.\n");
    yyclearin;
}

void InicializarPJS(const char* filename) {
    FILE* archivo_parametros = fopen(filename, "r");
    if (!archivo_parametros) {
        perror("No se pudo abrir el archivo de parámetros");
        exit(1);
    }

    char nombre1[50], nombre2[50];
    int vida1, vida2, pos1, pos2, furia1, furia2;

    // Leer la línea 1: Nombres de los jugadores
    fscanf(archivo_parametros, "%s %s", nombre1, nombre2);
    jugador1.nombre = strdup(nombre1);  // Asignar nombre al jugador 1
    jugador2.nombre = strdup(nombre2);  // Asignar nombre al jugador 2

    // Leer la línea 2: Vida de los jugadores
    fscanf(archivo_parametros, "%d %d", &vida1, &vida2);
    jugador1.vida = vida1;
    jugador2.vida = vida2;

    // Leer la línea 3: Posición de los jugadores
    fscanf(archivo_parametros, "%d %d", &pos1, &pos2);
    jugador1.posicionX = pos1;
    jugador1.posicionY = 2;
    jugador2.posicionX = pos2;
    jugador2.posicionY = 2;


    // Leer la línea 4: Furia de los jugadores
    fscanf(archivo_parametros, "%d %d", &furia1, &furia2);
    jugador1.furia = furia1;
    jugador2.furia = furia2;

    fclose(archivo_parametros);
}

int main(int argc, char** argv) {
    srand(time(NULL));

    InicializarPJS("parametros.txt");

    if (argc > 1) {
        // Si se pasa un archivo como argumento, ábrelo
        FILE* archivo_movimientos = fopen(argv[1], "r");
        if (!archivo_movimientos) {
            perror("No se pudo abrir el archivo");
            return 1;
        }
        yyin = archivo_movimientos;  // Asigna el archivo a Flex
    }

    ImprimirEstado("",&jugador1);

    // Iniciar el análisis del archivo o entrada estándar
    yyparse();
    // Si se usó un archivo, cerrarlo
    if (argc > 1) {
        fclose(yyin);
    }

    return 0;
}


