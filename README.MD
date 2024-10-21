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
