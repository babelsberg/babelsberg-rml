#!/usr/bin/env ruby

require File.expand_path("../z3_model_parser.rb", __FILE__)

outfile = ARGV[0]


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


if File.exist?(outfile) && File.read(outfile) =~ /^cIIndex := (\d+)$/m
  idx = $1.to_i
else
  idx = 0
end

File.open(outfile, 'w') do |f|
  if ENV["BBBReview"] || ENV["BBBZ3"]
    f << "cIIndex := #{idx + 1}\n"
    puts "\n# #{number} # This is the expected solution:\n#{environments[idx]}"
    if ENV["BBBZ3"]
      puts "\n# #{number} # This is what Z3 produces:"
      system("#{File.expand_path('../../z3', outfile)} -smt2 constraints.smt > constraints.model")
      output = File.read("constraints.model")
      if midx = output.index("(model")
        hash = Z3ModelParser.parse(output[midx..-1])
        model = Z3ModelParser.hash_to_rml_env(hash)
        puts model
        f << model + "\n"
      else
        puts output
      end
    else
      f << environments[idx]
    end
    %x{xterm -e "read -p 'Please review the constraints and solution. Are they ok? (Y/n)' -n 1 -r; echo; if [[ \\$REPLY =~ ^[Nn]$ ]]; then kill #{rakeid}; fi"}
  end
end
