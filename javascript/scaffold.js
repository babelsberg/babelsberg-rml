module('users.timfelgentreff.babelsberg.testsuite').
requires('lively.TestFramework',
         'users.timfelgentreff.babelsberg.constraintinterpreter',
         'users.timfelgentreff.z3.CommandLineZ3').
toRun(function() {

TestCase.subclass('users.timfelgentreff.babelsberg.testsuite.SemanticsTests', {
    fieldEquals: function(o1, o2) {
        if (!o1) return false;
        if (!o2) return false;
        for (var key in o1) {
            if (key[0] !== "$" && key[0] !== "_") {
                if (typeof(o1[key]) == "object") {
                    this.fieldEquals(o2[key], o1[key]);
                } else {
                    if (o1[key] !== o2[key]) return false;
                }
            }
        }
        for (var key in o2) {
            if (typeof(o2[key]) == "object") {
                this.fieldEquals(o2[key], o1[key]);
            } else {
                if (o1[key] !== o2[key]) return false;
            }
        }
        return true;
    },
    one: function(self) {
        return 1.0
    },
    double: function(self) {
        return 2 * self;
    },
    Require_min_balance: function(self, acct, min) {
        always: { acct.balance > min }
    },
    Has_min_balance: function(self, acct, min) {
        return acct.balance > min;
    },
    Point: function(self, x, y) {
        return {x: x, y: y}
    },
    center: function(self) {
        return this.divPtScalar(this.addPt(self.upper_left, self.lower_right), 2);
    },
    addPt: function(self, other) {
        return this.Point(null, self.x + other.x, self.y + other.y);
    },
    divPtScalar: function(self, scale) {
        return this.Point(null, self.x / scale, self.y / scale);
    },
    ptEq: function(self, other) {
        return self.x == other.x && self.y == other.y
    },
    Test: function(self, i) {
        ctx = {i: i};
        bbb.always({
            priority: "medium",
            ctx: {
                ctx: ctx,
                _$_self: this.doitContext || this
            }
        }, function() {
            return ctx.i == 5;;
        });
        return ctx.i + 1
    },
    MutablePointNew: function(self, x, y) {
        return new Object({x: x, y: y});
    },
    WindowNew: function(self) {
        return new Object({window: true});
    },
    CircleNew: function(self) {
        return new Object({circle: true});
    },
    // TODO: others


INSERTHERE

});
});
