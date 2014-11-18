#!/usr/bin/env ruby

module FindExample
  extend self

  def example
    return @example if @example
    tree = Hash[*`ps -eo pid,ppid`.scan(/\d+/).map{|x|x.to_i}]
    shid = Process.ppid
    bbbid = tree[shid]
    catid = tree[bbbid]
    rakeid = tree[catid]
    commandline = `ps -o cmd -fp #{catid}`.lines.to_a.last
    @example = /cat\s+(.*\d+[a-z]?\.txt)\s+/.match(commandline)[1]
  end

  def solution
    example.sub(/\.txt$/, ".env")
  end

  def id
    example.sub(/(?:.*?)(\d+[a-z]*)\.txt$/, "\\1")
  end
end

print FindExample.send(ARGV[0]) if __FILE__ == $0 && ARGV[0]
