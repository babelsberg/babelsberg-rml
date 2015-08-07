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
    MakeIdentical: function(self, a, b) {
        var ctx = {a: a, b: b};
        always: { ctx.a === ctx.b }
    },
    Testalwaysxequal5: function(self, x) {
        var ctx = {x: x};
        always: { ctx.x == 5 }
        return ctx.x;
    },
    Testalwaysaequalsbplus3: function(self, a, b) {
        var ctx = {a: a, b: b};
        always: { ctx.a == ctx.b + 3 }
        return ctx.a
    },
    Testipointxequals5: function(self, p) {
        var myp = {x: p.x, y: p.y};
        always: { myp.x == 5 }
        return myp;
    },
    Testpointxequals5: function(self, p) {
        always: { p.x == 5 }
        return p;
    },
    TestXGetsXPlus3ReturnX: function(self, x) {
        x = x + 3;
        return x;
    },


test1: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 3.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 3.0, 'expected ctx.x to be equal to 3.0');
    try {
        ctx.x = 4.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 4.0, 'expected ctx.x to be equal to 4.0');
    try { always: {
        priority: 'required';
        ctx.x >= 10.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 10.0, 'expected ctx.x to be equal to 10.0');
},

test2: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 3.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 3.0, 'expected ctx.x to be equal to 3.0');
    try {
        ctx.y = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 3.0, 'expected ctx.x to be equal to 3.0');
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    try { always: {
        priority: 'required';
        ctx.y == ctx.x + 100.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 3.0, 'expected ctx.x to be equal to 3.0');
    this.assert(ctx.y == 103.0, 'expected ctx.y to be equal to 103.0');
    try {
        ctx.x = ctx.x + 2.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    this.assert(ctx.y == 105.0, 'expected ctx.y to be equal to 105.0');
},

test3: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try { always: {
        priority: 'required';
        ctx.x == 10.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test4: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    try {
        ctx.y = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    try {
        ctx.z = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    this.assert(ctx.z == 0.0, 'expected ctx.z to be equal to 0.0');
    try { always: {
        priority: 'required';
        ctx.x + ctx.y + 2.0 * ctx.z == 10.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 10.0, 'expected ctx.x to be equal to 10.0');
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    this.assert(ctx.z == 0.0, 'expected ctx.z to be equal to 0.0');
    try { always: {
        priority: 'required';
        2.0 * ctx.x + ctx.y + ctx.z == 20.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 10.0, 'expected ctx.x to be equal to 10.0');
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    this.assert(ctx.z == 0.0, 'expected ctx.z to be equal to 0.0');
    try {
        ctx.x = 100.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 100.0, 'expected ctx.x to be equal to 100.0');
    this.assert(ctx.y == -270.0, 'expected ctx.y to be equal to -270.0');
    this.assert(ctx.z == 90.0, 'expected ctx.z to be equal to 90.0');
},

test5: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 5.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    try { always: {
        priority: 'required';
        ctx.x <= 10.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    try {
        ctx.x = ctx.x + 15.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test6: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 4.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 4.0, 'expected ctx.x to be equal to 4.0');
    if (ctx.x == 4.0 || ctx.x / 0.0 == 10.0) {
        try {
            ctx.x = 100.0;
        } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 100.0, 'expected ctx.x to be equal to 100.0');
    } else {
        try {
            ctx.x = 200.0;
        } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
    }
},

test7: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    try { always: {
        priority: 'required';
        ctx.x == 4.0 && ctx.x == 5.0 || ctx.x != 4.0 && ctx.x == 10.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 10.0, 'expected ctx.x to be equal to 10.0');
},

test8: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 5.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    try {
        ctx.x = "Hello";
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == "Hello", 'expected ctx.x to be equal to "Hello"');
},

test9: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 5.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    try {
        ctx.y = 10.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    this.assert(ctx.y == 10.0, 'expected ctx.y to be equal to 10.0');
    try { always: {
        priority: 'required';
        ctx.y == ctx.x
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    this.assert(ctx.y == 5.0, 'expected ctx.y to be equal to 5.0');
    try {
        ctx.x = "Hello";
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == "Hello", 'expected ctx.x to be equal to "Hello"');
    this.assert(ctx.y == "Hello", 'expected ctx.y to be equal to "Hello"');
},

test10: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 5.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    try {
        ctx.y = 10.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    this.assert(ctx.y == 10.0, 'expected ctx.y to be equal to 10.0');
    try { always: {
        priority: 'required';
        ctx.y == ctx.x + ctx.x
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 5.0, 'expected ctx.x to be equal to 5.0');
    this.assert(ctx.y == 10.0, 'expected ctx.y to be equal to 10.0');
    try {
        ctx.x = "Hello";
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == "Hello", 'expected ctx.x to be equal to "Hello"');
    this.assert(ctx.y == "HelloHello", 'expected ctx.y to be equal to "HelloHello"');
},

test11: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 3.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 3.0, 'expected ctx.x to be equal to 3.0');
    try { always: {
        priority: 'weak';
        ctx.x == 5.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 3.0, 'expected ctx.x to be equal to 3.0');
    try { always: {
        priority: 'weak';
        ctx.x == "hello"
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 3.0, 'expected ctx.x to be equal to 3.0');
},

test12: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 2.0, y: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    try {
        ctx.a = (ctx.p).x;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    this.assert(ctx.a == 2.0, 'expected ctx.a to be equal to 2.0');
    try {
        ctx.q = ctx.p;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    this.assert(ctx.a == 2.0, 'expected ctx.a to be equal to 2.0');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
    try { always: {
        priority: 'required';
        (ctx.p).x == 100.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 5.0})');
    this.assert(ctx.a == 2.0, 'expected ctx.a to be equal to 2.0');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
    try { always: {
        priority: 'required';
        ctx.q == ctx.p
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 5.0})');
    this.assert(ctx.a == 2.0, 'expected ctx.a to be equal to 2.0');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
    try { always: {
        priority: 'required';
        (ctx.q).y == 20.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 20.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 20.0})');
    this.assert(ctx.a == 2.0, 'expected ctx.a to be equal to 2.0');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
},

test13: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = new Object({x: 1.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    try {
        ctx.a = new Object({y: 10.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({y: 10.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({y: 10.0})');
},

test14: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = new Object({x: 1.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    try {
        ctx.temp = new Object({y: 10.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    this.assert(this.fieldEquals(ctx.temp, Object({y: 10.0})), 'expected the names and values of the fields in ctx.temp to equal those in Object({y: 10.0})');
    try { once: {
        priority: 'required';
        ctx.a == ctx.temp
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test15: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = Object({x: 1.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    try {
        ctx.b = Object({x: 2.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    this.assert(this.fieldEquals(ctx.b, Object({x: 2.0})), 'expected the names and values of the fields in ctx.b to equal those in Object({x: 2.0})');
    try { always: {
        priority: 'required';
        ctx.a == ctx.b
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    this.assert(this.fieldEquals(ctx.b, Object({x: 1.0})), 'expected the names and values of the fields in ctx.b to equal those in Object({x: 1.0})');
    try {
        ctx.a = Object({x: 1.0, y: 10.0});
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test17: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = new Object({y: 10.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({y: 10.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({y: 10.0})');
    try { always: {
        priority: 'required';
        ctx.b == ctx.a
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test18: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 2.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0})');
    try { always: {
        priority: 'required';
        (ctx.p).y == 100.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test19: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 2.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0})');
    try { always: {
        priority: 'required';
        ctx.p == 5.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test20: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 0.0, y: 0.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 0.0, y: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 0.0, y: 0.0})');
    try { always: {
        priority: 'required';
        (ctx.p).x == 100.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 0.0})');
    try {
        ctx.p = new Object({x: 2.0, y: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 5.0})');
},

test22: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = new Object({x: 0.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 0.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 0.0})');
    try {
        ctx.b = new Object({y: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 0.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 0.0})');
    this.assert(this.fieldEquals(ctx.b, Object({y: 5.0})), 'expected the names and values of the fields in ctx.b to equal those in Object({y: 5.0})');
    try { always: {
        priority: 'required';
        ctx.a == ctx.b
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test23: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 0.0, y: 0.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 0.0, y: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 0.0, y: 0.0})');
    try { once: {
        priority: 'required';
        (ctx.p).x == 100.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 0.0})');
},

test24: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 2.0, y: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    try {
        ctx.a = (ctx.p).x;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    this.assert(ctx.a == 2.0, 'expected ctx.a to be equal to 2.0');
    try {
        (ctx.p).x = 6.0;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 6.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 6.0, y: 5.0})');
    this.assert(ctx.a == 2.0, 'expected ctx.a to be equal to 2.0');
    try { always: {
        priority: 'required';
        (ctx.p).x == 100.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 5.0})');
    this.assert(ctx.a == 2.0, 'expected ctx.a to be equal to 2.0');
},

test25: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 2.0, y: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    try { always: {
        priority: 'required';
        (ctx.p).z == 5.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test26: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 2.0, y: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    try {
        ctx.q = ctx.p;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
    try {
        (ctx.p).x = 100.0;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 5.0})');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
    try {
        ctx.q = new Object({z: 10.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 100.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 100.0, y: 5.0})');
    this.assert(this.fieldEquals(ctx.q, Object({z: 10.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({z: 10.0})');
    try {
        (ctx.p).x = 200.0;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 200.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 200.0, y: 5.0})');
    this.assert(this.fieldEquals(ctx.q, Object({z: 10.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({z: 10.0})');
},

test27: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 2.0, y: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    try {
        ctx.q = ctx.p;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0, y: 5.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0, y: 5.0})');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
    try { always: {
        ctx.q === ctx.p
    } } catch (e) { ctx.unsat = true }
    try {
        ctx.q = new Object({z: 10.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({z: 10.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({z: 10.0})');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
},

test28: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 2.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0})');
    try {
        ctx.q = new Object({y: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 2.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 2.0})');
    this.assert(this.fieldEquals(ctx.q, Object({y: 5.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({y: 5.0})');
    try { always: {
        ctx.q === ctx.p
    } } catch (e) { ctx.unsat = true }
},

test29: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = new Object({x: 0.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 0.0})');
    try {
        ctx.q = new Object({x: 5.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 0.0})');
    this.assert(this.fieldEquals(ctx.q, Object({x: 5.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({x: 5.0})');
    try { always: {
        priority: 'medium';
        (ctx.p).x == 0.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 0.0})');
    this.assert(this.fieldEquals(ctx.q, Object({x: 5.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({x: 5.0})');
    try { always: {
        priority: 'medium';
        (ctx.q).x == 5.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 0.0})');
    this.assert(this.fieldEquals(ctx.q, Object({x: 5.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({x: 5.0})');
    try { always: {
        priority: 'weak';
        ctx.p === ctx.q
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test30: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = new Object({x: 1.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    try {
        ctx.b = ctx.a;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    this.assert(ctx.b === ctx.a, 'expected ctx.b to be identical to ctx.a');
    try { always: {
        priority: 'required';
        (ctx.a).x == 1.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    this.assert(ctx.b === ctx.a, 'expected ctx.b to be identical to ctx.a');
    try { always: {
        priority: 'required';
        (ctx.b).x == 2.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test31: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = new Object({x: 1.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    try {
        ctx.b = ctx.a;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    this.assert(ctx.b === ctx.a, 'expected ctx.b to be identical to ctx.a');
    try {
        ctx.c = new Object({x: 2.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    this.assert(ctx.b === ctx.a, 'expected ctx.b to be identical to ctx.a');
    this.assert(this.fieldEquals(ctx.c, Object({x: 2.0})), 'expected the names and values of the fields in ctx.c to equal those in Object({x: 2.0})');
    try { always: {
        priority: 'required';
        (ctx.a).x == 1.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({x: 1.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({x: 1.0})');
    this.assert(ctx.b === ctx.a, 'expected ctx.b to be identical to ctx.a');
    this.assert(this.fieldEquals(ctx.c, Object({x: 2.0})), 'expected the names and values of the fields in ctx.c to equal those in Object({x: 2.0})');
    try { always: {
        priority: 'required';
        (ctx.b).x == 2.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test32b: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.r = new Object({upper_left: this.Point(null, 2.0, 2.0), lower_right: this.Point(null, 10.0, 10.0)});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.r, Object({lower_right: Object({x: 10.0, y: 10.0}), upper_left: Object({x: 2.0, y: 2.0})})), 'expected the names and values of the fields in ctx.r to equal those in Object({lower_right: Object({x: 10.0, y: 10.0}), upper_left: Object({x: 2.0, y: 2.0})})');
    try { always: {
        priority: 'required';
        this.ptEq(this.center(ctx.r), this.Point(null, 2.0, 2.0))
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.r, Object({lower_right: Object({x: 3.0, y: 3.0}), upper_left: Object({x: 1.0, y: 1.0})})), 'expected the names and values of the fields in ctx.r to equal those in Object({lower_right: Object({x: 3.0, y: 3.0}), upper_left: Object({x: 1.0, y: 1.0})})');
    try { once: {
        priority: 'required';
        (this.center(ctx.r)).x == 100.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test32c: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.r = new Object({upper_left: this.Point(null, 2.0, 2.0), lower_right: this.Point(null, 10.0, 10.0)});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.r, Object({lower_right: Object({x: 10.0, y: 10.0}), upper_left: Object({x: 2.0, y: 2.0})})), 'expected the names and values of the fields in ctx.r to equal those in Object({lower_right: Object({x: 10.0, y: 10.0}), upper_left: Object({x: 2.0, y: 2.0})})');
    try { always: {
        priority: 'required';
        this.ptEq(this.center(ctx.r), this.Point(null, 2.0, 2.0))
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.r, Object({lower_right: Object({x: 2.0, y: 2.0}), upper_left: Object({x: 2.0, y: 2.0})})), 'expected the names and values of the fields in ctx.r to equal those in Object({lower_right: Object({x: 2.0, y: 2.0}), upper_left: Object({x: 2.0, y: 2.0})})');
    try {
        ((ctx.r).upper_left).x = 100.0;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.r, Object({lower_right: Object({x: -96.0, y: 4.0}), upper_left: Object({x: 100.0, y: 0.0})})), 'expected the names and values of the fields in ctx.r to equal those in Object({lower_right: Object({x: -96.0, y: 4.0}), upper_left: Object({x: 100.0, y: 0.0})})');
},

test32: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.r = new Object({upper_left: this.Point(null, 2.0, 2.0), lower_right: this.Point(null, 10.0, 10.0)});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.r, Object({upper_left: Object({x: 2.0, y: 2.0}), lower_right: Object({x: 10.0, y: 10.0})})), 'expected the names and values of the fields in ctx.r to equal those in Object({upper_left: Object({x: 2.0, y: 2.0}), lower_right: Object({x: 10.0, y: 10.0})})');
    try { always: {
        priority: 'required';
        this.ptEq(this.center(ctx.r), this.Point(null, 2.0, 2.0))
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.r, Object({upper_left: Object({x: 1.0, y: 1.0}), lower_right: Object({x: 3.0, y: 3.0})})), 'expected the names and values of the fields in ctx.r to equal those in Object({upper_left: Object({x: 1.0, y: 1.0}), lower_right: Object({x: 3.0, y: 3.0})})');
    try {
        (this.center(ctx.r)).x = 100.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test33: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.y = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    try {
        ctx.x = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    try { always: {
        priority: 'required';
        ctx.y == this.double(ctx.x)
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    try {
        ctx.y = 20.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.y == 20.0, 'expected ctx.y to be equal to 20.0');
    this.assert(ctx.x == 10.0, 'expected ctx.x to be equal to 10.0');
    try {
        ctx.x = 7.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.y == 14.0, 'expected ctx.y to be equal to 14.0');
    this.assert(ctx.x == 7.0, 'expected ctx.x to be equal to 7.0');
},

test34: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = new Object({balance: 0.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({balance: 0.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({balance: 0.0})');
    try {
        ctx.m = 10.0;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({balance: 0.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({balance: 0.0})');
    this.assert(ctx.m == 10.0, 'expected ctx.m to be equal to 10.0');
    try {
        ctx.def = this.Require_min_balance(null, ctx.a, ctx.m);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({balance: 11.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({balance: 11.0})');
    this.assert(ctx.m == 10.0, 'expected ctx.m to be equal to 10.0');
    try {
        ctx.m = 100.0;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({balance: 11.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({balance: 11.0})');
    this.assert(ctx.m == 100.0, 'expected ctx.m to be equal to 100.0');
},

test35: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = new Object({balance: 0.0});
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({balance: 0.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({balance: 0.0})');
    try {
        ctx.m = 10.0;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({balance: 0.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({balance: 0.0})');
    this.assert(ctx.m == 10.0, 'expected ctx.m to be equal to 10.0');
    try { always: {
        priority: 'required';
        this.Has_min_balance(null, ctx.a, ro(ctx.m))
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({balance: 11.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({balance: 11.0})');
    this.assert(ctx.m == 10.0, 'expected ctx.m to be equal to 10.0');
    try {
        ctx.m = 100.0;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.a, Object({balance: 101.0})), 'expected the names and values of the fields in ctx.a to equal those in Object({balance: 101.0})');
    this.assert(ctx.m == 100.0, 'expected ctx.m to be equal to 100.0');
},

test36: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    try {
        ctx.y = this.Test(null, ctx.x);
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    this.assert(ctx.y == 6.0, 'expected ctx.y to be equal to 6.0');
    try { always: {
        priority: 'medium';
        ctx.x == 10.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 10.0, 'expected ctx.x to be equal to 10.0');
    this.assert(ctx.y == 6.0, 'expected ctx.y to be equal to 6.0');
    try { always: {
        priority: 'required';
        ctx.y == this.Test(null, ctx.x)
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test40: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.pA = this.MutablePointNew(null, 10.0, 10.0);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.pA, Object({x: 10.0, y: 10.0})), 'expected the names and values of the fields in ctx.pA to equal those in Object({x: 10.0, y: 10.0})');
    try {
        ctx.pB = ctx.pA;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.pA, Object({x: 10.0, y: 10.0})), 'expected the names and values of the fields in ctx.pA to equal those in Object({x: 10.0, y: 10.0})');
    this.assert(ctx.pB === ctx.pA, 'expected ctx.pB to be identical to ctx.pA');
    try {
        ctx.pA = this.MutablePointNew(null, 50.0, 50.0);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.pA, Object({x: 50.0, y: 50.0})), 'expected the names and values of the fields in ctx.pA to equal those in Object({x: 50.0, y: 50.0})');
    this.assert(this.fieldEquals(ctx.pB, Object({x: 10.0, y: 10.0})), 'expected the names and values of the fields in ctx.pB to equal those in Object({x: 10.0, y: 10.0})');
},

test41: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.p = this.MutablePointNew(null, 0.0, 0.0);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 0.0, y: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 0.0, y: 0.0})');
    try {
        ctx.q = ctx.p;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 0.0, y: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 0.0, y: 0.0})');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
    try { always: {
        priority: 'required';
        (ctx.p).x == 5.0
    } } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.p, Object({x: 5.0, y: 0.0})), 'expected the names and values of the fields in ctx.p to equal those in Object({x: 5.0, y: 0.0})');
    this.assert(ctx.q === ctx.p, 'expected ctx.q to be identical to ctx.p');
    try { always: {
        priority: 'required';
        (ctx.q).x == 10.0
    } } catch (e) { ctx.unsat = true }
    this.assert(ctx.unsat == true, 'expected ctx.unsat to be equal to true');
},

test42: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = this.WindowNew(null);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.x, Object({window: true})), 'expected the names and values of the fields in ctx.x to equal those in Object({window: true})');
    try {
        ctx.y = ctx.x;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.x, Object({window: true})), 'expected the names and values of the fields in ctx.x to equal those in Object({window: true})');
    this.assert(ctx.y === ctx.x, 'expected ctx.y to be identical to ctx.x');
    try { always: {
        ctx.y === ctx.x
    } } catch (e) { ctx.unsat = true }
    try {
        ctx.x = this.CircleNew(null);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.x, Object({circle: true})), 'expected the names and values of the fields in ctx.x to equal those in Object({circle: true})');
    this.assert(ctx.y === ctx.x, 'expected ctx.y to be identical to ctx.x');
},

test43: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = this.WindowNew(null);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.x, Object({window: true})), 'expected the names and values of the fields in ctx.x to equal those in Object({window: true})');
    try {
        ctx.y = ctx.x;
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.x, Object({window: true})), 'expected the names and values of the fields in ctx.x to equal those in Object({window: true})');
    this.assert(ctx.y === ctx.x, 'expected ctx.y to be identical to ctx.x');
    try {
        ctx.def = this.MakeIdentical(null, ctx.x, ctx.y);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.x, Object({window: true})), 'expected the names and values of the fields in ctx.x to equal those in Object({window: true})');
    this.assert(ctx.y === ctx.x, 'expected ctx.y to be identical to ctx.x');
    try {
        ctx.x = this.CircleNew(null);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.y, Object({window: true})), 'expected the names and values of the fields in ctx.y to equal those in Object({window: true})');
    this.assert(this.fieldEquals(ctx.x, Object({circle: true})), 'expected the names and values of the fields in ctx.x to equal those in Object({circle: true})');
},

test45: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.a = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.a == 0.0, 'expected ctx.a to be equal to 0.0');
    try {
        ctx.def = this.Testalwaysxequal5(null, ctx.a);
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.a == 0.0, 'expected ctx.a to be equal to 0.0');
},

test46: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.x = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    try {
        ctx.y = 0.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    try {
        ctx.def = this.Testalwaysaequalsbplus3(null, ctx.x, ctx.y);
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 0.0, 'expected ctx.x to be equal to 0.0');
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    try {
        ctx.x = 10.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 10.0, 'expected ctx.x to be equal to 10.0');
    this.assert(ctx.y == 0.0, 'expected ctx.y to be equal to 0.0');
    try {
        ctx.y = 10.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.x == 10.0, 'expected ctx.x to be equal to 10.0');
    this.assert(ctx.y == 10.0, 'expected ctx.y to be equal to 10.0');
},

test47: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.q = this.Point(null, 0.0, 0.0);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.q, Object({x: 0.0, y: 0.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({x: 0.0, y: 0.0})');
    try {
        ctx.def = this.Testipointxequals5(null, ctx.q);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.q, Object({x: 0.0, y: 0.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({x: 0.0, y: 0.0})');
},

test48: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.q = this.MutablePointNew(null, 0.0, 0.0);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.q, Object({x: 0.0, y: 0.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({x: 0.0, y: 0.0})');
    try {
        ctx.def = this.Testpointxequals5(null, ctx.q);
    } catch (e) { ctx.unsat = true }
    this.assert(this.fieldEquals(ctx.q, Object({x: 5.0, y: 0.0})), 'expected the names and values of the fields in ctx.q to equal those in Object({x: 5.0, y: 0.0})');
},

test49: function() {
    delete bbb.defaultSolver;
    bbb.defaultSolvers = [new CommandLineZ3(), new DBPlanner()];
    bbb.defaultSolvers[1].$$identity = true;
    var ctx = {unsat: false};

    try {
        ctx.y = 10.0;
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.y == 10.0, 'expected ctx.y to be equal to 10.0');
    try {
        ctx.def = this.TestXGetsXPlus3ReturnX(null, ctx.y);
    } catch (e) { ctx.unsat = true }
    this.assert(ctx.y == 10.0, 'expected ctx.y to be equal to 10.0');
},


});
});
