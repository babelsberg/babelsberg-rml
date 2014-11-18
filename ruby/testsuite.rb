require "libz3"

class Helper < ConstraintObject
  def hRecord(hash)
    o = Object.new
    hash.each_pair do |k,v|
      o.instance_variable_set(:"@#{k}", v)
      o.singleton_class.send(:attr_accessor, k)
    end
    o.define_singleton_method "inspect" do
      hash.keys.inject("{") do |acc, i|
        "#{acc} #{i}: #{o.instance_variable_get('@' + i.to_s)}"
      end + "}"
    end
    o.define_singleton_method "values" do
      hash.keys.inject("{") do |acc, i|
        "#{acc} #{i}: #{o.instance_variable_get('@' + i.to_s)}"
      end + "}"
    end
    o.singleton_class.send("alias_method", :to_s, :inspect)

    o.define_singleton_method "==" do |o|
      if o.kind_of? Struct
        return hash.keys.all? do |var|
          self.instance_variable_get("@#{var}") == o.instance_variable_get("@#{var}")
        end
      else
        return self.equal? o
      end
    end
    return o
  end

  IRecordTypes = {}
  def iRecord(hash)
    attrs = hash.keys
    name = "IRecord_#{attrs.join}"
    klass = IRecordTypes[name]
    unless klass
      IRecordTypes[name] = klass = Struct.make_struct(name, attrs)
      attrs.each { |a| klass.send("attr_accessor", a) }

      klass.send(:define_method, "inspect") do
        attrs.inject("{") do |acc, i|
          "#{acc} #{i}: #{self.instance_variable_get('@' + i.to_s)}"
        end + "}"
      end
      klass.send("alias_method", :to_s, :inspect)
    end
    o = klass.new
    hash.each_pair { |k,v| o[k] = v }
    o
  end
end

$last_exception = nil
def assert(value, var, expected, got)
  raise $last_exception ? $last_exception : "Expected #{var} to equal #{expected}, got #{got}" unless value
end
def assert_identical(value, e1, e2)
  raise $last_exception ? $last_exception : "Expected #{e1} to be identical to #{e2}" unless value
end

class Z3::Z3Pointer
  def double
    self * 2
  end
end

class NilClass
  def MutablePointNew(x,y)
    Helper.new.hRecord(x: x, y: y)
  end

  def Point(x,y)
    Helper.new.iRecord(x: x, y: y)
  end

  def WindowNew
    Helper.new.hRecord(window: true)
  end

  def CircleNew
    Helper.new.hRecord(circle: true)
  end

  def Testpointxequals5(p)
    always { p.x == 5 }
    return p
  end

  def Test(i)
    always(priority: :medium) { i == 5 }
    return i + 1
  end

  def Has_min_balance(acct, min)
    return acct.balance > min
  end

  def Require_min_balance(acct, min)
    always { acct.balance > min }
  end
end

class Object
  def center
    self.upper_left.addPt(self.lower_right).divPtScalar(2)
  end

  def addPt(pt)
    Helper.new.iRecord(x: self.x + pt.x, y: self.y + pt.y)
  end

  def divPtScalar(scale)
    Helper.new.iRecord(x: self.x / scale, y: self.y / scale)
  end

  def ptEq(pt)
    pt.x == self.x && pt.y == self.y
  end
end


def test1
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 3.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 3.0, 'x', 3.0, x)
  begin
    x = 4.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 4.0, 'x', 4.0, x)
  begin
    always(priority: :required) do
      x >= 10.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 10.0, 'x', 10.0, x)
end

def test2
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 3.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 3.0, 'x', 3.0, x)
  begin
    y = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 3.0, 'x', 3.0, x)
  assert(y == 0.0, 'y', 0.0, y)
  begin
    always(priority: :required) do
      y == x + 100.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 3.0, 'x', 3.0, x)
  assert(y == 103.0, 'y', 103.0, y)
  begin
    x = x + 2.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  assert(y == 105.0, 'y', 105.0, y)
end

