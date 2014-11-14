/* Glue to call parser (and thus scanner) from RML */
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include "rml.h"
#include "javascript.h"
#include "../objects/parser.h"


extern int yy_scan_string(char *yy_str);
extern void* absyntree;

int ciindex = -1;

/* No init for this module */
void Assertions_5finit(void) {}
/* The glue function */
RML_BEGIN_LABEL(Assertions__assert)
{
    int first_param = RML_UNTAGFIXNUM(rmlA0);
    char *assignment;
    char cmd[255];
    ciindex += first_param;
    snprintf(cmd, 255, "$BBBASSERTRB input %d", ciindex);
    int exitcode = system(cmd);
    if (exitcode != 0) {
	RML_TAILCALLK(rmlFC);
    }

    FILE* input = fopen("input", "r");
    while(fscanf(input, "%m[()#-{}a-zA-Z0-9.:=, \"]\n", &assignment) != EOF) {
	/* printf("%s\n", assignment); */
	yy_scan_string(assignment);
	if (yyparse() != 0) {
	    fprintf(stderr, "Parsing model failed!\n");
	    RML_TAILCALLK(rmlFC);
	}
	rml_state_ARGS[0] = absyntree;
	rml_prim_once(RML_LABPTR(javascript__printassert));
	free(assignment);
    }
    rmlA0 = mk_nil();
    RML_TAILCALLK(rmlSC);
}
RML_END_LABEL
