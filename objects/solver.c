/* Glue to call parser (and thus scanner) from RML */
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include "rml.h"
#include "babelsberg.h"
#include "parser.h"


extern int yy_scan_string(char *yy_str);
extern void* absyntree;

/* No init for this module */
void Solver_5finit(void) {}
/* The glue function */
RML_BEGIN_LABEL(Solver__solve)
{
    char *assignment;
    double rvalue = 0;
    char *first_param = RML_STRINGDATA(rmlA0);
    char c;

    printf("\n\n### These are the current constraints: %s\n", first_param);

    /* Call the alert relation, so we only print this in debug mode */
    rml_state_ARGS[0]= mk_cons(mk_scon(
	   "\n\nA terminal with your $BBBEDITOR will open. Please enter a new " \
	   "environment satisfying the constraints as 'var := value' pairs, "\
	   "each separated by a newline. Save and close finishes.\n"\
	   "To fail in the solver, just write 'unsat'.\n\n"), mk_nil());
    rml_state_ARGS[1]= mk_nil();
    rml_state_ARGS[2]= mk_nil();
    rml_prim_once(RML_LABPTR(babelsberg__alert));
    fflush(NULL);

    int exitcode = system("$BBBEDITOR input");
    if (exitcode != 0) {
	RML_TAILCALLK(rmlFC);
    }

    FILE* input = fopen("input", "r");
    void* list = mk_nil();

    while(fscanf(input, "%m[()#-{}a-zA-Z0-9.:=, \"]\n", &assignment) != EOF) {
	/* printf("%s\n", assignment); */
	yy_scan_string(assignment);
	if (yyparse() != 0) {
	    fprintf(stderr, "Parsing model failed!\n");
	    RML_TAILCALLK(rmlFC);
	}
	list = mk_cons(absyntree, list);

	free(assignment);
    }

    rmlA0 = list;
    RML_TAILCALLK(rmlSC);
}
RML_END_LABEL

RML_BEGIN_LABEL(Solver__string_5freal)
{
    char *first_param = RML_STRINGDATA(rmlA0);
    char *endptr = first_param;
    errno = 0;
    double r = strtod(first_param, &endptr);

    if (endptr == first_param || errno != 0) {
	/* printf("Conversion failed %s\n", first_param); */
	RML_TAILCALLK(rmlFC);
    }
    /* printf("Conversion success %s -> %f\n", first_param, r); */
    rmlA0 = mk_rcon(r);
    RML_TAILCALLK(rmlSC);
}
RML_END_LABEL
