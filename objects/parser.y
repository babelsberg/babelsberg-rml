%{
#include <stdio.h>
#include "rml.h"
#include "babelsberg.h"

#define YYSTYPE void*
extern void* absyntree;

/* int yydebug=1; */

%}

%token T_SEMIC
%token T_ASSIGN
%token T_IDENT
%token T_GLOBAL
%token T_REALCONST
%token T_STRING
%token T_H_DEREF
%token T_REF
%token T_NEW
%token T_IDENTICAL
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

%token T_LBRACE
%token T_RBRACE
%token T_COLON
%token T_COMMA
%token T_DOT

%token T_GARBAGE

%token T_SKIP
%token T_ALWAYS
%token T_ONCE
%token T_WEAK
%token T_MEDIUM
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

statement       : T_SKIP
                        { $$ = babelsberg__SKIP; }
                | lvalue T_ASSIGN expression
                        { $$ = babelsberg__ASSIGN($1, $3); }
                | T_ALWAYS constraint
                        { $$ = babelsberg__ALWAYS($2); }
                | T_ONCE constraint
                        { $$ = babelsberg__ONCE($2); }
                | statement T_SEMIC statement
                        { $$ = babelsberg__SEQ($1, $3); }
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
                | T_MEDIUM
                        { $$ = babelsberg__MEDIUM; }
                | T_REQUIRED
                        { $$ = babelsberg__REQUIRED; }

expression      : value
                        { $$ = babelsberg__VALUE($1); }
                | lvalue
                        { $$ = babelsberg__LVALUE($1); }
                | expression woperation expression %prec T_MUL
                        { $$ = babelsberg__OP($1, $2, $3); }
                | expression soperation expression %prec T_ADD
                        { $$ = babelsberg__OP($1, $2, $3); }
                | expression comparison expression %prec T_EQUAL
                        { $$ = babelsberg__COMPARE($1, $2, $3); }
                | expression combination expression %prec T_AND
                        { $$ = babelsberg__COMBINE($1, $2, $3); }
                | expression disjunction expression %prec T_OR
                        { $$ = babelsberg__COMBINE($1, $2, $3); }
                | expression T_IDENTICAL expression %prec T_EQUAL
                        { $$ = babelsberg__IDENTITY($1, $3); }
                | T_GLOBAL T_LPAREN callargs T_RPAREN
		        { $$ = babelsberg__CALL(babelsberg__VALUE(babelsberg__K(babelsberg__NIL)), $1, $3); }
                | expression T_DOT label T_LPAREN callargs T_RPAREN
                        { $$ = babelsberg__CALL($1, $3, $5); }
                | T_LBRACE objectliteral T_RBRACE
                        { $$ = babelsberg__IRECORD($2); }
                | T_NEW T_LBRACE objectliteral T_RBRACE
                        { $$ = babelsberg__UIDRECORD($3); }
                | dereference
                        { $$ = babelsberg__DEREF($1); }

callargs        : /* empty */
                       { $$ = mk_nil(); }
                | expression
                       { $$ = mk_cons($1, mk_nil()); }
                | expression T_COMMA callargs
                       { $$ = mk_cons($1, $3); }

objectliteral   : /* empty */
                       { $$ = mk_nil(); }
                | fieldexpression
                       { $$ = mk_cons($1, mk_nil()); }
                | fieldexpression T_COMMA objectliteral
                       { $$ = mk_cons($1, $3); }

fieldexpression : label T_COLON expression
                       { $$ = mk_box2(1, $1, $3); }

lvalue          : variable
                        { $$ = babelsberg__VARIABLE($1); }
                | expression T_DOT label
                        { $$ = babelsberg__FIELD($1, $3); }
                | dereference /* only for solver model parsing */
                        { $$ = babelsberg__ASSIGNDEREF($1); }

constant        : T_TRUE
                        { $$ = babelsberg__TRUE; }
                | T_FALSE
                        { $$ = babelsberg__FALSE; }
                | T_NIL
                        { $$ = babelsberg__NIL; }
                | T_REALCONST
                        { $$ = babelsberg__REAL($1);}
                | T_STRING
                        { $$ = babelsberg__STRING($1);}

variable        : T_IDENT
                        { $$ = $1; }

label           : T_IDENT
                        { $$ = $1; }

reference       : T_REF
                        { $$ = $1; }

dereference     : T_H_DEREF T_LPAREN expression T_RPAREN
                        { $$ = $3; }

value           : constant
                        { $$ = babelsberg__K($1); }
                /*
                 * | objectliteral
                 *         { $$ = babelsberg__O($1); }
                 */
                | reference
                        { $$ = babelsberg__R($1); }

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
