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
  f << "cIIndex := #{idx + 1}\n"
  if ENV["BBBReview"] || ENV["BBBZ3"]
    puts "\n# #{number} # This is the expected solution:\n#{environments[idx]}"
    if ENV["BBBZ3"]
      puts "\n# #{number} # This is what Z3 produces:"

      # optional patches to the constraints.smt before running z3
      z3patch = example.sub(/\.txt$/, ".z3rb")
      begin; load z3patch; rescue Exception; end

      system("#{File.expand_path('../../z3', outfile)} -smt2 constraints.smt > constraints.model")
      output = File.read("constraints.model")
      if midx = output.index("(model")
        hash = Z3ModelParser.parse(output[midx..-1])
        model = Z3ModelParser.hash_to_rml_env(hash)
        puts model
        if ENV["BBBZ3FB"]
          f << environments[idx]
        else
          f << model + "\n"
        end
      else
        puts output
      end
    else
      f << environments[idx]
    end
    unless ENV["BBBZ3Auto"]
      %x{xterm -e "read -p 'Please review the constraints and solution. Are they ok? (Y/n)' -n 1 -r; echo; if [[ \\$REPLY =~ ^[Nn]$ ]]; then kill #{rakeid}; fi"}
    end
    if ENV["BBBZ3AutoCompare"]
      shortmodel = model.lines.map { |l| l.gsub(" ", "").strip }
      shortmodel += shortmodel.map do |l|
        l.gsub(".0", "") # use ints
      end
      environments[idx].lines.each do |line|
        next if line.strip.empty?
        unless shortmodel.include? line.gsub(" ", "").strip
          e = "ERROR: Z3 model does not check out! #{line.gsub(" ", "")} not found in #{shortmodel}"
          puts e
          f << e
        end
      end
    end
  else
    f << environments[idx]
  end
end
