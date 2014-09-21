Babelsberg/RML
==============

[![Build Status](https://travis-ci.org/babelsberg/babelsberg-rml.svg?branch=master)](https://travis-ci.org/babelsberg/babelsberg-rml)

An RML implementation of Babelsberg's Natural Semantics, available [here](http://www.vpri.org/pdf/tr2014002_babelsberg.pdf).

You need to `git submodule init && git submodule update` to clone the
rml source tree. Follow the `INSTALL` file in the rml subdirectory to
build rml (Note that running `make install` as non-root will
suffice - you do not need to install it globally.)

This project uses Ruby's `rake` build tool to build and run the
examples, but you can also just go into the subdirectories for the
various implementations directly to build and run them from there
using ordinary Makefiles.
