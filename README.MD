``
flex ss.l
``

``
bison -d ss.y
``

``
gcc lex.yy.c ss.tab.c -lm
``

``
./a.out
``

``
./a.out mov.txt
``
