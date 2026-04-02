%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tempCount = 1;

char* newTemp() {
    char *temp = (char*)malloc(10);
    sprintf(temp, "t%d", tempCount++);
    return temp;
}

int yyerror(char *s);
int yylex();
%}

%union {
    int num;
    char* str;
}

%token <num> NUMBER
%token <str> ID
%token PLUS MINUS MUL DIV
%token ASSIGN SEMI
%token LPAREN RPAREN

%left PLUS MINUS
%left MUL DIV

%type <str> expr

%%

stmt: ID ASSIGN expr SEMI {
    printf("%s = %s\n", $1, $3);
}
;

expr: expr PLUS expr {
        char* t = newTemp();
        printf("%s = %s + %s\n", t, $1, $3);
        $$ = t;
     }
    | expr MINUS expr {
        char* t = newTemp();
        printf("%s = %s - %s\n", t, $1, $3);
        $$ = t;
     }
    | expr MUL expr {
        char* t = newTemp();
        printf("%s = %s * %s\n", t, $1, $3);
        $$ = t;
     }
    | expr DIV expr {
        char* t = newTemp();
        printf("%s = %s / %s\n", t, $1, $3);
        $$ = t;
     }
    | LPAREN expr RPAREN {
        $$ = $2;
     }
    | NUMBER {
        char buffer[20];
        sprintf(buffer, "%d", $1);
        $$ = strdup(buffer);
     }
    | ID {
        $$ = strdup($1);
     }
;

%%

int main() {
    printf("Enter expression:\n");
    yyparse();
    return 0;
}

int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 0;
}