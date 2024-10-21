**archivo parametros**
personaje1 personaje2
vida1 vida2
pos1 pos2
furia1 furia2

**archivo movimientos**
secuencia de movimientos separados por espacios o saltos de linea.

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