def test3
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    always(priority: :required) do
      x == 10.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test4
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  begin
    y = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  assert(y == 0.0, 'y', 0.0, y)
  begin
    z = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  assert(y == 0.0, 'y', 0.0, y)
  assert(z == 0.0, 'z', 0.0, z)
  begin
    always(priority: :required) do
      x + y + 2.0 * z == 10.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 10.0, 'x', 10.0, x)
  assert(y == 0.0, 'y', 0.0, y)
  assert(z == 0.0, 'z', 0.0, z)
  begin
    always(priority: :required) do
      2.0 * x + y + z == 20.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 10.0, 'x', 10.0, x)
  assert(y == 0.0, 'y', 0.0, y)
  assert(z == 0.0, 'z', 0.0, z)
  begin
    x = 100.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 100.0, 'x', 100.0, x)
  assert(y == -270.0, 'y', -270.0, y)
  assert(z == 90.0, 'z', 90.0, z)
end

def test5
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 5.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  begin
    always(priority: :required) do
      x <= 10.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  begin
    x = x + 15.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test6
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 4.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 4.0, 'x', 4.0, x)
  if x == 4.0 || x / 0.0 == 10.0
    begin
      x = 100.0
    rescue Exception => e
      unsat = true; $last_exception = e
    end
  assert(x == 100.0, 'x', 100.0, x)
  else
    begin
      x = 200.0
    rescue Exception => e
      unsat = true; $last_exception = e
    end
  assert(unsat == true, 'unsat', true, unsat)
  end
end

def test7
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  begin
    always(priority: :required) do
      x == 4.0 && x == 5.0 || x != 4.0 && x == 10.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 10.0, 'x', 10.0, x)
end

def test8
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 5.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  begin
    x = "Hello"
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == "Hello", 'x', "Hello", x)
end

def test9
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 5.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  begin
    y = 10.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  assert(y == 10.0, 'y', 10.0, y)
  begin
    always(priority: :required) do
      y == x
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  assert(y == 5.0, 'y', 5.0, y)
  begin
    x = "Hello"
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == "Hello", 'x', "Hello", x)
  assert(y == "Hello", 'y', "Hello", y)
end

def test10
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 5.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  begin
    y = 10.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  assert(y == 10.0, 'y', 10.0, y)
  begin
    always(priority: :required) do
      y == x + x
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 5.0, 'x', 5.0, x)
  assert(y == 10.0, 'y', 10.0, y)
  begin
    x = "Hello"
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == "Hello", 'x', "Hello", x)
  assert(y == "HelloHello", 'y', "HelloHello", y)
end

def test11
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 3.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 3.0, 'x', 3.0, x)
  begin
    always(priority: :weak) do
      x == 5.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 3.0, 'x', 3.0, x)
  begin
    always(priority: :weak) do
      x == "hello"
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 3.0, 'x', 3.0, x)
end

def test12
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 2.0, y: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  begin
    a = (p).x
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  assert(a == 2.0, 'a', 2.0, a)
  begin
    q = p
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  assert(a == 2.0, 'a', 2.0, a)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
  begin
    always(priority: :required) do
      (p).x == 100.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 5.0), 'p', Helper.new.iRecord(x: 100.0, y: 5.0), p)
  assert(a == 2.0, 'a', 2.0, a)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
  begin
    always(priority: :required) do
      q == p
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 5.0), 'p', Helper.new.iRecord(x: 100.0, y: 5.0), p)
  assert(a == 2.0, 'a', 2.0, a)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
  begin
    always(priority: :required) do
      (q).y == 20.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 20.0), 'p', Helper.new.iRecord(x: 100.0, y: 20.0), p)
  assert(a == 2.0, 'a', 2.0, a)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
end

def test13
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.hRecord(x: 1.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  begin
    a = Helper.new.hRecord(y: 10.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(y: 10.0), 'a', Helper.new.iRecord(y: 10.0), a)
end

def test14
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.hRecord(x: 1.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  begin
    temp = Helper.new.hRecord(y: 10.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  assert(temp == Helper.new.iRecord(y: 10.0), 'temp', Helper.new.iRecord(y: 10.0), temp)
  begin
    always(priority: :required) do
      a == temp
    end.disable
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test15
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.iRecord(x: 1.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  begin
    b = Helper.new.iRecord(x: 2.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  assert(b == Helper.new.iRecord(x: 2.0), 'b', Helper.new.iRecord(x: 2.0), b)
  begin
    always(priority: :required) do
      a == b
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  assert(b == Helper.new.iRecord(x: 1.0), 'b', Helper.new.iRecord(x: 1.0), b)
  begin
    a = Helper.new.iRecord(x: 1.0, y: 10.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test17
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.hRecord(y: 10.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(y: 10.0), 'a', Helper.new.iRecord(y: 10.0), a)
  begin
    always(priority: :required) do
      b == a
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test18
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 2.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0), 'p', Helper.new.iRecord(x: 2.0), p)
  begin
    always(priority: :required) do
      (p).y == 100.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test19
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 2.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0), 'p', Helper.new.iRecord(x: 2.0), p)
  begin
    always(priority: :required) do
      p == 5.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test20
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 0.0, y: 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 0.0, y: 0.0), 'p', Helper.new.iRecord(x: 0.0, y: 0.0), p)
  begin
    always(priority: :required) do
      (p).x == 100.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 0.0), 'p', Helper.new.iRecord(x: 100.0, y: 0.0), p)
  begin
    p = Helper.new.hRecord(x: 2.0, y: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 5.0), 'p', Helper.new.iRecord(x: 100.0, y: 5.0), p)
