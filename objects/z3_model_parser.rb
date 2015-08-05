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
      elsif k =~ /^(?:[vi]Rec|invalidR)$/
        acc
      else
        v = value_to_rml(kv[1])
        acc + ["#{k} := #{v}"]
      end
    end.sort_by {|a| a =~ /(\d+)/; $1.to_i }.reject(&:empty?).join("\n")
  end

  def value_to_rml(v)
    if Hash === v
      "{" + v.inject([]) do |acc2,kv2|
        acc2 + ["#{kv2[0]}: #{value_to_rml(kv2[1])}"]
      end.sort.join(", ") + "}"
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
    if value =~ /^\s*\(String 1(\d+)\.0\)\s*$/
      # magic string encoding...
      $1.split(/(...)/).reject(&:empty?).map(&:to_i).map(&:chr).join
    elsif value =~ /^\s*\(Real (\d+\.\d+)\)\s*$/
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
    elsif value =~ /^\s*\(Record \(_ as-array (k!\d+)\)\)\s*$/
      transform_ite(env, env[$1])
    elsif value =~ /^\s*\(_ as-array (k!\d+)\)\s*$/
      transform_ite(env, env[$1])
    elsif value =~ /ite/
      transform_ite(env, value)
    elsif value =~ /^\s*\(Record \(store/
      transform_store(env, value)
    else
      value
    end
  end

  def transform_store(env, str)
    record = {}
    regexp = /([\w]+) (\d+\.\d+)/
    s = str
    while md = regexp.match(s)
      s = md.post_match
      next if md[1] == "undef"
      record[simplify_value(env, md[1])] = simplify_value(env, md[2])
    end
    record
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
