module('users.timfelgentreff.babelsberg.testsuite').
requires('lively.TestFramework',
         'users.timfelgentreff.babelsberg.constraintinterpreter',
         'users.timfelgentreff.z3.CommandLineZ3').
toRun(function() {
TestCase.subclass('users.timfelgentreff.babelsberg.testsuite.SemanticsTests', {

INSERTHERE

});
});
