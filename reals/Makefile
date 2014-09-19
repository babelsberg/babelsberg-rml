include ../rml/config.cache
# VARIABLES

GOROOT = ../rml
LDLIBS =  -lfl -lm
BIN = babelsberg-reals

# EVERYTHING
all: $(BIN)


# MAIN PROGRAM

CALCOBJS= main.o lexer.o parser.o babelsberg.o solver.o printer.o helper.o
CLEAN=$(BIN) $(BIN).exe $(CALCOBJS) lexer.c parser.c parser.h babelsberg.c babelsberg.h

$(BIN): $(CALCOBJS)
	$(LINK.rml) $(CALCOBJS) $(LDLIBS) -o $(BIN)

main.o:	 main.c babelsberg.h

# LEXER

lexer.o:  lexer.c parser.h babelsberg.h
lexer.c:  lexer.l
	flex -t -l lexer.l >lexer.c

# PARSER

parser.o:  parser.c babelsberg.h
parser.c parser.h:  parser.y
	bison -d parser.y
	mv parser.tab.c parser.c
	mv parser.tab.h parser.h

# INTERFACE TO SOLVER
solver.o: solver.c

solver.c:
	touch solver.c

# ABSTRACT SYNTAX and EVALUATION

babelsberg.o:  babelsberg.c
babelsberg.c babelsberg.h:	babelsberg.rml solver.rml printer.rml
	$(COMPILE.rml) babelsberg.rml


printer.o:  printer.c
printer.c printer.h:	printer.rml babelsberg.rml
	$(COMPILE.rml) printer.rml

helper.o:  helper.c
helper.c helper.h:	helper.rml babelsberg.rml
	$(COMPILE.rml) helper.rml


# AUX

include $(GOROOT)/etc/client.mk


