#!/usr/bin/env ruby

require "optparse"
require "ostruct"
require "bundler/setup"
require "handle_rest"

# options = OpenStruct.new
option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} handle"
  opts.on_tail("-h", "--help", "Print this help message") do
    puts opts
    exit 0
  end
end
option_parser.parse!(ARGV)

if ARGV.empty?
  puts option_parser.help
else
  begin
    handle = ARGV[0]
    puts "handle: #{handle}"
    puts "path: #{Turnsole::Handle::Service.path(noid)}"
    puts "url: #{Turnsole::Handle::Service.url(noid)}"
    puts "value: #{Turnsole::Handle::Service.value(noid)}"
  rescue => e
    warn e.message
  end
  exit!(0)
end