end

def test22
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.hRecord(x: 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 0.0), 'a', Helper.new.iRecord(x: 0.0), a)
  begin
    b = Helper.new.hRecord(y: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 0.0), 'a', Helper.new.iRecord(x: 0.0), a)
  assert(b == Helper.new.iRecord(y: 5.0), 'b', Helper.new.iRecord(y: 5.0), b)
  begin
    always(priority: :required) do
      a == b
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test23
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 0.0, y: 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 0.0, y: 0.0), 'p', Helper.new.iRecord(x: 0.0, y: 0.0), p)
  begin
    always(priority: :required) do
      (p).x == 100.0
    end.disable
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 0.0), 'p', Helper.new.iRecord(x: 100.0, y: 0.0), p)
end

def test24
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 2.0, y: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  begin
    a = (p).x
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  assert(a == 2.0, 'a', 2.0, a)
  begin
    (p).x = 6.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 6.0, y: 5.0), 'p', Helper.new.iRecord(x: 6.0, y: 5.0), p)
  assert(a == 2.0, 'a', 2.0, a)
  begin
    always(priority: :required) do
      (p).x == 100.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 5.0), 'p', Helper.new.iRecord(x: 100.0, y: 5.0), p)
  assert(a == 2.0, 'a', 2.0, a)
end

def test25
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 2.0, y: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  begin
    always(priority: :required) do
      (p).z == 5.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test26
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 2.0, y: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  begin
    q = p
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
  begin
    (p).x = 100.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 5.0), 'p', Helper.new.iRecord(x: 100.0, y: 5.0), p)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
  begin
    q = Helper.new.hRecord(z: 10.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 100.0, y: 5.0), 'p', Helper.new.iRecord(x: 100.0, y: 5.0), p)
  assert(q == Helper.new.iRecord(z: 10.0), 'q', Helper.new.iRecord(z: 10.0), q)
  begin
    (p).x = 200.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 200.0, y: 5.0), 'p', Helper.new.iRecord(x: 200.0, y: 5.0), p)
  assert(q == Helper.new.iRecord(z: 10.0), 'q', Helper.new.iRecord(z: 10.0), q)
end

def test27
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 2.0, y: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  begin
    q = p
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0, y: 5.0), 'p', Helper.new.iRecord(x: 2.0, y: 5.0), p)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
  begin
    always {q is? p }
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  begin
    q = Helper.new.hRecord(z: 10.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(z: 10.0), 'p', Helper.new.iRecord(z: 10.0), p)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
end

def test28
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 2.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0), 'p', Helper.new.iRecord(x: 2.0), p)
  begin
    q = Helper.new.hRecord(y: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 2.0), 'p', Helper.new.iRecord(x: 2.0), p)
  assert(q == Helper.new.iRecord(y: 5.0), 'q', Helper.new.iRecord(y: 5.0), q)
  begin
    always {q is? p }
  rescue Exception => e
    unsat = true; $last_exception = e
  end
end

