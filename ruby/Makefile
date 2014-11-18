include ../rml/config.cache
# VARIABLES

SHELL=/bin/sh
COMPILE.rml=$(RMLC) $(RMLCFLAGS) $(CPPFLAGS) -c
LINK.rml=$(RMLC) $(RMLCFLAGS)
GOROOT = ../rml
LDLIBS =  -lfl -lm
RMLC=$(PREFIX)/bin/rmlc


BIN = babelsberg-ruby


# EVERYTHING
all: $(BIN)


# MAIN PROGRAM

CALCOBJS= main.o ruby.o assertions.o $(OBJECTOBJS)
CLEAN=$(BIN) $(BIN).exe $(CALCOBJS) ruby.c ruby.h

$(BIN): OBJECTOBJS=$(subst ../objects/main.o, , $(shell ls ../objects/*.o))
$(BIN): $(CALCOBJS)
	$(LINK.rml) $(CALCOBJS) $(LDLIBS) -o $(BIN)

main.o:	 main.c ruby.h

# ABSTRACT SYNTAX and EVALUATION

../objects/babelsberg.h:
	cd ../objects/; $(MAKE)

ruby.o:  ruby.c ../objects/babelsberg.h
ruby.c ruby.h: ruby.rml assertions.rml
	$(COMPILE.rml) ruby.rml

assertions.o: assertions.c assertions.rml
assertions.c:
	touch assertions.c

.c.o:
	$(COMPILE.rml) $<

clean:
	rm -f a.out core mon.out gmon.out $(CLEAN) *.ast *.cps *.fol *~ *.rdb *.srz *.sig *.rmod *.rsig
