%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>

#define CAMPO 20
#define VIDA_MAXIMA 3
#define FURIA_MAXIMA 100

extern FILE* yyin; 

typedef struct {
    char* nombre;
    int vida;
    int posicionX;
    int posicionY;
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

void ImprimirEstado();
void imprimirUbicacionJugadores();
void limpiarConsola();

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

void yyerror(const char *s);
int yylex();
%}

%token CORTE_DEBIL PATADA_MEDIA ARRIBA IZQUIERDA CORTE_MEDIO PATADA_DEBIL DERECHA ABAJO

%%
movimientos: 
  | movimientos movimiento ';';
movimiento:
    CORTE_DEBIL { C_DEBIL(atacante,defensor); }
  | IZQUIERDA { IZQ(atacante); }
  | DERECHA { DER(atacante); }
  | CORTE_DEBIL CORTE_MEDIO { C_FUERTE(atacante); }
  | PATADA_MEDIA { P_MEDIA(atacante); }
  | ARRIBA { SALTAR(atacante); }
  | DERECHA DERECHA { CORRER(atacante); }
  | ABAJO ABAJO { ESQUIVAR(atacante); }
  | CORTE_DEBIL PATADA_DEBIL { BURLA(atacante); }
  | IZQUIERDA IZQUIERDA DERECHA { RETIRARSE_Y_CORRER(atacante); }
  | CORTE_MEDIO { C_MEDIO(atacante); }
  | PATADA_DEBIL { P_DEBIL(atacante); }
  | PATADA_DEBIL PATADA_MEDIA { P_FUERTE(atacante); }

  | ABAJO { AGACHARSE(atacante); }
  | IZQUIERDA IZQUIERDA { RETIRARSE(atacante); }
  | ABAJO IZQUIERDA ABAJO IZQUIERDA { RODAR_IZQUIERDA(atacante); }
  | ABAJO DERECHA ABAJO DERECHA { RODAR_DERECHA(atacante); }
  | CORTE_MEDIO PATADA_DEBIL { CANCELAR_BURLA(atacante); }
  | DERECHA DERECHA ABAJO DERECHA { CORRER_Y_RODAR(atacante); }
  ;
%%
//FUNCIONES PARA LOGICA DEL JUEGO
void EvaluarVictoria(){
    if(jugador1.vida<=0){
        printf("\n%s Gana!\n",jugador2.nombre);
        exit(0);
    }else if(jugador2.vida<=0){
        printf("\n%s Gana!\n",jugador1.nombre);
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
    EvaluarVictoria();
}
void validarBordes(Jugador* jugador){
    if(jugador->posicionX<0){
        jugador->posicionX=0;
    }else if(jugador->posicionX>19){
        jugador->posicionX=19;
    }
}

//FUNCIONES PARA IMPRESION EN CONSOLA
void ImprimirEstado(char *mov,Jugador *jugador){
    printf("\nTurno %d - %s\n\n",turno,atacante->nombre);
    printf("%s\t\t\t",jugador1.nombre);
    printf("%s\n",jugador2.nombre); 
    printf("VIDA: %i\t\t\t",jugador1.vida);
    printf("VIDA: %i\n",jugador2.vida);
    printf("FURIA: %i\t\t\t",jugador1.furia);
    printf("FURIA: %i\n",jugador2.furia);
    printf("POS X: %d Y:%d \t\t",jugador1.posicionX,jugador1.posicionY);
    printf("POS X: %d Y:%d \n",jugador2.posicionX,jugador2.posicionY);
    printf("\n%s %s!\n",jugador->nombre, mov);

    imprimirUbicacionJugadores();
}
void imprimirUbicacionJugadores(){
    char campo[CAMPO + 1];  // +1 para el carácter nulo al final

    // Inicializar el campo con guiones bajos ('_')
    for (int i = 0; i < CAMPO; i++) {
        campo[i] = '_';
    }
    campo[CAMPO] = '\0';  // Termina la cadena

    // Verificar que las posiciones de los jugadores estén dentro del campo
        int pos1 = jugador1.posicionX;
    
        int pos2 = jugador2.posicionX;
    
    if(pos1>=0){
        campo[pos1] = 'O';  // 'O' representa al jugador 1
    }if(pos2>=0){
        campo[pos2] = 'X';  // 'X' representa al jugador 2
    }
    // Imprimir el campo con las posiciones de los jugadores
    printf("%s\n", campo);
}
void limpiarConsola(){
    system("clear");
}

//ATAQUES BASICOS
void C_DEBIL(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=1;
        defensor->furia+=1;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    ImprimirEstado("intenta CORTE DEBIL",jugador);
}
void C_MEDIO(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=2;
        defensor->furia+=2;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    ImprimirEstado("intenta CORTE MEDIO",jugador);
}
void C_FUERTE(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=3;
        defensor->furia+=3;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    ImprimirEstado("intenta CORTE FUERTE",jugador);
}
void P_DEBIL(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=2;
        defensor->furia+=2;

    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    ImprimirEstado("intenta PATADA DEBIL",jugador);
}
void P_MEDIA(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=3;
        defensor->furia+=3;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
    ImprimirEstado("intenta PATADA MEDIA",jugador);

}
void P_FUERTE(Jugador* jugador) {
    limpiarConsola();
    if(AtaqueExitoso()){
        printf("\nHIT!\n\n");
        defensor->vida-=4;
        defensor->furia+=4;
    }else{
        printf("\nFALLA!\n\n");
    }
    IncrementarMov();
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

    IncrementarMov();
    ImprimirEstado("ESQUIVA",jugador);
}
void AGACHARSE(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionY=1;

    IncrementarMov();
    ImprimirEstado("se AGACHA",jugador);
}
void SALTAR(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionY=3;

    IncrementarMov();
    ImprimirEstado("SALTA",jugador);
}

//MOVIMIENTOS EN X Y
void RODAR_IZQUIERDA(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX-=2;
    jugador->posicionY=1;

    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("RUEDA IZQUIERDA",jugador);
}
void RODAR_DERECHA(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX+=2;
    jugador->posicionY=1;

    validarBordes(jugador);
    IncrementarMov();
    ImprimirEstado("RUEDA DERECHA",jugador);

}
void CORRER_Y_RODAR(Jugador* jugador) {
    limpiarConsola();

    jugador->posicionX+=4;
    jugador->posicionY=1;

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


void yyerror(const char *s) {}
void init(){
    // Inicialización de jugadores
    jugador1.nombre = "Pepe";
    jugador1.vida = VIDA_MAXIMA;
    jugador1.posicionX = 7;
    jugador1.posicionY = 2;
    jugador1.furia = 0;

    jugador2.nombre = "Mimi";
    jugador2.vida = VIDA_MAXIMA;
    jugador2.posicionX = 11;
    jugador2.posicionY = 2;
    jugador2.furia = 0;
}

int main(int argc, char** argv) {
    srand(time(NULL));
    if (argc > 1) {
        // Si se pasa un archivo como argumento, ábrelo
        FILE* archivo_movimientos = fopen(argv[1], "r");
        if (!archivo_movimientos) {
            perror("No se pudo abrir el archivo");
            return 1;
        }
        yyin = archivo_movimientos;  // Asigna el archivo a Flex
    }
    // Inicialización de jugadores
    init();
    ImprimirEstado("",&jugador1);

    // Iniciar el análisis del archivo o entrada estándar
    yyparse();

    // Si se usó un archivo, cerrarlo
    if (argc > 1) {
        fclose(yyin);
    }

    return 0;
}


