%{
#define YYSTYPE void*
#include "parser.h"
#include "rml.h"
#include "babelsberg.h"

int lex_icon(void);
int lex_ident(void);
int lex_rcon(void);

%}

whitespace   [ \t\n]+
letter       [a-zA-Z_]
questionmark "?"
ident        {letter}({letter}|{digit})*{questionmark}?
digit        [0-9]
digits       {digit}+
pt           "."
quote        "\""
sign         [-]
exponent     ([eE]{sign}?{digits})
rcon1        {sign}?{digits}({pt}{digits}?)?{exponent}
rcon2        {sign}?{digits}?{pt}{digits}{exponent}?
rcon         {rcon1}|{rcon2}
icon1        {digits}
icon2        {sign}{digits}
icon         {icon1}|{icon2}
string       {quote}({letter}|{digit}|{whitespace})+{quote}
amp          "#"
reference    {amp}{digits}

%%

{whitespace} ;
{string}     return lex_string();
{icon}       return lex_rcon();  /* convert ints to T_REALCONST */
{rcon}       return lex_rcon();  /* T_REALCONST */
{reference}  return lex_ref();
"H"          return T_H_DEREF;
"new"        return T_NEW;
":="         return T_ASSIGN;
"+"          return T_ADD;
"-"          return T_SUB;
"*"          return T_MUL;
"/"          return T_DIV;
"=="         return T_IDENTICAL;
"<"          return T_LESSTHAN;
"<="         return T_LEQUAL;
"!="         return T_NEQUAL;
"="          return T_EQUAL;
">="         return T_GEQUAL;
">"          return T_GREATERTHAN;
"&&"         return T_AND;
"and"        return T_AND;
"or"         return T_OR;
"("          return T_LPAREN;
")"          return T_RPAREN;
"{"          return T_LBRACE;
"}"          return T_RBRACE;
":"          return T_COLON;
","          return T_COMMA;
{pt}         return T_DOT;
";"          return T_SEMIC;
"skip"       return T_SKIP;
"always"     return T_ALWAYS;
"once"       return T_ONCE;
"weak"       return T_WEAK;
"medium"     return T_MEDIUM;
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

int lex_string(void)
{
  yylval = (void*)mk_scon(yytext);
  return T_STRING;
}

int lex_ref(void)
{
  yylval = (void*)mk_icon(atoi(yytext + 1));
  return T_REF;
}
