%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

DIGIT      [0-9]
LETTER     [a-zA-Z]
ID         {LETTER}({LETTER}|{DIGIT})*
NUMBER     {DIGIT}+

%%

"int"        { return INT; }
"float"      { return FLOAT; }
"if"         { return IF; }
"else"       { return ELSE; }
"while"      { return WHILE; }
"return"     { return RETURN; }

{ID}         { yylval.str = strdup(yytext); return ID; }
{NUMBER}     { yylval.num = atoi(yytext); return NUMBER; }

"+"          { return PLUS; }
"-"          { return MINUS; }
"*"          { return MUL; }
"/"          { return DIV; }

"=="         { return EQ; }
"!="         { return NE; }
">"          { return GT; }
"<"          { return LT; }
">="         { return GE; }
"<="         { return LE; }

"="          { return ASSIGN; }
";"          { return SEMI; }
","          { return COMMA; }
"("          { return LPAREN; }
")"          { return RPAREN; }
"{"          { return LBRACE; }
"}"          { return RBRACE; }

  /* INDENTED: Single line comment */
"//".* { }

  /* INDENTED: Multi-line comment (also fixed the regex here) */
"/*"([^*]|\*+[^*/])*\*+"/"    { }

  /* INDENTED: Whitespace */
[ \t\n]+     { }

  /* INDENTED: Error handling */
. {
    printf("Invalid character: %s\n", yytext);
}

%%

int yywrap() {
    return 1;
}