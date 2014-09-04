# VARIABLES

GOROOT = ../../..
LDLIBS =  -lfl -lm

# EVERYTHING
all:	calc


# MAIN PROGRAM

CALCOBJS= main.o lexer.o parser.o assigntwotype.o
CLEAN=calc calc.exe $(CALCOBJS) lexer.c parser.c parser.h assigntwotype.c assigntwotype.h

calc: $(CALCOBJS)
	$(LINK.rml) $(CALCOBJS) $(LDLIBS) -o calc

main.o:	 main.c assigntwotype.h

# LEXER

lexer.o:  lexer.c parser.h assigntwotype.h
lexer.c:  lexer.l
	flex -t -l lexer.l >lexer.c

# PARSER

parser.o:  parser.c assigntwotype.h
parser.c parser.h:  parser.y
	bison -d parser.y
	mv parser.tab.c parser.c
	mv parser.tab.h parser.h


# ABSTRACT SYNTAX and EVALUATION

assigntwotype.o:  assigntwotype.c
assigntwotype.c assigntwotype.h:	assigntwotype.rml
	$(COMPILE.rml) assigntwotype.rml

# AUX

include $(GOROOT)/etc/client.mk


