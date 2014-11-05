require "pp"

module Z3ModelParser
  extend self

  def parse(str)
    raise "no model!" unless str.start_with?("(model")
    env = read_environment(str)
    simple_env = simplify_env(env)
    remove_temps(simple_env)
  end

  def hash_to_rml_env(hash)
    hash.each_pair.inject([]) do |acc,kv|
      k = kv[0]
      if k == "H"
        acc + [kv[1].inject([]) do |heapacc, object|
          ref = object[0]
          key = value_to_rml(object[1])
          heapacc + ["H(#{ref}) := #{key}"]
        end.join("\n")]
      elsif k =~ /^[vi]Rec$/
        acc
      else
        v = value_to_rml(kv[1])
        acc + ["#{k} := #{v}"]
      end
    end.join("\n")
  end

  def value_to_rml(v)
    if Hash === v
      "{" + v.inject([]) do |acc2,kv2|
        acc2 + ["#{kv2[0]}: #{value_to_rml(kv2[1])}"]
      end.join(", ") + "}"
    else
      v
    end
  end

  def remove_temps(env)
    Hash[*env.each_pair.map do |key, value|
      if key =~ /!/
        nil
      else
        [key, value]
      end
    end.flatten.compact]
  end

  def simplify_env(env)
    Hash[*env.each_pair.map do |key, value|
      [key, simplify_value(env, value)]
    end.flatten.compact]
  end

  def simplify_value(env, value)
    if value =~ /^\s*\(Real (\d+\.\d+)\)\s*$/
      $1
    elsif value =~ /^\s*\(Real \(\- (\d+\.\d+)\)\)\s*$/
      "-#{$1}"
    elsif value =~ /^\s*\(\- (\d+\.\d+)\)\s*$/
      "-#{$1}"
    elsif value =~ /^\s*\(Reference ref(\d+)\)\s*$/
      "##{$1}"
    elsif value =~ /^\s*\(Reference nil\)\s*$/
      "nil"
    elsif value =~ /^\s*\(Bool (\w+)\)\s*$/
      $1
    elsif value =~ /^\s*\(Record \(_ as-array (k!\d)\)\)\s*$/
      transform_ite(env, env[$1])
    elsif value =~ /^\s*\(_ as-array (k!\d)\)\s*$/
      transform_ite(env, env[$1])
    elsif value =~ /ite/
      transform_ite(env, value)
    else
      value
    end
  end

  def transform_ite(env, str)
    record = {}
    regexp = /ite \(= \w!\d (\(?[\w\s\d]+\)?)\) ([^\n]+)\n/m
    s = str
    while md = regexp.match(s)
      s = md.post_match
      next if md[1] == "undef"
      record[simplify_value(env, md[1])] = simplify_value(env, md[2])
    end
    record
  end

  def read_environment(str)
    env = {}
    pos = "(model".size
    while pos < str.size
      pos, fun = read_fun(pos, str)
      key, value = parse_fun(fun)
      env[key] = value
    end
    env
  end

  def read_fun(pos, str)
    i = str.index("(", pos)
    return str.size, nil if i.nil?
    open = 1
    ((i + 1)..str.size).each do |idx|
      c = str[idx]
      case c
      when "(" then open += 1
      when ")" then open -= 1
      end
      return idx, str[i..idx] if open == 0
    end
    return str.size, nil
  end

  def parse_fun(sexp)
    sexp =~ /^\(define-fun ([^ ]+) (?:\((?:\([^\)]+\))?\)) (?:[A-Za-z]+|\([^\)]+\))?\s+(.*)\)$/m
    return $1, $2
  end

end

hash = Z3ModelParser.parse("(model
  (define-fun y129 () Value
    (Real 2.0))
  (define-fun self24 () Value
    (Reference ref7))
  (define-fun vRec () (Array Label Real)
    (_ as-array k!1))
  (define-fun scale102 () Value
    (Real 2.0))
  (define-fun self127 () Value
    (Reference nil))
  (define-fun self103 () Value
    (Reference nil))
  (define-fun self91 () Value
    (Record (_ as-array k!4)))
  (define-fun pt92 () Value
    (Record (_ as-array k!2)))
  (define-fun self101 () Value
    (Record (_ as-array k!7)))
  (define-fun iRec () (Array Label Value)
    (_ as-array k!0))
  (define-fun x104 () Value
    (Real 2.0))
  (define-fun y105 () Value
    (Real 2.0))
  (define-fun r0 () Value
    (Reference ref7))
  (define-fun self93 () Value
    (Reference nil))
  (define-fun x128 () Value
    (Real 2.0))
  (define-fun ref7_lower_right () Value
    (Record (_ as-array k!2)))
  (define-fun ref7_upper_left () Value
    (Record (_ as-array k!4)))
  (define-fun y95 () Value
    (Real 4.0))
  (define-fun self85 () Value
    (Reference ref7))
  (define-fun x94 () Value
    (Real 4.0))
  (define-fun invalidR () Real
    1334.0)
  (define-fun self125 () Value
    (Record (_ as-array k!9)))
  (define-fun other126 () Value
    (Record (_ as-array k!9)))
  (define-fun k!6 ((x!1 Label)) Real
    (ite (= x!1 y) 4.0
      1334.0))
  (define-fun k!3 ((x!1 Label)) Value
    (ite (= x!1 lower_right) (Record (_ as-array k!2))
      (Reference invalid)))
  (define-fun k!0 ((x!1 Label)) Value
    (Reference invalid))
  (define-fun k!8 ((x!1 Label)) Real
    (ite (= x!1 y) 2.0
      1334.0))
  (define-fun k!5 ((x!1 Label)) Value
    (ite (= x!1 upper_left) (Record (_ as-array k!4))
    (ite (= x!1 lower_right) (Record (_ as-array k!2))
      (Reference invalid))))
  (define-fun k!2 ((x!1 Label)) Real
    (ite (= x!1 y) (- 7715.0)
    (ite (= x!1 undef) 7.0
    (ite (= x!1 x) (- 96.0)
      6.0))))
  (define-fun k!7 ((x!1 Label)) Real
    (ite (= x!1 y) 4.0
    (ite (= x!1 x) 4.0
      1334.0)))
  (define-fun H ((x!1 Value)) (Array Label Value)
    (ite (= x!1 (Reference ref7)) (_ as-array k!5)
      (_ as-array k!0)))
  (define-fun k!4 ((x!1 Label)) Real
    (ite (= x!1 y) 7719.0
    (ite (= x!1 undef) 8.0
    (ite (= x!1 x) 100.0
      1.0))))
  (define-fun k!1 ((x!1 Label)) Real
    1334.0)
  (define-fun k!9 ((x!1 Label)) Real
    (ite (= x!1 y) 2.0
    (ite (= x!1 x) 2.0
      1334.0)))
)")
puts Z3ModelParser.hash_to_rml_env(hash)