def test29
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = Helper.new.hRecord(x: 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 0.0), 'p', Helper.new.iRecord(x: 0.0), p)
  begin
    q = Helper.new.hRecord(x: 5.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 0.0), 'p', Helper.new.iRecord(x: 0.0), p)
  assert(q == Helper.new.iRecord(x: 5.0), 'q', Helper.new.iRecord(x: 5.0), q)
  begin
    always(priority: :medium) do
      (p).x == 0.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 0.0), 'p', Helper.new.iRecord(x: 0.0), p)
  assert(q == Helper.new.iRecord(x: 5.0), 'q', Helper.new.iRecord(x: 5.0), q)
  begin
    always(priority: :medium) do
      (q).x == 5.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 0.0), 'p', Helper.new.iRecord(x: 0.0), p)
  assert(q == Helper.new.iRecord(x: 5.0), 'q', Helper.new.iRecord(x: 5.0), q)
  begin
    always(priority: :weak) do
      p is? q
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test30
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.hRecord(x: 1.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  begin
    b = a
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  assert_identical(b.object_id == a.object_id, 'b', 'a')
  begin
    always(priority: :required) do
      (a).x == 1.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  assert_identical(b.object_id == a.object_id, 'b', 'a')
  begin
    always(priority: :required) do
      (b).x == 2.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test31
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.hRecord(x: 1.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  begin
    b = a
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  assert_identical(b.object_id == a.object_id, 'b', 'a')
  begin
    c = Helper.new.hRecord(x: 2.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  assert_identical(b.object_id == a.object_id, 'b', 'a')
  assert(c == Helper.new.iRecord(x: 2.0), 'c', Helper.new.iRecord(x: 2.0), c)
  begin
    always(priority: :required) do
      (a).x == 1.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(x: 1.0), 'a', Helper.new.iRecord(x: 1.0), a)
  assert_identical(b.object_id == a.object_id, 'b', 'a')
  assert(c == Helper.new.iRecord(x: 2.0), 'c', Helper.new.iRecord(x: 2.0), c)
  begin
    always(priority: :required) do
      (b).x == 2.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test32c
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    r = Helper.new.hRecord(upper_left: nil.Point(2.0, 2.0), lower_right: nil.Point(10.0, 10.0))
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(r == Helper.new.iRecord(lower_right: Helper.new.iRecord(x: 10.0, y: 10.0), upper_left: Helper.new.iRecord(x: 2.0, y: 2.0)), 'r', Helper.new.iRecord(lower_right: Helper.new.iRecord(x: 10.0, y: 10.0), upper_left: Helper.new.iRecord(x: 2.0, y: 2.0)), r)
  begin
    always(priority: :required) do
      r.center().ptEq(nil.Point(2.0, 2.0))
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(r == Helper.new.iRecord(lower_right: Helper.new.iRecord(x: 2.0, y: 2.0), upper_left: Helper.new.iRecord(x: 2.0, y: 2.0)), 'r', Helper.new.iRecord(lower_right: Helper.new.iRecord(x: 2.0, y: 2.0), upper_left: Helper.new.iRecord(x: 2.0, y: 2.0)), r)
  begin
    ((r).upper_left).x = 100.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(r == Helper.new.iRecord(lower_right: Helper.new.iRecord(x: -96.0, y: 4.0), upper_left: Helper.new.iRecord(x: 100.0, y: 0.0)), 'r', Helper.new.iRecord(lower_right: Helper.new.iRecord(x: -96.0, y: 4.0), upper_left: Helper.new.iRecord(x: 100.0, y: 0.0)), r)
end

def test32
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    r = Helper.new.hRecord(upper_left: nil.Point(2.0, 2.0), lower_right: nil.Point(10.0, 10.0))
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(r == Helper.new.iRecord(upper_left: Helper.new.iRecord(x: 2.0, y: 2.0), lower_right: Helper.new.iRecord(x: 10.0, y: 10.0)), 'r', Helper.new.iRecord(upper_left: Helper.new.iRecord(x: 2.0, y: 2.0), lower_right: Helper.new.iRecord(x: 10.0, y: 10.0)), r)
  begin
    always(priority: :required) do
      r.center().ptEq(nil.Point(2.0, 2.0))
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(r == Helper.new.iRecord(upper_left: Helper.new.iRecord(x: 1.0, y: 1.0), lower_right: Helper.new.iRecord(x: 3.0, y: 3.0)), 'r', Helper.new.iRecord(upper_left: Helper.new.iRecord(x: 1.0, y: 1.0), lower_right: Helper.new.iRecord(x: 3.0, y: 3.0)), r)
  begin
    (r.center()).x = 100.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test32b
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    r = Helper.new.hRecord(upper_left: nil.Point(2.0, 2.0), lower_right: nil.Point(10.0, 10.0))
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(r == Helper.new.iRecord(lower_right: Helper.new.iRecord(x: 10.0, y: 10.0), upper_left: Helper.new.iRecord(x: 2.0, y: 2.0)), 'r', Helper.new.iRecord(lower_right: Helper.new.iRecord(x: 10.0, y: 10.0), upper_left: Helper.new.iRecord(x: 2.0, y: 2.0)), r)
  begin
    always(priority: :required) do
      r.center().ptEq(nil.Point(2.0, 2.0))
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(r == Helper.new.iRecord(lower_right: Helper.new.iRecord(x: 3.0, y: 3.0), upper_left: Helper.new.iRecord(x: 1.0, y: 1.0)), 'r', Helper.new.iRecord(lower_right: Helper.new.iRecord(x: 3.0, y: 3.0), upper_left: Helper.new.iRecord(x: 1.0, y: 1.0)), r)
  begin
    always(priority: :required) do
      (r.center()).x == 100.0
    end.disable
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test33
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    y = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(y == 0.0, 'y', 0.0, y)
  begin
    x = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(y == 0.0, 'y', 0.0, y)
  assert(x == 0.0, 'x', 0.0, x)
  begin
    always(priority: :required) do
      y == x.double()
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(y == 0.0, 'y', 0.0, y)
  assert(x == 0.0, 'x', 0.0, x)
  begin
    y = 20.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(y == 20.0, 'y', 20.0, y)
  assert(x == 10.0, 'x', 10.0, x)
  begin
    x = 7.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(y == 14.0, 'y', 14.0, y)
  assert(x == 7.0, 'x', 7.0, x)
end

def test34
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.hRecord(balance: 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(balance: 0.0), 'a', Helper.new.iRecord(balance: 0.0), a)
  begin
    m = 10.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(balance: 0.0), 'a', Helper.new.iRecord(balance: 0.0), a)
  assert(m == 10.0, 'm', 10.0, m)
  begin
    nil.Require_min_balance(a, m)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(balance: 11.0), 'a', Helper.new.iRecord(balance: 11.0), a)
  assert(m == 10.0, 'm', 10.0, m)
  begin
    m = 100.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(balance: 11.0), 'a', Helper.new.iRecord(balance: 11.0), a)
  assert(m == 100.0, 'm', 100.0, m)
