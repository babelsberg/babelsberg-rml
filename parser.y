%{
#include <stdio.h>
#include "rml.h"
#include "babelsbergP.h"

#define YYSTYPE void*
extern void* absyntree;

%}

%token T_SEMIC
%token T_ASSIGN
%token T_IDENT
%token T_REALCONST
%token T_LPAREN T_RPAREN
%token T_ADD
%token T_SUB
%token T_MUL
%token T_DIV
%token T_LESSTHAN
%token T_LEQUAL
%token T_EQUAL
%token T_GEQUAL
%token T_GREATERTHAN
%token T_AND

%token T_GARBAGE

%token T_SKIP
%token T_ALWAYS
%token T_ONCE
%token T_WEAK
%token T_REQUIRED
%token T_IF
%token T_THEN
%token T_ELSE
%token T_WHILE
%token T_DO
%token T_TRUE
%token T_FALSE
%token T_NIL


%token T_ERR

%%

/* Yacc BNF grammar of the expression language BabelsbergPs */

program         : statement
                        { absyntree = babelsbergP__PROGRAM($1);}

statement       : statement T_SEMIC statement
                        { $$ = babelsbergP__SEQ($1, $3); }
                | T_SKIP
                        { $$ = babelsbergP__SKIP; }
                | variable T_ASSIGN expression
                        { $$ = babelsbergP__ASSIGN($1, $3); }
                | T_ALWAYS constraint
                        { $$ = babelsbergP__ALWAYS($2); }
                | T_ONCE constraint
                        { $$ = babelsbergP__ONCE($2); }
                | T_IF expression T_THEN statement T_ELSE statement
                        { $$ = babelsbergP__IF($2, $4, $6); }
                | T_WHILE expression T_DO statement
                        { $$ = babelsbergP__WHILE($2, $4); }

constraint      : rho expression
                        { $$ = babelsbergP__CONSTRAINT($1, $2); }
                | constraint T_AND constraint
                        { $$ = babelsbergP__COMPOUNDCONSTRAINT($1, $3); }

rho             : T_WEAK
                        { $$ = babelsbergP__WEAK; }
                | T_REQUIRED
                        { $$ = babelsbergP__REQUIRED; }

expression      : cexpression combination expression
                        { $$ = babelsbergP__COMBINE($1, $2, $3); }
                | cexpression
cexpression     : wexpression comparison expression
                        { $$ = babelsbergP__COMPARE($1, $2, $3); }
                | wexpression
wexpression     : sexpression soperation expression
                        { $$ = babelsbergP__OP($1, $2, $3); }
                | sexpression
sexpression     : eexpression woperation expression
                        { $$ = babelsbergP__OP($1, $2, $3); }
                | eexpression
eexpression     : value
                        { $$ = babelsbergP__VALUE($1); }
                | variable
                        { $$ = babelsbergP__VARIABLE($1); }

soperation      : T_ADD
                        { $$ = babelsbergP__ADD;}
                | T_SUB
                        { $$ = babelsbergP__SUB;}
woperation      : T_MUL
                        { $$ = babelsbergP__MUL;}
                | T_DIV
                        { $$ = babelsbergP__DIV;}

comparison      : T_LESSTHAN
                        { $$ = babelsbergP__LESSTHAN;}
                | T_LEQUAL
                        { $$ = babelsbergP__LEQUAL;}
                | T_EQUAL
                        { $$ = babelsbergP__EQUAL;}
                | T_GEQUAL
                        { $$ = babelsbergP__GEQUAL;}
                | T_GREATERTHAN
                        { $$ = babelsbergP__GEQUAL;}

combination     : T_AND
                        { $$ = babelsbergP__AND;}

constant        : T_REALCONST
                        { $$ = babelsbergP__REAL($1);}
                | T_TRUE
                        { $$ = babelsbergP__TRUE; }
                | T_FALSE
                        { $$ = babelsbergP__FALSE; }
                | T_NIL
                        { $$ = babelsbergP__NIL; }

variable        : T_IDENT
                        { $$ = babelsbergP__VARIABLE($1); }

value           : constant
