include ../rml/config.cache
# VARIABLES

SHELL=/bin/sh
COMPILE.rml=$(RMLC) $(RMLCFLAGS) $(CPPFLAGS) -c
LINK.rml=$(RMLC) $(RMLCFLAGS)
GOROOT = ../rml
LDLIBS =  -lfl -lm
RMLC=$(PREFIX)/bin/rmlc


BIN = babelsberg-javascript


# EVERYTHING
all: $(BIN)


# MAIN PROGRAM

CALCOBJS= main.o javascript.o $(OBJECTOBJS)
CLEAN=$(BIN) $(BIN).exe $(CALCOBJS) javascript.c javascript.h

$(BIN): OBJECTOBJS=$(subst ../objects/main.o, , $(shell ls ../objects/*.o))
$(BIN): $(CALCOBJS)
	$(LINK.rml) $(CALCOBJS) $(LDLIBS) -o $(BIN)

main.o:	 main.c javascript.h

# ABSTRACT SYNTAX and EVALUATION

../objects/babelsberg.h:
	cd ../objects/; $(MAKE)

javascript.o:  javascript.c ../objects/babelsberg.h
javascript.c javascript.h: javascript.rml
	$(COMPILE.rml) javascript.rml

.c.o:
	$(COMPILE.rml) $<

clean:
	rm -f a.out core mon.out gmon.out $(CLEAN) *.ast *.cps *.fol *~ *.rdb *.srz *.sig *.rmod *.rsig
