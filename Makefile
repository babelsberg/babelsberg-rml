include ../../../config.cache
# VARIABLES

GOROOT = ../../..
LDLIBS =  -lfl -lm

# EVERYTHING
all:	calc


# MAIN PROGRAM

CALCOBJS= main.o lexer.o parser.o babelsbergP.o
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


# ABSTRACT SYNTAX and EVALUATION

babelsbergP.o:  babelsbergP.c
babelsbergP.c babelsbergP.h:	babelsbergP.rml
	$(COMPILE.rml) babelsbergP.rml

# AUX

include $(GOROOT)/etc/client.mk


