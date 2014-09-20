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
    char *variable;
    char *value;
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

    while(fscanf(input, "%ms %m[-{}a-zA-Z0-9.:, \"]\n", &variable, &value) != EOF) {
	printf("%s - %s\n", variable, value);
	yy_scan_string(value);
	if (yyparse() != 0) {
	    fprintf(stderr, "Parsing model failed!\n");
	    RML_TAILCALLK(rmlFC);
	}
	list = mk_cons(babelsberg__BINDING(mk_scon(variable),
					   absyntree),
		       list);

	free(variable);
	free(value);
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
