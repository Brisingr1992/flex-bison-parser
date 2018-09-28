%option noyywrap nodefault

%{
#include <stdio.h>
#include "calc.tab.h"
int line_num = 1;
%}

digit  ([0-9])
chars  ([0-9a-zA-Z])
lower  ([a-z])
float  ((\.[0-9]+)?([Ee][-+]?[0-9]+)?)
upper  ([0-9A-Z])
%%
"int"	{  return(INT_NUM); }
"float" {  return(FLOAT_NUM); }

"main"	{  return(MAIN); }
"printExp"      {   return(PRINTEXP); }
"printID"	{  return(PRINTID); }


{lower}{chars}* { yylval.id = strdup(yytext); return(IDENTIFIER); }
{digit}+  { yylval.int_val = atoi(yytext); return(INT); }
{digit}+{float} { yylval.float_val = atof(yytext); return FLOAT; }
{upper}{chars}* { printf("Lexical Error: %s\n", yytext); }

";"  {  return(SEMICOLON);  }
"="  { return(EQUAL); }
"-"  {  return(SUB);  }
"*"  {  return(MUL);  }
"/"  {  return(DIV);  }
"+"  {  return(ADD);  } 

[\(\)\{\}]	{  return yytext[0]; }
[ \t\f] ;
\n	{ ++line_num; }

.  { printf("Lexical Error: %c\n", yytext[0]); return ERROR; }

%%