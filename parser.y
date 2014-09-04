%{
#include <stdio.h>
#include "rml.h"
#include "assigntwotype.h"

#define YYSTYPE void*
extern void* absyntree;

%}

%token T_SEMIC
%token T_ASSIGN
%token T_IDENT
%token T_INTCONST
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

/* Yacc BNF grammar of the expression language Assigntwotypes */

program         : statement
                        { absyntree = assigntwotype__PROGRAM($1);}

statement       : statement T_SEMIC statement
                        { $$ = assigntwotype__STATEMENT($1, $3); }
                | T_SKIP
                        { $$ = assigntwotype__SKIP; }
                | variable T_ASSIGN expression
                        { $$ = assigntwotype__ASSIGN($1, $3); }
                | T_ALWAYS constraint
                        { $$ = assigntwotype__ALWAYS($2); }
                | T_ONCE constraint
                        { $$ = assigntwotype__ONCE($2); }
                | T_IF expression T_THEN statement T_ELSE statement
                        { $$ = assigntwotype__IF($2, $4, $6); }
                | T_WHILE expression T_DO statement
                        { $$ = assigntwotype__WHILE($2, $4); }

constraint      : rho expression
                        { $$ = assigntwotype__CONSTRAINT($1, $2); }
                | constraint T_AND constraint
                        { $$ = assigntwotype__COMPOUNDCONSTRAINT($1, $3); }

rho             : T_WEAK
                        { $$ = assigntwotype__WEAK; }
                | T_REQUIRED
                        { $$ = assigntwotype__REQUIRED; }

expression      : cexpression combination expression
                        { $$ = assigntwotype__COMBINE($1, $2, $3); }
                | cexpression
cexpression     : wexpression comparison expression
                        { $$ = assigntwotype__COMPARE($1, $2, $3); }
                | wexpression
wexpression     : sexpression soperation expression
                        { $$ = assigntwotype__OP($1, $2, $3); }
                | sexpression
sexpression     : eexpression woperation expression
                        { $$ = assigntwotype__OP($1, $2, $3); }
                | eexpression
eexpression     : constant
                        { $$ = assigntwotype__CONSTANT($1); }
                | variable
                        { $$ = assigntwotype__VARIABLE($1); }

soperation      : T_ADD
                        { $$ = assigntwotype__ADD;}
                | T_SUB
                        { $$ = assigntwotype__SUB;}
woperation      : T_MUL
                        { $$ = assigntwotype__MUL;}
                | T_DIV
                        { $$ = assigntwotype__DIV;}

comparison      : T_LESSTHAN
                        { $$ = assigntwotype__LESSTHAN;}
                | T_LEQUAL
                        { $$ = assigntwotype__LEQUAL;}
                | T_EQUAL
                        { $$ = assigntwotype__EQUAL;}
                | T_GEQUAL
                        { $$ = assigntwotype__GEQUAL;}
                | T_GREATERTHAN
                        { $$ = assigntwotype__GEQUAL;}

combination     : T_AND
                        { $$ = assigntwotype__AND;}

constant        : T_INTCONST
                        { $$ = assigntwotype__INT($1);}
                | T_REALCONST
                        { $$ = assigntwotype__REAL($1);}
                | T_TRUE
                        { $$ = assigntwotype__TRUE; }
                | T_FALSE
                        { $$ = assigntwotype__FALSE; }
                | T_NIL
                        { $$ = assigntwotype__NIL; }

variable        : T_IDENT
                        { $$ = assigntwotype__VARIABLE($1); }
