%{
#define YYSTYPE void*
#include "parser.h"
#include "rml.h"
#include "babelsbergP.h"

int lex_icon(void);
int lex_ident(void);
int lex_rcon(void);

%}

whitespace   [ \t\n]+
letter       [a-zA-Z_]
ident        {letter}({letter}|{digit})*
digit        [0-9]
digits       {digit}+
icon         {digits}
pt           "."
sign         [+-]
exponent     ([eE]{sign}?{digits})
rcon1        {digits}({pt}{digits}?)?{exponent}
rcon2        {digits}?{pt}{digits}{exponent}?
rcon         {rcon1}|{rcon2}

%%

{whitespace} ;
{icon}       return lex_rcon();  /* convert ints to T_REALCONST */
{rcon}       return lex_rcon();  /* T_REALCONST */
":="         return T_ASSIGN;
"+"          return T_ADD;
"-"          return T_SUB;
"*"          return T_MUL;
"/"          return T_DIV;
"<"          return T_LESSTHAN;
"<="         return T_LEQUAL;
"="          return T_EQUAL;
">="         return T_GEQUAL;
">"          return T_GREATERTHAN;
"&&"         return T_AND;
"and"        return T_AND;
"or"         return T_OR;
"("          return T_LPAREN;
")"          return T_RPAREN;
";"          return T_SEMIC;
"skip"       return T_SKIP;
"always"     return T_ALWAYS;
"once"       return T_ONCE;
"weak"       return T_WEAK;
"required"   return T_REQUIRED;
"if"         return T_IF;
"then"       return T_THEN;
"else"       return T_ELSE;
"while"      return T_WHILE;
"do"         return T_DO;
"true"       return T_TRUE;
"false"      return T_FALSE;
"nil"        return T_NIL;
{ident}      return lex_ident(); /* T_IDENT */

%%

int lex_rcon(void)
{
  yylval= (void*)mk_rcon(atof(yytext));
  return T_REALCONST;
}

int lex_ident(void)
{
  yylval = (void*)mk_scon(yytext);
  return T_IDENT;
}
