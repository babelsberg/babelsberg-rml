require "pp"

semantics = [:reals]

semantics.each do |s|
  namespace s do
    desc "Build Babelsberg/#{s.to_s.capitalize}"
    task :build do
      Dir.chdir "#{s}" do
        exitcode = system("make")
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
      puts "The following programs failed:"
      pp errors
    end
  end
end

def run_example(s, example, errors)
  puts "Program #{example}:"
  puts File.read example
  exitcode = system "cat #{example} | ./babelsberg-#{s}"
  errors << example if exitcode != 0
end
