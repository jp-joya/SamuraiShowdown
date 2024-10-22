**archivo parametros**

```bash
personaje1 personaje2
vida1 vida2
pos1 pos2
furia1 furia2
```
Personajes posibles y sus ataques especiales:
```bash
Haohmaru >>D
Nakoruru <>D
Ukyo ^<B
Charlotte >vB 
Galford v<B
Jubei <>B
Terremoto ^vD 
Hanzo ><A
Kyoshiro ^vB
Wan-Fu <CC
Genjuro v<A
Cham v^D
Neinhalt v^A
Nicotine v^B
Kuroko v>B
```
**archivo movimientos**

secuencia de movimientos separados por espacios o saltos de linea.
EJ:

```bash
A AB 
D ^
< >>
vv AC
<<> B
C CD
> v
<< v<v<
v>v> BC
>>v> <>D
```

**Generar Lexer**
```bash
flex ss.l
```
**Generar Parser**
```bash
bison -d ss.y
```
**Compilar**
```bash
gcc lex.yy.c ss.tab.c -lm
```
**Ejecutar**
```bash
./a.out
```
o
```bash
./a.out mov.txt
```