end

def test35
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = Helper.new.hRecord(balance: 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(balance: 0.0), 'a', Helper.new.iRecord(balance: 0.0), a)
  begin
    m = 10.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(balance: 0.0), 'a', Helper.new.iRecord(balance: 0.0), a)
  assert(m == 10.0, 'm', 10.0, m)
  begin
    always(priority: :required) do
      nil.Has_min_balance(a, m.?)
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(balance: 11.0), 'a', Helper.new.iRecord(balance: 11.0), a)
  assert(m == 10.0, 'm', 10.0, m)
  begin
    m = 100.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == Helper.new.iRecord(balance: 101.0), 'a', Helper.new.iRecord(balance: 101.0), a)
  assert(m == 100.0, 'm', 100.0, m)
end

def test36
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  begin
    y = nil.Test(x)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  assert(y == 6.0, 'y', 6.0, y)
  begin
    always(priority: :medium) do
      x == 10.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 10.0, 'x', 10.0, x)
  assert(y == 6.0, 'y', 6.0, y)
  begin
    always(priority: :required) do
      y == nil.Test(x)
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test40
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    pA = nil.MutablePointNew(10.0, 10.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(pA == Helper.new.iRecord(x: 10.0, y: 10.0), 'pA', Helper.new.iRecord(x: 10.0, y: 10.0), pA)
  begin
    pB = pA
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(pA == Helper.new.iRecord(x: 10.0, y: 10.0), 'pA', Helper.new.iRecord(x: 10.0, y: 10.0), pA)
  assert_identical(pB.object_id == pA.object_id, 'pB', 'pA')
  begin
    pA = nil.MutablePointNew(50.0, 50.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(pA == Helper.new.iRecord(x: 50.0, y: 50.0), 'pA', Helper.new.iRecord(x: 50.0, y: 50.0), pA)
  assert(pB == Helper.new.iRecord(x: 10.0, y: 10.0), 'pB', Helper.new.iRecord(x: 10.0, y: 10.0), pB)
end

def test41
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    p = nil.MutablePointNew(0.0, 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 0.0, y: 0.0), 'p', Helper.new.iRecord(x: 0.0, y: 0.0), p)
  begin
    q = p
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 0.0, y: 0.0), 'p', Helper.new.iRecord(x: 0.0, y: 0.0), p)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
  begin
    always(priority: :required) do
      (p).x == 5.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(p == Helper.new.iRecord(x: 5.0, y: 0.0), 'p', Helper.new.iRecord(x: 5.0, y: 0.0), p)
  assert_identical(q.object_id == p.object_id, 'q', 'p')
  begin
    always(priority: :required) do
      (q).x == 10.0
    end
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(unsat == true, 'unsat', true, unsat)
end

