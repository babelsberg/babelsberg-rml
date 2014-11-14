#!/usr/bin/env ruby

outfile = ARGV[0]
index = ARGV[1].to_i

tree = Hash[*`ps -eo pid,ppid`.scan(/\d+/).map{|x|x.to_i}]
shid = Process.ppid
bbbid = tree[shid]
catid = tree[bbbid]
rakeid = tree[catid]
commandline = `ps -o cmd -fp #{catid}`.lines.to_a.last
example = /cat\s+(.*\d+[a-z]?\.txt)\s+/.match(commandline)[1]
solution = example.sub(/\.txt$/, ".env")
number = solution.split("/").last.sub(/\..*$/,"")

begin
  environments = File.read(solution).split(";\n")
rescue Exception
  environments = []
end

File.open(outfile, 'w') do |f|
  if env = environments[index]
    identities = {}
    objects = {}
    # remove trailing numbers
    env.gsub!(/^([^ ])\d+ :=/, "\\1 :=")
    env = env.lines.map do |line|
      if line =~ /^H\(#(\d+)\) := (.*)$/
        objects[$1] = $2
        nil
      else
        line
      end
    end.compact.map do |line|
      if line =~ /^([^ ]+) := #(\d+)$/
        if identities[$2]
          "#{$1} := H(#{identities[$2]})\n"
        else
          identities[$2] = $1
          "#{$1} := #{objects[$2]}\n"
        end
      else
        line
      end
    end.join

    env.gsub!(/^unsat$/, "unsat := true")

    f << env
  else
    f << "unsat := true"
  end
end
