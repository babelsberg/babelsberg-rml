Notes on the current problems with the Z3 solver

# General
- suspected bug in Z3: when using soft constraints, sometimes Z3 will
  make a variable be {} when it should just be a real, or a real when
  it should be record. which depends on if we define value as
    (declare-datatypes () ((Value (Real (real Real))
			      (Record (rec (Array Label Real)))
                              (Bool (bool Bool))
                              (Reference (ref Reference)))))
  or
    (declare-datatypes () ((Value (Record (rec (Array Label Real)))
                              (Real (real Real))
			      (Bool (bool Bool))
                              (Reference (ref Reference)))))

# Examples that fail regardless of the above problem

4 - Z3 just finds a different, but valid solution
8,9,10 - Z3 cannot solve this, uses Strings
15 - Z3 just finds a different, but valid solution
32,32b,32c - Z3 just finds a different, but valid solution
34,35 - Z3 does not see the read-only annotation, but finds valid
        solutions disregarding that
46 - Z3 just finds a different, but valid solution
47 - Appears to be another bug, p6 has a soft constraint to be
     {x:0,y:0} and a required one to have p6.x = 5, but z3 produces a
     record that has {x:5} (with the default value in the model 3.0??)
