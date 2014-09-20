require "open3"
require "pp"

ENV["BBBEDITOR"] ||= "xterm -e /usr/bin/nano"

semantics = [:reals, :records]

semantics.each do |s|
  namespace s do
    desc "Build Babelsberg/#{s.to_s.capitalize}"
    task :build do
      Dir.chdir "#{s}" do
        exitcode = system("make babelsberg-#{s}")
        fail unless exitcode
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

    task :citest => :build do
      input = "#{s}/input"
      File.unlink(input) if File.exist?(input)

      Errortest = lambda do |example, output|
        return "#{example}: No input created" unless File.exist?("input")
        lastinput = File.read("input")
        File.unlink("input")

        envinput = example.sub(/txt$/, "env")
        return "#{example}: No environment given" unless File.exist?(envinput)
        environments = File.read(envinput).split(";\n")

        return "#{example}: No CIIndex" unless lastinput =~ /^CIIndex\s*(?::=)?\s*(\d+)/m
        idx = $1.to_i
        return "#{example}: Not all environments used" unless environments.size == idx
        if output.end_with?("Evaluation failed!\n")
          return "#{example}: Unexpected failure" unless environments.last =~ /unsat/
        end
      end

      ENV["BBBEDITOR"] = File.expand_path("../#{s}/cisolver.rb", __FILE__)
      Rake::Task["#{s}:test"].invoke
    end
  end
end

Errortest = lambda do |example, output|
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
  error = Errortest[example, output]
  errors << "\t#{error}\n" if error
end
