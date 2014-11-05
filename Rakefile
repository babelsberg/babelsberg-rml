require "open3"
require "pp"

ENV["BBBEDITOR"] ||= "xterm -e /usr/bin/nano"

semantics = [:reals, :records, :uid, :objects]

semantics.each do |s|
  namespace s do
    desc "Build Babelsberg/#{s.to_s.capitalize}"
    task :build do
      Dir.chdir "#{s}" do
        exitcode = system("make babelsberg-#{s}")
        fail unless exitcode
      end
    end

    desc "Run Babelsberg/#{s.to_s.capitalize}/program.txt"
    task :program => [:build] do |t, args|
      Dir.chdir "#{s}" do
        run_example(s, "program.txt", [])
      end
    end

    desc "Run paper examples for Babelsberg/#{s.to_s.capitalize}"
    task :test, [:example] => [:build] do |t, args|
      errors = []
      Dir.chdir "#{s}" do
        if args[:example]
          run_example(s, "examples/#{args[:example]}.txt", errors)
        else
          Dir["examples/*.txt"].sort_by {|a| a.split("/").last.to_i }.each do |example|
            run_example(s, example, errors)
          end
        end
      end
      if errors.any?
        puts "The following programs failed:\n#{errors.join}"
        fail
      end
    end

    task :citest, [:example] => :build do |t, args|
      input = "#{s}/input"
      File.unlink(input) if File.exist?(input)

      $Errortest = lambda do |example, output|
        if File.exist?(example.sub(/txt$/, "illegal"))
          return "#{example}: Illegal, but didn't fail" unless output =~ /Evaluation failed!/
          if File.exist?("input")
            lastinput = File.read("input")
            File.unlink("input")
            envinput = example.sub(/txt$/, "env")
            return "#{example}: No environment given" unless File.exist?(envinput)
            environments = File.read(envinput).split(";\n")
            return "#{example}: No CIIndex" unless lastinput =~ /^[Cc]IIndex\s*(?::=)?\s*(\d+)/m
            idx = $1.to_i
            return "#{example}: Not all environments used" unless environments.size == idx
          end
          return nil
        else
          return "#{example}: No input created" unless File.exist?("input")
          lastinput = File.read("input")
          File.unlink("input")

          envinput = example.sub(/txt$/, "env")
          return "#{example}: No environment given" unless File.exist?(envinput)
          environments = File.read(envinput).split(";\n")

          return "#{example}: No CIIndex" unless lastinput =~ /^[cC]IIndex\s*(?::=)?\s*(\d+)/m
          idx = $1.to_i
          return "#{example}: Not all environments used" unless environments.size == idx
          if output =~ /Evaluation failed!/
            return "#{example}: Unexpected failure" unless environments.last =~ /unsat/
          end
        end
      end

      ENV["BBBEDITOR"] = File.expand_path("../#{s}/cisolver.rb", __FILE__)
      Rake::Task["#{s}:test"].invoke(args[:example])
    end

    desc "Review the example and 'play solver'"
    task :review, [:example] => :build do |t, args|
      ENV["BBBReview"] = "true"
      Rake::Task["#{s}:citest"].invoke(args[:example])
    end

    if s == :objects
      desc "Review the example and Z3's solution"
      task :z3, [:example] => :build do |t, args|
        ENV["BBBZ3"] = "true"
        Rake::Task["#{s}:citest"].invoke(args[:example])
      end
    end
  end
end

$Errortest = lambda do |example, output|
  return example if output.end_with?("Evaluation failed!\n")
end

def run_example(s, example, errors)
  puts "Program #{example}:"
  puts File.read example
  output = ""
  Open3.popen3("cat #{example} | ./babelsberg-#{s}") do |stdin, stdout, stderr|
    ios = [stdout, stderr]
    until stdout.eof? and stderr.eof?
      ready = IO.select(ios)
      ready[0].each do |io|
        (ios.delete(io); next) if io.eof?
        result = io.read_nonblock(1024)
        print result
        output << result
      end
    end
  end
  error = $Errortest[example, output]
  errors << "\t#{error}\n" if error
end
