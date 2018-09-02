require 'yaml'
require_relative './analisador_lexico/Analyzer.rb'

scan = Analyzer.new(YAML.load_file(File.join(__dir__, './analisador_lexico/rules.yml')))

# p =scan.tokenizer("aaa #ok #aa *jjj #sakjhdasjdk blablabla")
# puts p
p = scan.tokenizer_file('./analisador_lexico/teste.nsp')
puts p
# File.open("./analisador_lexico/teste.nsp", "r").each_line do |line|
#       puts line
# end

# a.each do |k,l|
# puts "#{a} - #{l}"
# puts "-------------------------"
# end