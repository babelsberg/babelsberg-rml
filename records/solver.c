/* Glue to call parser (and thus scanner) from RML */
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include "rml.h"

/* No init for this module */
void Solver_5finit(void) {}
/* The glue function */
RML_BEGIN_LABEL(Solver__solve)
{
    char variable[1024] = {'\0'};
    char value[1024] = {'\0'};
    double rvalue = 0;
    char *first_param = RML_STRINGDATA(rmlA0);
    char c;

    printf("\n\n### These are the current constraints: %s\n"\
	   "\n\nA terminal with your $BBBEDITOR will open. Please enter a new " \
	   "environment satisfying the constraints as 'var[SPACE]value' pairs, "\
	   "each separated by a newline. Save and close finishes.\n"\
	   "To fail in the solver, just write 'unsat'.\n\n", first_param);
    fflush(NULL);
    int exitcode = system("$BBBEDITOR input");
    if (exitcode != 0) {
	RML_TAILCALLK(rmlFC);
    }

    FILE* input = fopen("input", "r");
    void* list = mk_nil();
    while(fscanf(input, "%s %s\n", variable, value) != EOF) {
	list = mk_cons(mk_scon(value), list);
	list = mk_cons(mk_scon(variable), list);
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
