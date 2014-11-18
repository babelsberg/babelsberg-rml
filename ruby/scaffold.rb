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


INSERTHERE


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
