#!/usr/bin/env ruby

require File.expand_path("../find_example", __FILE__)

outfile = ARGV[0]
index = ARGV[1].to_i
solution = FindExample.solution

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
