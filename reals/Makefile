include ../../../config.cache
# VARIABLES

GOROOT = ../../..
LDLIBS =  -lfl -lm

# EVERYTHING
all:	calc


# MAIN PROGRAM

CALCOBJS= main.o lexer.o parser.o babelsbergP.o solver.o printer.o helper.o
CLEAN=calc calc.exe $(CALCOBJS) lexer.c parser.c parser.h babelsbergP.c babelsbergP.h

calc: $(CALCOBJS)
	$(LINK.rml) $(CALCOBJS) $(LDLIBS) -o calc

main.o:	 main.c babelsbergP.h

# LEXER

lexer.o:  lexer.c parser.h babelsbergP.h
lexer.c:  lexer.l
	flex -t -l lexer.l >lexer.c

# PARSER

parser.o:  parser.c babelsbergP.h
parser.c parser.h:  parser.y
	bison -d parser.y
	mv parser.tab.c parser.c
	mv parser.tab.h parser.h

# INTERFACE TO SOLVER
solver.o: solver.c

solver.c:
	touch solver.c

# ABSTRACT SYNTAX and EVALUATION

babelsbergP.o:  babelsbergP.c
babelsbergP.c babelsbergP.h:	babelsbergP.rml solver.rml printer.rml
	$(COMPILE.rml) babelsbergP.rml


printer.o:  printer.c
printer.c printer.h:	printer.rml babelsbergP.rml
	$(COMPILE.rml) printer.rml

helper.o:  helper.c
helper.c helper.h:	helper.rml babelsbergP.rml
	$(COMPILE.rml) helper.rml


# AUX

include $(GOROOT)/etc/client.mk


