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

INSERTHERE

!
