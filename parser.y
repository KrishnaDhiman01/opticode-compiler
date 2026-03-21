%{
#include <stdio.h>
#include <stdlib.h>

// Forward declarations to satisfy the compiler
extern int yylex();
void yyerror(const char *s);
%}

/* Define the union matching your lexer's yylval */
%union {
    int num;
    char* str;
}

/* Define tokens used in lexer.l */
%token <str> ID
%token <num> NUMBER
%token INT FLOAT IF ELSE WHILE RETURN
%token PLUS MINUS MUL DIV
%token EQ NE GT LT GE LE
%token ASSIGN SEMI COMMA LPAREN RPAREN LBRACE RBRACE

/* Define operator precedence to avoid shift/reduce conflicts */
%left PLUS MINUS
%left MUL DIV

%%

/* --- Grammar Rules --- */

program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    declaration
    | assignment
    ;

declaration:
    INT ID SEMI { printf("Parsed integer declaration: %s\n", $2); }
    | FLOAT ID SEMI { printf("Parsed float declaration: %s\n", $2); }
    ;

assignment:
    ID ASSIGN expr SEMI { printf("Parsed assignment to %s\n", $1); }
    ;

expr:
    expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | NUMBER
    | ID
    ;

%%

/* --- C Code Section --- */

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int main(void) {
    printf("Enter code to parse (Press Ctrl+D to stop):\n");
    yyparse();
    return 0;
}