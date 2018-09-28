%{
#include <stdio.h>
#include "symbol_table.h"

extern int line_num;
extern int yylex();

int yyerror(char *s);
%}

// Token Declarations
%token SEMICOLON SUB MUL EQUAL ERROR
%token INT_NUM FLOAT_NUM
%token MAIN PRINTID PRINTEXP
%token INT FLOAT IDENTIFIER

%union {
  int int_val;
  float float_val;
  char * id;
  struct {
      char type;
      union {
        int ival;
        float fval;
      } value;
  } table;
}

/*
  The union represents the semantic values of all the terminals/non-terminals
  which are given type.

  int_val, float_val and string id represent the semantic values of tokens INT,
  FLOAT and IDENTIFIER respectively.

  Non-terminal expr is represented by the struct table as it can be an int, float
  and an identifier all at the same time.
*/

%type <int_val> INT
%type <id> IDENTIFIER
%type <float_val> FLOAT
%type <table> expr

// Precendence of the arithmetic operations
%left SUB
%left MUL
%right EQUAL

// Starting Non-terminal
%start program
%%
program:
    MAIN '(' ')' '{' '}'
    | MAIN '(' ')' '{' vardefs stmts '}'
    | MAIN '(' ')' '{' stmts '}'
    | ERROR
;

vardefs:
    vardefs vardef SEMICOLON
    | vardef SEMICOLON
;

vardef:
    INT_NUM IDENTIFIER { push($2, 'i'); }
    | FLOAT_NUM IDENTIFIER { push($2, 'f'); }
;

stmts:
    stmts stmt SEMICOLON
    | stmt SEMICOLON
;

stmt: 
	| stmt expr_stmt
;

expr_stmt:
	expr
  | IDENTIFIER EQUAL expr
    {
      table * idtok = search($1);
      if (!idtok) {
        fprintf(stderr, "Line %d: %s is used but is not declared\n", line_num, $1);
        char * error = "e";
        yyerror(error);
        YYERROR;
      }

      if (idtok != NULL) {
        if ($3.type == idtok -> type) {
          if (idtok -> type == 'i') idtok -> value.ival = $3.value.ival;
          else idtok -> value.fval = $3.value.fval;
        }
        else fprintf(stderr, "LINE %d, type error\n", line_num);
      }
    }
  | PRINTID IDENTIFIER 
    { 
      table * idtok = search($2);

      if (!idtok) {
        fprintf(stderr, "Undeclared variable, Line: %d\n", line_num);
        char * error = "e";
        yyerror(error);
        YYERROR;
      }

      if (idtok != NULL) {
        if (idtok -> type == 'i') printf("%d\n", idtok -> value.ival);
        else printf("%.4f\n", idtok -> value.fval);
      }
    }
	| PRINTEXP expr 
    { 
      if ($2.type == 'i') printf("%d\n", $2.value.ival);
      else printf("%.4f\n", $2.value.fval)
    }
;

expr: 	 
	expr SUB expr 
    {
      if($1.type != $3.type) {
        fprintf(stderr, "Line %d, type error\n", line_num);
        char * error = "e";
        yyerror(error);
        YYERROR;
      }

      $<table.type>$ = $1.type;
      if ($1.type == 'i') $<table.value.ival>$ = $1.value.ival - $3.value.ival;
      else $<table.value.fval>$ = $1.value.fval - $3.value.fval;
    }
	| expr MUL expr
    {
      if($1.type != $3.type) {
        fprintf(stderr, "Line %d, type error\n", line_num);
        char * error = "e";
        yyerror(error);
        YYERROR;
      }

      $<table.type>$ = $1.type;
      if ($1.type == 'i') $<table.value.ival>$ = $1.value.ival * $3.value.ival;
      else $<table.value.fval>$ = $1.value.fval * $3.value.fval;
    }
	| INT
    {
      $<table.type>$ = 'i';
      $<table.value.ival>$ = $1;
    }
  | FLOAT
    {
      $<table.type>$ = 'f';
      $<table.value.fval>$ = $1;
    }
  | IDENTIFIER
    {
      table * idtok = search($1);
      if (!idtok) {
        fprintf(stderr, "Line %d: %s is used but is not declared\n", line_num, idtok -> id);
        char * error = "e";
        yyerror(error);
        YYERROR;
      }

      if (idtok != NULL) {
        $<table.type>$ = idtok -> type;
        if (idtok -> type == 'i') $<table.value.ival>$ = idtok -> value.ival;
        else $<table.value.fval>$ = idtok -> value.fval;
      }
    }
;

%%

int yyerror(char *s) {
  if (*s == 'e') return 1;

	printf("Parsing error: line: %d\n", line_num);
	return 1;
}

int main() {
   yyparse();
   return 0;
}