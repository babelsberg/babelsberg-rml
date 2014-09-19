%{
#include <stdio.h>
#include "rml.h"
#include "babelsberg.h"

#define YYSTYPE void*
extern void* absyntree;

%}

%token T_SEMIC
%token T_ASSIGN
%token T_IDENT
%token T_REALCONST
%token T_STRING
%token T_LPAREN T_RPAREN
%token T_LESSTHAN
%token T_LEQUAL
%token T_EQUAL
%token T_NEQUAL
%token T_GEQUAL
%token T_GREATERTHAN
%token T_OR
%token T_AND
%token T_ADD
%token T_SUB
%token T_MUL
%token T_DIV

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

%left T_OR
%left T_AND
%left T_LESSTHAN T_LEQUAL T_EQUAL T_NEQUAL T_GEQUAL T_GREATERTHAN
%left T_ADD T_SUB
%left T_MUL T_DIV

%%

/* Yacc BNF grammar of the expression language BabelsbergPs */

program         : statement
			{ absyntree = babelsberg__PROGRAM($1);}

statement       : statement T_SEMIC statement
			{ $$ = babelsberg__SEQ($1, $3); }
		| T_SKIP
			{ $$ = babelsberg__SKIP; }
		| variable T_ASSIGN expression
			{ $$ = babelsberg__ASSIGN($1, $3); }
		| T_ALWAYS constraint
			{ $$ = babelsberg__ALWAYS($2); }
		| T_ONCE constraint
			{ $$ = babelsberg__ONCE($2); }
		| T_IF expression T_THEN statement T_ELSE statement
			{ $$ = babelsberg__IF($2, $4, $6); }
		| T_WHILE expression T_DO statement
			{ $$ = babelsberg__WHILE($2, $4); }

constraint      : rho expression
			{ $$ = babelsberg__CONSTRAINT($1, $2); }
		| expression
			{ $$ = babelsberg__CONSTRAINT(babelsberg__REQUIRED, $1); }
		| constraint T_AND constraint
			{ $$ = babelsberg__COMPOUNDCONSTRAINT($1, $3); }

rho             : T_WEAK
			{ $$ = babelsberg__WEAK; }
		| T_REQUIRED
			{ $$ = babelsberg__REQUIRED; }

expression      : expression woperation expression %prec T_MUL
			{ $$ = babelsberg__OP($1, $2, $3); }
                | expression soperation expression %prec T_ADD
			{ $$ = babelsberg__OP($1, $2, $3); }
                | expression comparison expression %prec T_EQUAL
			{ $$ = babelsberg__COMPARE($1, $2, $3); }
                | expression combination expression %prec T_AND
			{ $$ = babelsberg__COMBINE($1, $2, $3); }
                | expression disjunction expression %prec T_OR
			{ $$ = babelsberg__COMBINE($1, $2, $3); }
                | value
			{ $$ = babelsberg__VALUE($1); }
		| variable
			{ $$ = babelsberg__VARIABLE($1); }

soperation      : T_ADD
			{ $$ = babelsberg__ADD;}
		| T_SUB
			{ $$ = babelsberg__SUB;}
woperation      : T_MUL
			{ $$ = babelsberg__MUL;}
		| T_DIV
			{ $$ = babelsberg__DIV;}

comparison      : T_LESSTHAN
			{ $$ = babelsberg__LESSTHAN;}
		| T_LEQUAL
			{ $$ = babelsberg__LEQUAL;}
		| T_EQUAL
			{ $$ = babelsberg__EQUAL;}
		| T_NEQUAL
			{ $$ = babelsberg__NEQUAL;}
		| T_GEQUAL
			{ $$ = babelsberg__GEQUAL;}
		| T_GREATERTHAN
			{ $$ = babelsberg__GEQUAL;}

combination     : T_AND
			{ $$ = babelsberg__AND;}

disjunction     : T_OR
			{ $$ = babelsberg__OR;}

constant        : T_REALCONST
			{ $$ = babelsberg__REAL($1);}
		| T_TRUE
			{ $$ = babelsberg__TRUE; }
		| T_FALSE
			{ $$ = babelsberg__FALSE; }
		| T_NIL
			{ $$ = babelsberg__NIL; }
		| T_STRING
			{ $$ = babelsberg__STRING($1);}

variable        : T_IDENT
			{ $$ = $1; }

value           : constant
