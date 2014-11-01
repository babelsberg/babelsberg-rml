#!/usr/bin/env ruby

outfile = ARGV[0]


tree = Hash[*`ps -eo pid,ppid`.scan(/\d+/).map{|x|x.to_i}]
shid = Process.ppid
bbbid = tree[shid]
catid = tree[bbbid]
rakeid = tree[catid]
commandline = `ps -o cmd -fp #{catid}`.lines.to_a.last
example = /cat\s+(.*\d+\.txt)\s+/.match(commandline)[1]
solution = example.sub(/\.txt$/, ".env")

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
  f << environments[idx]
  if ENV["BBBReview"]
    puts "\nSolution:\n#{environments[idx]}"
    %x{xterm -e "read -p 'Please review the constraints and solution. Are they ok? (Y/n)' -n 1 -r; echo; if [[ \\$REPLY =~ ^[Nn]$ ]]; then kill #{rakeid}; fi"}
  elsif ENV["BBBZ3"]
    puts "\nSolution:\n#{environments[idx]}"
    system("#{File.expand_path('../../z3', outfile)} -smt2 constraints.smt")
    %x{xterm -e "read -p 'Please review the constraints and solution. Are they ok? (Y/n)' -n 1 -r; echo; if [[ \\$REPLY =~ ^[Nn]$ ]]; then kill #{rakeid}; fi"}
  end

  f << "cIIndex := #{idx + 1}\n"
end
