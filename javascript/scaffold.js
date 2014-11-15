module('users.timfelgentreff.babelsberg.testsuite').
requires('lively.TestFramework',
         'users.timfelgentreff.babelsberg.constraintinterpreter',
         'users.timfelgentreff.z3.CommandLineZ3').
toRun(function() {

    function assert(v) { if (!v) { throw 'Assertion failed' } }

    function fieldEquals(o1, o2) {
        for (var key in o1) {
            if (o1[key] !== o2[key]) return false;
        }
        for (var key in o2) {
            if (o1[key] !== o2[key]) return false;
        }
        return true;
    }

    function one() {
        return 1.0
    }

    function double() {
        return 2 * this;
    }
    Number.prototype.double = double;

    function Require_min_balance(acct, min) {
        always: { acct.balance > min }
    }

    function Has_min_balance(acct, min) {
        return acct.balance > min;
    }

    function Point(x, y) {
        return {x: x, y: y}
    }

    // TODO: others

    function Test(i) {
        ctx = {i: i};
        always: { priority: 'medium'; ctx.i == 5 }
        return ctx.i + 1
    }



TestCase.subclass('users.timfelgentreff.babelsberg.testsuite.SemanticsTests', {

INSERTHERE

});
});