def test42
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = nil.WindowNew()
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == Helper.new.iRecord(window: true), 'x', Helper.new.iRecord(window: true), x)
  begin
    y = x
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == Helper.new.iRecord(window: true), 'x', Helper.new.iRecord(window: true), x)
  assert_identical(y.object_id == x.object_id, 'y', 'x')
  begin
    always {y is? x }
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  begin
    x = nil.CircleNew()
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == Helper.new.iRecord(circle: true), 'x', Helper.new.iRecord(circle: true), x)
  assert_identical(y.object_id == x.object_id, 'y', 'x')
end

def test43
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = nil.WindowNew()
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == Helper.new.iRecord(window: true), 'x', Helper.new.iRecord(window: true), x)
  begin
    y = x
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == Helper.new.iRecord(window: true), 'x', Helper.new.iRecord(window: true), x)
  assert_identical(y.object_id == x.object_id, 'y', 'x')
  begin
    nil.MakeIdentical(x, y)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == Helper.new.iRecord(window: true), 'x', Helper.new.iRecord(window: true), x)
  assert_identical(y.object_id == x.object_id, 'y', 'x')
  begin
    x = nil.CircleNew()
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(y == Helper.new.iRecord(window: true), 'y', Helper.new.iRecord(window: true), y)
  assert(x == Helper.new.iRecord(circle: true), 'x', Helper.new.iRecord(circle: true), x)
end

def test45
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    a = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == 0.0, 'a', 0.0, a)
  begin
    nil.Testalwaysxequal5(a)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(a == 0.0, 'a', 0.0, a)
end

def test46
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    x = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  begin
    y = 0.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  assert(y == 0.0, 'y', 0.0, y)
  begin
    nil.Testalwaysaequalsbplus3(x, y)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 0.0, 'x', 0.0, x)
  assert(y == 0.0, 'y', 0.0, y)
  begin
    x = 10.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 10.0, 'x', 10.0, x)
  assert(y == 0.0, 'y', 0.0, y)
  begin
    y = 10.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(x == 10.0, 'x', 10.0, x)
  assert(y == 10.0, 'y', 10.0, y)
end

def test47
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    q = nil.Point(0.0, 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(q == Helper.new.iRecord(x: 0.0, y: 0.0), 'q', Helper.new.iRecord(x: 0.0, y: 0.0), q)
  begin
    nil.Testpointxequals5(q)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(q == Helper.new.iRecord(x: 0.0, y: 0.0), 'q', Helper.new.iRecord(x: 0.0, y: 0.0), q)
end

def test48
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    q = nil.MutablePointNew(0.0, 0.0)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(q == Helper.new.iRecord(x: 0.0, y: 0.0), 'q', Helper.new.iRecord(x: 0.0, y: 0.0), q)
  begin
    nil.Testpointxequals5(q)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(q == Helper.new.iRecord(x: 5.0, y: 0.0), 'q', Helper.new.iRecord(x: 5.0, y: 0.0), q)
end

def test49
  Z3.const_set(:Instance, Z3.new)
  $last_exception = nil
  unsat = false

  begin
    y = 10.0
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(y == 10.0, 'y', 10.0, y)
  begin
    nil.TestXGetsXPlus3ReturnX(y)
  rescue Exception => e
    unsat = true; $last_exception = e
  end
  assert(y == 10.0, 'y', 10.0, y)
end



errors = []
methods.
  select { |m| m.to_s.start_with? "test" }.
  sort_by { |e| e.to_s.sub("test", "").to_i }.
  each do |m|
  begin
    send(m)
  rescue Exception => e
    errors << e.to_s + ":\n      " + e.backtrace[1..-6].join("\n      ")
  end
end

print "#{errors.size} Errors:\n#{errors.join("\n  ")}\n"
