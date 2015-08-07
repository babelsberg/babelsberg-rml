(Smalltalk at: #BabelsbergIRecord ifAbsent: []) ifNotNilDo: [:c |
  c removeFromSystem].!

(Smalltalk at: #BabelsbergHRecord ifAbsent: []) ifNotNilDo: [:c |
  c removeFromSystem].!

(Smalltalk at: #BabelsbergTestSuiteHelper ifAbsent: []) ifNotNilDo: [:c |
  c removeFromSystem].!

(Smalltalk at: #BabelsbergTestSuiteContextClass ifAbsent: []) ifNotNilDo: [:c |
  c removeFromSystem].!

(Smalltalk at: #BabelsbergTestSuite ifAbsent: []) ifNotNilDo: [:c |
  c removeFromSystem].!

Object subclass: #BabelsbergTestSuiteContextClass
  instanceVariableNames: 'a b c x y z def pA pB pt p q m unsat temp r'
  classVariableNames: ''
  poolDictionaries: ''
  category: 'Babelsberg-Tests'!

[:aClass| | cr |
    cr := String with: Character cr.
    aClass instVarNames do:
      [:aName | | newMessage setter |
      (aClass canUnderstand: aName asSymbol) ifFalse:
  [newMessage :=
    aName, cr, cr,
    ' ^ ', aName.
  aClass compile: newMessage classified: #accessing notifying: nil].
      (aClass canUnderstand: (setter := aName, ':') asSymbol) ifFalse:
  [newMessage :=
    setter, ' anObject', cr, cr,
      (aClass settersReturnValue ifTrue: [' ^'] ifFalse: [' ']),
      aName, ' := anObject'.
  aClass compile: newMessage classified: #accessing notifying: nil]]]
   value: BabelsbergTestSuiteContextClass.!

Dictionary subclass: #BabelsbergHRecord
  instanceVariableNames: ''
  classVariableNames: ''
  poolDictionaries: ''
  category: 'Constraints-Core'!

Dictionary subclass: #BabelsbergIRecord
  instanceVariableNames: ''
  classVariableNames: ''
  poolDictionaries: ''
  category: 'Constraints-Core'!

!BabelsbergIRecord methodsFor: 'running' stamp: 'tfel 11/18/2014'!
doesNotUnderstand: aMessage
  (self keys includes: aMessage selector)
    ifTrue: [^ self at: aMessage selector].
  ^ super doesNotUnderstand: aMessage!

== other
  ^ self = other! !

!BabelsbergHRecord methodsFor: 'running' stamp: 'tfel 11/18/2014'!
doesNotUnderstand: aMessage
  (self keys includes: aMessage selector)
    ifTrue: [^ self at: aMessage selector].
  (aMessage selector asString endsWith: ':' and: [
      self keys includes: aMessage selector asString allButLast])
    ifTrue: [^ self
     at: aMessage selector asString allButLast asSymbol
     put: aMessage argument].
  ^ super doesNotUnderstand: aMessage! !


TestCase subclass: #BabelsbergTestSuite
  instanceVariableNames: 'ctx'
  classVariableNames: ''
  poolDictionaries: ''
  category: 'Babelsberg-Tests'!

!BabelsbergTestSuite methodsFor: 'running' stamp: 'tfel 11/18/2014'!

assert: v variable: var equals: expected butIs: got
  self
    assert: v
    description: 'Expected ', var, ' to equal ', expected, ' but got ', got.!

assert: v value: var identicalTo: expected
  self
    assert: v
    description: 'Expected ', var, ' to be identical to ', expected.!


setUp
  ctx := BabelsbergTestSuiteContextClass new.! !


!BabelsbergTestSuite methodsFor: 'testing' stamp: 'tfel 11/18/2014'!

test1
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 3.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 3.0
    variable: 'ctx x'
    equals: 3.0
    butIs: ctx x.
  [ctx x: 4.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 4.0
    variable: 'ctx x'
    equals: 4.0
    butIs: ctx x.
  [[(ctx x) >= (10.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 10.0
    variable: 'ctx x'
    equals: 10.0
    butIs: ctx x.
!


test2
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 3.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 3.0
    variable: 'ctx x'
    equals: 3.0
    butIs: ctx x.
  [ctx y: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 3.0
    variable: 'ctx x'
    equals: 3.0
    butIs: ctx x.
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  [[(ctx y) = ((ctx x) + (100.0))] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 3.0
    variable: 'ctx x'
    equals: 3.0
    butIs: ctx x.
  self
    assert:ctx y = 103.0
    variable: 'ctx y'
    equals: 103.0
    butIs: ctx y.
  [ctx x: (ctx x) + (2.0)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  self
    assert:ctx y = 105.0
    variable: 'ctx y'
    equals: 105.0
    butIs: ctx y.
!


test3
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [[(ctx x) = (10.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test4
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  [ctx y: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  [ctx z: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  self
    assert:ctx z = 0.0
    variable: 'ctx z'
    equals: 0.0
    butIs: ctx z.
  [[(((ctx x) + (ctx y)) + ((2.0) * (ctx z))) = (10.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 10.0
    variable: 'ctx x'
    equals: 10.0
    butIs: ctx x.
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  self
    assert:ctx z = 0.0
    variable: 'ctx z'
    equals: 0.0
    butIs: ctx z.
  [[((((2.0) * (ctx x)) + (ctx y)) + (ctx z)) = (20.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 10.0
    variable: 'ctx x'
    equals: 10.0
    butIs: ctx x.
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  self
    assert:ctx z = 0.0
    variable: 'ctx z'
    equals: 0.0
    butIs: ctx z.
  [ctx x: 100.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 100.0
    variable: 'ctx x'
    equals: 100.0
    butIs: ctx x.
  self
    assert:ctx y = -270.0
    variable: 'ctx y'
    equals: -270.0
    butIs: ctx y.
  self
    assert:ctx z = 90.0
    variable: 'ctx z'
    equals: 90.0
    butIs: ctx z.
!


test5
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 5.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  [[(ctx x) <= (10.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  [ctx x: (ctx x) + (15.0)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test6
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 4.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 4.0
    variable: 'ctx x'
    equals: 4.0
    butIs: ctx x.
  (((ctx x) = (4.0)) or: (((ctx x) / (0.0)) = (10.0)))
    ifTrue: [
    [ctx x: 100.0]
      on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 100.0
    variable: 'ctx x'
    equals: 100.0
    butIs: ctx x.
]
    ifFalse: [
    [ctx x: 200.0]
      on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
].
!


test7
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  [[(((ctx x) = (4.0)) and: ((ctx x) = (5.0))) or: (((ctx x) ~= (4.0)) and: ((ctx x) = (10.0)))] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 10.0
    variable: 'ctx x'
    equals: 10.0
    butIs: ctx x.
!


test8
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 5.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  [ctx x: 'Hello']
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 'Hello'
    variable: 'ctx x'
    equals: 'Hello'
    butIs: ctx x.
!


test9
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 5.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  [ctx y: 10.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  self
    assert:ctx y = 10.0
    variable: 'ctx y'
    equals: 10.0
    butIs: ctx y.
  [[(ctx y) = (ctx x)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  self
    assert:ctx y = 5.0
    variable: 'ctx y'
    equals: 5.0
    butIs: ctx y.
  [ctx x: 'Hello']
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 'Hello'
    variable: 'ctx x'
    equals: 'Hello'
    butIs: ctx x.
  self
    assert:ctx y = 'Hello'
    variable: 'ctx y'
    equals: 'Hello'
    butIs: ctx y.
!


test10
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 5.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  [ctx y: 10.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  self
    assert:ctx y = 10.0
    variable: 'ctx y'
    equals: 10.0
    butIs: ctx y.
  [[(ctx y) = ((ctx x) + (ctx x))] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 5.0
    variable: 'ctx x'
    equals: 5.0
    butIs: ctx x.
  self
    assert:ctx y = 10.0
    variable: 'ctx y'
    equals: 10.0
    butIs: ctx y.
  [ctx x: 'Hello']
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 'Hello'
    variable: 'ctx x'
    equals: 'Hello'
    butIs: ctx x.
  self
    assert:ctx y = 'HelloHello'
    variable: 'ctx y'
    equals: 'HelloHello'
    butIs: ctx y.
!


test11
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 3.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 3.0
    variable: 'ctx x'
    equals: 3.0
    butIs: ctx x.
  [[(ctx x) = (5.0)] alwaysSolveWith: z3 "priority: ConstraintPriority weak"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 3.0
    variable: 'ctx x'
    equals: 3.0
    butIs: ctx x.
  [[(ctx x) = ('hello')] alwaysSolveWith: z3 "priority: ConstraintPriority weak"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 3.0
    variable: 'ctx x'
    equals: 3.0
    butIs: ctx x.
!


test12
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0). #y -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  [ctx a: ctx p x]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx a = 2.0
    variable: 'ctx a'
    equals: 2.0
    butIs: ctx a.
  [ctx q: ctx p]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx a = 2.0
    variable: 'ctx a'
    equals: 2.0
    butIs: ctx a.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
  [[(ctx p x) = (100.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx a = 2.0
    variable: 'ctx a'
    equals: 2.0
    butIs: ctx a.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
  [[(ctx q) = (ctx p)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx a = 2.0
    variable: 'ctx a'
    equals: 2.0
    butIs: ctx a.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
  [[(ctx q y) = (20.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (20.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (20.0)})
    butIs: ctx p.
  self
    assert:ctx a = 2.0
    variable: 'ctx a'
    equals: 2.0
    butIs: ctx a.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
!


test13
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergHRecord newFrom: {#x -> (1.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  [ctx a: (BabelsbergHRecord newFrom: {#y -> (10.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#y -> (10.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#y -> (10.0)})
    butIs: ctx a.
!


test14
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergHRecord newFrom: {#x -> (1.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  [ctx temp: (BabelsbergHRecord newFrom: {#y -> (10.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  self
    assert:ctx temp = (BabelsbergIRecord newFrom: {#y -> (10.0)})
    variable: 'ctx temp'
    equals: (BabelsbergIRecord newFrom: {#y -> (10.0)})
    butIs: ctx temp.
  [([(ctx a) = (ctx temp)] alwaysSolveWith: z3 "priority: ConstraintPriority required") disable]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test15
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergIRecord newFrom: {#x -> (1.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  [ctx b: (BabelsbergIRecord newFrom: {#x -> (2.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  self
    assert:ctx b = (BabelsbergIRecord newFrom: {#x -> (2.0)})
    variable: 'ctx b'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0)})
    butIs: ctx b.
  [[(ctx a) = (ctx b)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  self
    assert:ctx b = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx b'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx b.
  [ctx a: (BabelsbergIRecord newFrom: {#x -> (1.0). #y -> (10.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test17
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergHRecord newFrom: {#y -> (10.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#y -> (10.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#y -> (10.0)})
    butIs: ctx a.
  [[(ctx b) = (ctx a)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test18
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0)})
    butIs: ctx p.
  [[(ctx p y) = (100.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test19
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0)})
    butIs: ctx p.
  [[(ctx p) = (5.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test20
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (0.0). #y -> (0.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    butIs: ctx p.
  [[(ctx p x) = (100.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (0.0)})
    butIs: ctx p.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0). #y -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    butIs: ctx p.
!


test22
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergHRecord newFrom: {#x -> (0.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (0.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0)})
    butIs: ctx a.
  [ctx b: (BabelsbergHRecord newFrom: {#y -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (0.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0)})
    butIs: ctx a.
  self
    assert:ctx b = (BabelsbergIRecord newFrom: {#y -> (5.0)})
    variable: 'ctx b'
    equals: (BabelsbergIRecord newFrom: {#y -> (5.0)})
    butIs: ctx b.
  [[(ctx a) = (ctx b)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test23
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (0.0). #y -> (0.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    butIs: ctx p.
  [([(ctx p x) = (100.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required") disable]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (0.0)})
    butIs: ctx p.
!


test24
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0). #y -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  [ctx a: ctx p x]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx a = 2.0
    variable: 'ctx a'
    equals: 2.0
    butIs: ctx a.
  [ctx p x: 6.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (6.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (6.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx a = 2.0
    variable: 'ctx a'
    equals: 2.0
    butIs: ctx a.
  [[(ctx p x) = (100.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx a = 2.0
    variable: 'ctx a'
    equals: 2.0
    butIs: ctx a.
!


test25
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0). #y -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  [[(ctx p z) = (5.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test26
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0). #y -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  [ctx q: ctx p]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
  [ctx p x: 100.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
  [ctx q: (BabelsbergHRecord newFrom: {#z -> (10.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#z -> (10.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#z -> (10.0)})
    butIs: ctx q.
  [ctx p x: 200.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (200.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (200.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#z -> (10.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#z -> (10.0)})
    butIs: ctx q.
!


test27
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0). #y -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  [ctx q: ctx p]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (5.0)})
    butIs: ctx p.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
  [[(ctx q) == (ctx p)] alwaysSolveWith: z3]
    on: Error do: [:e | ctx unsat: true].
  [ctx q: (BabelsbergHRecord newFrom: {#z -> (10.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#z -> (10.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#z -> (10.0)})
    butIs: ctx p.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
!


test28
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (2.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0)})
    butIs: ctx p.
  [ctx q: (BabelsbergHRecord newFrom: {#y -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (2.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0)})
    butIs: ctx p.
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#y -> (5.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#y -> (5.0)})
    butIs: ctx q.
  [[(ctx q) == (ctx p)] alwaysSolveWith: z3]
    on: Error do: [:e | ctx unsat: true].
!


test29
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (BabelsbergHRecord newFrom: {#x -> (0.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0)})
    butIs: ctx p.
  [ctx q: (BabelsbergHRecord newFrom: {#x -> (5.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0)})
    butIs: ctx p.
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#x -> (5.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#x -> (5.0)})
    butIs: ctx q.
  [[(ctx p x) = (0.0)] alwaysSolveWith: z3 "priority: ConstraintPriority medium"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0)})
    butIs: ctx p.
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#x -> (5.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#x -> (5.0)})
    butIs: ctx q.
  [[(ctx q x) = (5.0)] alwaysSolveWith: z3 "priority: ConstraintPriority medium"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0)})
    butIs: ctx p.
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#x -> (5.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#x -> (5.0)})
    butIs: ctx q.
  [[(ctx p) == (ctx q)] alwaysSolveWith: z3 "priority: ConstraintPriority weak"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test30
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergHRecord newFrom: {#x -> (1.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  [ctx b: ctx a]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  self
    assert: ctx b == ctx a
    value:  'ctx b'
    identicalTo: 'ctx a'.
  [[(ctx a x) = (1.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  self
    assert: ctx b == ctx a
    value:  'ctx b'
    identicalTo: 'ctx a'.
  [[(ctx b x) = (2.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test31
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergHRecord newFrom: {#x -> (1.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  [ctx b: ctx a]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  self
    assert: ctx b == ctx a
    value:  'ctx b'
    identicalTo: 'ctx a'.
  [ctx c: (BabelsbergHRecord newFrom: {#x -> (2.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  self
    assert: ctx b == ctx a
    value:  'ctx b'
    identicalTo: 'ctx a'.
  self
    assert:ctx c = (BabelsbergIRecord newFrom: {#x -> (2.0)})
    variable: 'ctx c'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0)})
    butIs: ctx c.
  [[(ctx a x) = (1.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#x -> (1.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#x -> (1.0)})
    butIs: ctx a.
  self
    assert: ctx b == ctx a
    value:  'ctx b'
    identicalTo: 'ctx a'.
  self
    assert:ctx c = (BabelsbergIRecord newFrom: {#x -> (2.0)})
    variable: 'ctx c'
    equals: (BabelsbergIRecord newFrom: {#x -> (2.0)})
    butIs: ctx c.
  [[(ctx b x) = (2.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test32b
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx r: (BabelsbergHRecord newFrom: {#upper_left -> ((nil Point: 2.0 and: 2.0)). #lower_right -> ((nil Point: 10.0 and: 10.0))})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx r = (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)}))})
    variable: 'ctx r'
    equals: (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)}))})
    butIs: ctx r.
  [[(ctx r center ptEq: (nil Point: 2.0 and: 2.0))] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx r = (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (3.0). #y -> (3.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (1.0). #y -> (1.0)}))})
    variable: 'ctx r'
    equals: (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (3.0). #y -> (3.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (1.0). #y -> (1.0)}))})
    butIs: ctx r.
  [([(ctx r center x) = (100.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required") disable]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test32c
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx r: (BabelsbergHRecord newFrom: {#upper_left -> ((nil Point: 2.0 and: 2.0)). #lower_right -> ((nil Point: 10.0 and: 10.0))})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx r = (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)}))})
    variable: 'ctx r'
    equals: (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)}))})
    butIs: ctx r.
  [[(ctx r center ptEq: (nil Point: 2.0 and: 2.0))] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx r = (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)}))})
    variable: 'ctx r'
    equals: (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)}))})
    butIs: ctx r.
  [ctx r upper_left x: 100.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx r = (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (-96.0). #y -> (4.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (0.0)}))})
    variable: 'ctx r'
    equals: (BabelsbergIRecord newFrom: {#lower_right -> ((BabelsbergIRecord newFrom: {#x -> (-96.0). #y -> (4.0)})). #upper_left -> ((BabelsbergIRecord newFrom: {#x -> (100.0). #y -> (0.0)}))})
    butIs: ctx r.
!


test32
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx r: (BabelsbergHRecord newFrom: {#upper_left -> ((nil Point: 2.0 and: 2.0)). #lower_right -> ((nil Point: 10.0 and: 10.0))})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx r = (BabelsbergIRecord newFrom: {#upper_left -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)})). #lower_right -> ((BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)}))})
    variable: 'ctx r'
    equals: (BabelsbergIRecord newFrom: {#upper_left -> ((BabelsbergIRecord newFrom: {#x -> (2.0). #y -> (2.0)})). #lower_right -> ((BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)}))})
    butIs: ctx r.
  [[(ctx r center ptEq: (nil Point: 2.0 and: 2.0))] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx r = (BabelsbergIRecord newFrom: {#upper_left -> ((BabelsbergIRecord newFrom: {#x -> (1.0). #y -> (1.0)})). #lower_right -> ((BabelsbergIRecord newFrom: {#x -> (3.0). #y -> (3.0)}))})
    variable: 'ctx r'
    equals: (BabelsbergIRecord newFrom: {#upper_left -> ((BabelsbergIRecord newFrom: {#x -> (1.0). #y -> (1.0)})). #lower_right -> ((BabelsbergIRecord newFrom: {#x -> (3.0). #y -> (3.0)}))})
    butIs: ctx r.
  [ctx r center x: 100.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test33
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx y: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  [ctx x: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  [[(ctx y) = (ctx x double)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  [ctx y: 20.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx y = 20.0
    variable: 'ctx y'
    equals: 20.0
    butIs: ctx y.
  self
    assert:ctx x = 10.0
    variable: 'ctx x'
    equals: 10.0
    butIs: ctx x.
  [ctx x: 7.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx y = 14.0
    variable: 'ctx y'
    equals: 14.0
    butIs: ctx y.
  self
    assert:ctx x = 7.0
    variable: 'ctx x'
    equals: 7.0
    butIs: ctx x.
!


test34
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergHRecord newFrom: {#balance -> (0.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#balance -> (0.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#balance -> (0.0)})
    butIs: ctx a.
  [ctx m: 10.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#balance -> (0.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#balance -> (0.0)})
    butIs: ctx a.
  self
    assert:ctx m = 10.0
    variable: 'ctx m'
    equals: 10.0
    butIs: ctx m.
  [ctx def: (nil Require_min_balance: ctx a and: ctx m)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#balance -> (11.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#balance -> (11.0)})
    butIs: ctx a.
  self
    assert:ctx m = 10.0
    variable: 'ctx m'
    equals: 10.0
    butIs: ctx m.
  [ctx m: 100.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#balance -> (11.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#balance -> (11.0)})
    butIs: ctx a.
  self
    assert:ctx m = 100.0
    variable: 'ctx m'
    equals: 100.0
    butIs: ctx m.
!


test35
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: (BabelsbergHRecord newFrom: {#balance -> (0.0)})]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#balance -> (0.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#balance -> (0.0)})
    butIs: ctx a.
  [ctx m: 10.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#balance -> (0.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#balance -> (0.0)})
    butIs: ctx a.
  self
    assert:ctx m = 10.0
    variable: 'ctx m'
    equals: 10.0
    butIs: ctx m.
  [[(nil Has_min_balance: ctx a and: ctx m value)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#balance -> (11.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#balance -> (11.0)})
    butIs: ctx a.
  self
    assert:ctx m = 10.0
    variable: 'ctx m'
    equals: 10.0
    butIs: ctx m.
  [ctx m: 100.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = (BabelsbergIRecord newFrom: {#balance -> (101.0)})
    variable: 'ctx a'
    equals: (BabelsbergIRecord newFrom: {#balance -> (101.0)})
    butIs: ctx a.
  self
    assert:ctx m = 100.0
    variable: 'ctx m'
    equals: 100.0
    butIs: ctx m.
!


test36
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  [ctx y: (nil Test: ctx x)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  self
    assert:ctx y = 6.0
    variable: 'ctx y'
    equals: 6.0
    butIs: ctx y.
  [[(ctx x) = (10.0)] alwaysSolveWith: z3 "priority: ConstraintPriority medium"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 10.0
    variable: 'ctx x'
    equals: 10.0
    butIs: ctx x.
  self
    assert:ctx y = 6.0
    variable: 'ctx y'
    equals: 6.0
    butIs: ctx y.
  [[(ctx y) = ((nil Test: ctx x))] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test40
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx pA: (nil MutablePointNew: 10.0 and: 10.0)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx pA = (BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})
    variable: 'ctx pA'
    equals: (BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})
    butIs: ctx pA.
  [ctx pB: ctx pA]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx pA = (BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})
    variable: 'ctx pA'
    equals: (BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})
    butIs: ctx pA.
  self
    assert: ctx pB == ctx pA
    value:  'ctx pB'
    identicalTo: 'ctx pA'.
  [ctx pA: (nil MutablePointNew: 50.0 and: 50.0)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx pA = (BabelsbergIRecord newFrom: {#x -> (50.0). #y -> (50.0)})
    variable: 'ctx pA'
    equals: (BabelsbergIRecord newFrom: {#x -> (50.0). #y -> (50.0)})
    butIs: ctx pA.
  self
    assert:ctx pB = (BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})
    variable: 'ctx pB'
    equals: (BabelsbergIRecord newFrom: {#x -> (10.0). #y -> (10.0)})
    butIs: ctx pB.
!


test41
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx p: (nil MutablePointNew: 0.0 and: 0.0)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    butIs: ctx p.
  [ctx q: ctx p]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    butIs: ctx p.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
  [[(ctx p x) = (5.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx p = (BabelsbergIRecord newFrom: {#x -> (5.0). #y -> (0.0)})
    variable: 'ctx p'
    equals: (BabelsbergIRecord newFrom: {#x -> (5.0). #y -> (0.0)})
    butIs: ctx p.
  self
    assert: ctx q == ctx p
    value:  'ctx q'
    identicalTo: 'ctx p'.
  [[(ctx q x) = (10.0)] alwaysSolveWith: z3 "priority: ConstraintPriority required"]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx unsat = true
    variable: 'ctx unsat'
    equals: true
    butIs: ctx unsat.
!


test42
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: nil WindowNew]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = (BabelsbergIRecord newFrom: {#window -> (true)})
    variable: 'ctx x'
    equals: (BabelsbergIRecord newFrom: {#window -> (true)})
    butIs: ctx x.
  [ctx y: ctx x]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = (BabelsbergIRecord newFrom: {#window -> (true)})
    variable: 'ctx x'
    equals: (BabelsbergIRecord newFrom: {#window -> (true)})
    butIs: ctx x.
  self
    assert: ctx y == ctx x
    value:  'ctx y'
    identicalTo: 'ctx x'.
  [[(ctx y) == (ctx x)] alwaysSolveWith: z3]
    on: Error do: [:e | ctx unsat: true].
  [ctx x: nil CircleNew]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = (BabelsbergIRecord newFrom: {#circle -> (true)})
    variable: 'ctx x'
    equals: (BabelsbergIRecord newFrom: {#circle -> (true)})
    butIs: ctx x.
  self
    assert: ctx y == ctx x
    value:  'ctx y'
    identicalTo: 'ctx x'.
!


test43
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: nil WindowNew]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = (BabelsbergIRecord newFrom: {#window -> (true)})
    variable: 'ctx x'
    equals: (BabelsbergIRecord newFrom: {#window -> (true)})
    butIs: ctx x.
  [ctx y: ctx x]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = (BabelsbergIRecord newFrom: {#window -> (true)})
    variable: 'ctx x'
    equals: (BabelsbergIRecord newFrom: {#window -> (true)})
    butIs: ctx x.
  self
    assert: ctx y == ctx x
    value:  'ctx y'
    identicalTo: 'ctx x'.
  [ctx def: (nil MakeIdentical: ctx x and: ctx y)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = (BabelsbergIRecord newFrom: {#window -> (true)})
    variable: 'ctx x'
    equals: (BabelsbergIRecord newFrom: {#window -> (true)})
    butIs: ctx x.
  self
    assert: ctx y == ctx x
    value:  'ctx y'
    identicalTo: 'ctx x'.
  [ctx x: nil CircleNew]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx y = (BabelsbergIRecord newFrom: {#window -> (true)})
    variable: 'ctx y'
    equals: (BabelsbergIRecord newFrom: {#window -> (true)})
    butIs: ctx y.
  self
    assert:ctx x = (BabelsbergIRecord newFrom: {#circle -> (true)})
    variable: 'ctx x'
    equals: (BabelsbergIRecord newFrom: {#circle -> (true)})
    butIs: ctx x.
!


test45
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx a: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = 0.0
    variable: 'ctx a'
    equals: 0.0
    butIs: ctx a.
  [ctx def: (nil Testalwaysxequal5: ctx a)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx a = 0.0
    variable: 'ctx a'
    equals: 0.0
    butIs: ctx a.
!


test46
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx x: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  [ctx y: 0.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  [ctx def: (nil Testalwaysaequalsbplus3: ctx x and: ctx y)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 0.0
    variable: 'ctx x'
    equals: 0.0
    butIs: ctx x.
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  [ctx x: 10.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 10.0
    variable: 'ctx x'
    equals: 10.0
    butIs: ctx x.
  self
    assert:ctx y = 0.0
    variable: 'ctx y'
    equals: 0.0
    butIs: ctx y.
  [ctx y: 10.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx x = 10.0
    variable: 'ctx x'
    equals: 10.0
    butIs: ctx x.
  self
    assert:ctx y = 10.0
    variable: 'ctx y'
    equals: 10.0
    butIs: ctx y.
!


test47
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx q: (nil Point: 0.0 and: 0.0)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    butIs: ctx q.
  [ctx def: (nil Testpointxequals5: ctx q)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    butIs: ctx q.
!


test48
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx q: (nil MutablePointNew: 0.0 and: 0.0)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#x -> (0.0). #y -> (0.0)})
    butIs: ctx q.
  [ctx def: (nil Testpointxequals5: ctx q)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx q = (BabelsbergIRecord newFrom: {#x -> (5.0). #y -> (0.0)})
    variable: 'ctx q'
    equals: (BabelsbergIRecord newFrom: {#x -> (5.0). #y -> (0.0)})
    butIs: ctx q.
!


test49
  | z3 |
  z3 := ConstraintSolver newZ3Solver.
  [ctx y: 10.0]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx y = 10.0
    variable: 'ctx y'
    equals: 10.0
    butIs: ctx y.
  [ctx def: (nil TestXGetsXPlus3ReturnX: ctx y)]
    on: Error do: [:e | ctx unsat: true].
  self
    assert:ctx y = 10.0
    variable: 'ctx y'
    equals: 10.0
    butIs: ctx y.
!



!
