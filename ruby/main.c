/* file main.c */
/* Main program for the small babelsberg evaluator */

#include <stdio.h>
#include <stdlib.h>
#include "rml.h"
#include "ruby.h"
#include "../objects/babelsberg.h"

typedef void * rml_t;
rml_t absyntree;

yyerror(char *s)
{
  extern int yylineno;
  fprintf(stderr,"Syntax error at or near line %d.\n",yylineno);
}

main()
{
  int res;

  /* Initialize the RML modules */

  ruby_5finit();

  /* Parse the input into an abstract syntax tree (in RML form)
     using yacc and lex */

  if (yyparse() !=0)
  {
    fprintf(stderr,"Parsing failed!\n");
    exit(1);
  }

  /* Evalute it using the RML relation "eval" */

  rml_state_ARGS[0]= absyntree;
  if (!rml_prim_once(RML_LABPTR(ruby__printprogram)) )
  {
    fprintf(stderr,"Evaluation failed!\n");
    exit(2);
  }
  exit(0);
}
