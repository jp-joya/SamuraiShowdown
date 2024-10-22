%{
#include "ss.tab.h"
%}
%option yylineno
%%
"A"     { return CORTE_DEBIL; }
"D"	{ return PATADA_MEDIA;}
"^"	{ return ARRIBA;}
"<"     { return IZQUIERDA;}
"B"	{ return CORTE_MEDIO;}
"C"	{ return PATADA_DEBIL;}
">"     { return DERECHA;}
"v"	{ return ABAJO;}
"\n"	{ return '\n';}
" "	{ return ' ';}
"\t" { /* Ignorar espacios en blanco */ }
.    {}

%%

int yywrap() {
    return 1;
}

