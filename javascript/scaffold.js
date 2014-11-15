module('users.timfelgentreff.babelsberg.testsuite').
requires('lively.TestFramework',
         'users.timfelgentreff.babelsberg.constraintinterpreter',
         'users.timfelgentreff.z3.CommandLineZ3').
toRun(function() {

function double() {
    return 2 * this;
}
Number.prototype.double = double;

TestCase.subclass('users.timfelgentreff.babelsberg.testsuite.SemanticsTests', {
    fieldEquals: function(o1, o2) {
        for (var key in o1) {
            if (key[0] !== "$" && key[0] !== "_") {
                if (o1[key] !== o2[key]) return false;
            }
        }
        for (var key in o2) {
            if (key[0] !== "$" && key[0] !== "_") {
                if (o1[key] !== o2[key]) return false;
            }
        }
        return true;
    },
    one: function() {
        return 1.0
    },
    Require_min_balance: function(acct, min) {
        always: { acct.balance > min }
    },
    Has_min_balance: function(acct, min) {
        return acct.balance > min;
    },
    Point: function(x, y) {
        return {x: x, y: y}
    },
    // TODO: others
    Test: function(i) {
        ctx = {i: i};
        always: { priority: 'medium'; ctx.i == 5 }
        return ctx.i + 1
    },


INSERTHERE

});
});
